package com.drumstore.web.repositories;

import com.drumstore.web.dto.*;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.util.*;

public class ProductRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<ProductDashboardDTO> all() {
        String sql = """
                    SELECT
                        p.id,
                        p.name,
                        p.basePrice,
                        c.name AS categoryName,
                        b.name AS brandName,
                        p.totalViews,
                        p.featured,
                        p.status,
                        COALESCE(pv.total_stock, 0) as stock,
                        COALESCE(pc.total_colors, 0) as totalColors,
                        COALESCE(pa.total_addons, 0) as totalAddons,
                        COALESCE(pv.total_variants, 0) as totalVariants,
                        COALESCE(pr.total_reviews, 0) as totalReviews,
                        COALESCE(pr.avg_rating, 0) as avgRating,
                        (
                            SELECT image
                            FROM product_images
                            WHERE productId = p.id AND main = 1
                            LIMIT 1
                        ) as mainImage,
                        p.createdAt
                    FROM products p
                    LEFT JOIN categories c ON p.categoryId = c.id
                    LEFT JOIN brands b ON p.brandId = b.id
                    LEFT JOIN (
                        SELECT productId, COUNT(*) as total_colors
                        FROM product_colors
                        GROUP BY productId
                    ) pc ON p.id = pc.productId
                    LEFT JOIN (
                        SELECT productId, COUNT(*) as total_addons
                        FROM product_addons
                        GROUP BY productId
                    ) pa ON p.id = pa.productId
                    LEFT JOIN (
                        SELECT
                            productId,
                            COUNT(*) as total_variants,
                            SUM(stock) as total_stock
                        FROM product_variants
                        WHERE status = 1
                        GROUP BY productId
                    ) pv ON p.id = pv.productId
                    LEFT JOIN (
                        SELECT
                            productId,
                            COUNT(*) as total_reviews,
                            AVG(rating) as avg_rating
                        FROM product_reviews
                        WHERE status = 1
                        GROUP BY productId
                    ) pr ON p.id = pr.productId
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(ProductDashboardDTO.class)
                        .list()
        );
    }

    public ProductDashboardDetailDTO findById(int id) {
        String sql = """
                WITH ProductColors AS (
                    SELECT * FROM product_colors WHERE productId = :id
                ),
                ProductAddons AS (
                    SELECT * FROM product_addons WHERE productId = :id
                ),
                MaxDiscount AS (
                    SELECT productId, MAX(s.discountPercentage) as maxDiscount
                    FROM product_sales ps
                    JOIN sales s ON ps.saleId = s.id
                    WHERE NOW() BETWEEN s.startDate AND s.endDate
                    GROUP BY productId
                )
                SELECT
                    p.id AS p_id,
                    p.name AS p_name,
                    p.description AS p_description,
                    p.basePrice AS p_basePrice,
                    p.totalViews AS p_totalViews,
                    p.featured AS p_featured,
                    p.status AS p_status,
                    p.stockManagementType AS p_stockManagementType,
                    (SELECT AVG(rating) FROM product_reviews WHERE productId = p.id AND status = 1) AS p_averageRating,
                    (SELECT COUNT(*) FROM product_reviews WHERE productId = p.id AND status = 1) AS p_totalReviews,
                    COALESCE((SELECT SUM(stock) FROM product_variants WHERE productId = p.id AND status = 1), 0) AS p_totalStock,
                    COALESCE((SELECT COUNT(*) FROM product_variants WHERE productId = p.id AND status = 1), 0) AS p_totalVariants,
                    p.createdAt AS p_createdAt,
                    pi.id AS pi_id,
                    pi.image AS pi_image,
                    pi.main AS pi_main,
                    pi.sortOrder AS pi_sortOrder,
                    pc.id AS pc_id,
                    pc.name AS pc_name,
                    pr.id AS pr_id,
                    pr.rating AS pr_rating,
                    pr.content AS pr_content,
                    pr.status AS pr_status,
                    pr.createdAt AS pr_createdAt,
                    c.name AS c_name,
                    b.name AS b_name,
                    s.id AS s_id,
                    s.name AS s_name,
                    s.discountPercentage AS s_discountPercentage,
                    s.startDate AS s_startDate,
                    s.endDate AS s_endDate
                FROM products p
                LEFT JOIN product_images pi ON p.id = pi.productId
                LEFT JOIN ProductColors pc ON p.id = pc.productId
                LEFT JOIN product_reviews pr ON p.id = pr.productId AND pr.status = 1
                LEFT JOIN categories c ON p.categoryId = c.id
                LEFT JOIN brands b ON p.brandId = b.id
                LEFT JOIN product_sales ps ON p.id = ps.productId
                LEFT JOIN sales s ON ps.saleId = s.id
                    AND NOW() BETWEEN s.startDate AND s.endDate
                WHERE p.id = :id""";

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .registerRowMapper(BeanMapper.factory(ProductDashboardDetailDTO.class, "p"))
                .registerRowMapper(BeanMapper.factory(ProductImageDTO.class, "pi"))
                .registerRowMapper(BeanMapper.factory(ProductColorDTO.class, "pc"))
                .registerRowMapper(BeanMapper.factory(ProductReviewDTO.class, "pr"))
                .registerRowMapper(BeanMapper.factory(ProductSaleDTO.class, "s"))
                .reduceRows(new LinkedHashMap<Integer, ProductDashboardDetailDTO>(), (map, row) -> {
                    ProductDashboardDetailDTO dto = map.computeIfAbsent(
                            row.getColumn("p_id", Integer.class),
                            _ -> {
                                ProductDashboardDetailDTO newDto = row.getRow(ProductDashboardDetailDTO.class);
                                newDto.setImages(new ArrayList<>());
                                newDto.setColors(new ArrayList<>());
                                newDto.setReviews(new ArrayList<>());
                                newDto.setSales(new ArrayList<>());

                                newDto.setCategoryName(row.getColumn("c_name", String.class));
                                newDto.setBrandName(row.getColumn("b_name", String.class));

                                return newDto;
                            }
                    );

                    // Map ProductImage
                    if (row.getColumn("pi_id", Integer.class) != null) {
                        ProductImageDTO image = row.getRow(ProductImageDTO.class);
                        if (dto.getImages().stream().noneMatch(img -> img.getId() == image.getId())) {
                            dto.getImages().add(image);
                        }
                    }

                    // Map ProductColor
                    if (row.getColumn("pc_id", Integer.class) != null) {
                        ProductColorDTO color = row.getRow(ProductColorDTO.class);
                        if (dto.getColors().stream().noneMatch(c -> c.getId() == color.getId())) {
                            dto.getColors().add(color);
                        }
                    }

                    // Map ProductReview
                    if (row.getColumn("pr_id", Integer.class) != null) {
                        ProductReviewDTO review = row.getRow(ProductReviewDTO.class);
                        if (dto.getReviews().stream().noneMatch(r -> r.getId() == review.getId())) {
                            dto.getReviews().add(review);
                        }
                    }

                    // Map Sale
                    if (row.getColumn("s_id", Integer.class) != null) {
                        ProductSaleDTO sale = row.getRow(ProductSaleDTO.class);
                        if (dto.getSales().stream().noneMatch(s -> s.getId() == sale.getId())) {
                            dto.getSales().add(sale);
                        }
                    }

                    return map;
                })
                .values()
                .stream()
                .findFirst()
                .orElse(null));
    }

    public int countFilteredProducts(String search, String category, String brand, String priceRange) {
        StringBuilder sql = new StringBuilder("""
                    SELECT COUNT(*) FROM products p
                    WHERE 1=1
                """);
        List<Object> params = new ArrayList<>();

        // Thêm điều kiện tìm kiếm
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        // Thêm điều kiện category
        if (category != null && !category.isEmpty()) {
            sql.append(" AND p.categoryId = ?");
            params.add(Integer.parseInt(category));
        }

        // Thêm điều kiện brand
        if (brand != null && !brand.isEmpty()) {
            sql.append(" AND p.brandId = ?");
            params.add(Integer.parseInt(brand));
        }

        // Thêm điều kiện khoảng giá
        if (priceRange != null && !priceRange.isEmpty()) {
            String[] prices = priceRange.split("-");
            if (prices.length == 2) {
                sql.append(" AND p.price BETWEEN ? AND ?");
                params.add(Double.parseDouble(prices[0]));
                params.add(Double.parseDouble(prices[1]));
            }
        }

        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }
            return query.mapTo(Integer.class).one();
        });
    }

    public List<ProductCardDTO> getFilteredProductCards(int offset, int limit, String search, String category, String brand, String priceRange, String sortBy) {
        StringBuilder sql = new StringBuilder("""
                WITH FilteredProducts AS (
                    SELECT
                        p.id AS p_id,
                        p.name AS p_name,
                        p.basePrice AS p_basePrice,
                        p.totalViews AS p_totalViews,
                        p.categoryId AS p_categoryId,
                        p.featured AS p_featured,
                        p.brandId AS p_brandId,
                        p.stockManagementType AS p_stockManagementType,
                        (SELECT MAX(s.discountPercentage)
                         FROM product_sales ps
                                  JOIN sales s ON ps.saleId = s.id
                         WHERE ps.productId = p.id
                           AND CURRENT_DATE BETWEEN s.startDate AND s.endDate) AS max_discount,
                        (SELECT COALESCE(AVG(pr.rating), 0)
                         FROM product_reviews pr
                         WHERE pr.productId = p.id
                           AND pr.status = 1) AS p_averageRating,
                        (SELECT COUNT(*)
                         FROM product_reviews pr
                         WHERE pr.productId = p.id
                           AND pr.status = 1) AS p_totalReviews,
                        (SELECT MIN(
                                        CASE
                                            WHEN p.stockManagementType = 0 THEN p.basePrice
                                            WHEN p.stockManagementType = 1 THEN p.basePrice + COALESCE(pc.additionalPrice, 0)
                                            WHEN p.stockManagementType = 2 THEN p.basePrice + COALESCE(pa.additionalPrice, 0)
                                            ELSE p.basePrice + COALESCE(pc.additionalPrice, 0) + COALESCE(pa.additionalPrice, 0)
                                            END)
                         FROM product_variants pv
                                  LEFT JOIN product_colors pc ON pv.colorId = pc.id
                                  LEFT JOIN product_addons pa ON pv.addonId = pa.id
                         WHERE pv.productId = p.id
                           AND pv.status = 1) AS lowest_variant_price
                    FROM products p
                    WHERE p.status = 1
                """);

        List<Object> params = new ArrayList<>();

        // Thêm các điều kiện tìm kiếm
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (p.name LIKE ? OR p.description LIKE ?)");
            params.add("%" + search + "%");
            params.add("%" + search + "%");
        }

        if (category != null && !category.isEmpty()) {
            sql.append(" AND p.categoryId = ?");
            params.add(Integer.parseInt(category));
        }

        if (brand != null && !brand.isEmpty()) {
            sql.append(" AND p.brandId = ?");
            params.add(Integer.parseInt(brand));
        }

        if (priceRange != null && !priceRange.isEmpty()) {
            String[] prices = priceRange.split("-");
            if (prices.length == 2) {
                sql.append(" AND p.basePrice BETWEEN ? AND ?");
                params.add(Double.parseDouble(prices[0]));
                params.add(Double.parseDouble(prices[1]));
            }
        }

        // Thêm ORDER BY và LIMIT
        if (sortBy != null && !sortBy.isEmpty()) {
            switch (sortBy) {
                case "name_asc" -> sql.append(" ORDER BY p.name ASC");
                case "name_desc" -> sql.append(" ORDER BY p.name DESC");
                case "price_asc" -> sql.append(" ORDER BY p.price ASC");
                case "price_desc" -> sql.append(" ORDER BY p.price DESC");
                default -> sql.append(" ORDER BY p.createdAt DESC");
            }
        } else {
            sql.append(" ORDER BY p.createdAt DESC");
        }

        sql.append(" LIMIT ? OFFSET ?");
        params.add(limit);
        params.add(offset);

        // JOIN với các bảng liên quan
        sql.append("""
                    )
                    SELECT
                    p.p_id AS id,
                    p.p_name AS name,
                    p.p_basePrice AS basePrice,
                    p.p_totalViews AS totalViews,
                    p.p_averageRating AS averageRating,
                    p.p_totalReviews AS totalReviews,
                    p.p_featured AS featured,
                    (SELECT image
                     FROM product_images
                     WHERE productId = p.p_id
                       AND main = 1
                     LIMIT 1) AS mainImage,
                    c.id AS categoryId,
                    c.name AS categoryName,
                    b.id AS brandId,
                    b.name AS brandName,
                    p.max_discount AS discountPercent,
                    CASE
                        WHEN p.max_discount IS NOT NULL
                            THEN p.lowest_variant_price * (1 - p.max_discount/100)
                        ELSE p.lowest_variant_price
                        END AS lowestSalePrice
                FROM FilteredProducts p
                         LEFT JOIN categories c ON p.p_categoryId = c.id
                         LEFT JOIN brands b ON p.p_brandId = b.id""");
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                query.bind(i, params.get(i));
            }

            return query.map((rs, _) -> ProductCardDTO.builder()
                    .id(rs.getInt("id"))
                    .name(rs.getString("name"))
                    .mainImage(rs.getString("mainImage"))
                    .basePrice(rs.getDouble("basePrice"))
                    .featured(rs.getBoolean("featured"))
                    .lowestSalePrice(rs.getDouble("lowestSalePrice"))
                    .averageRating(rs.getDouble("averageRating"))
                    .totalViews(rs.getInt("totalViews"))
                    .totalReviews(rs.getInt("totalReviews"))
                    .categoryId(rs.getInt("categoryId"))
                    .categoryName(rs.getString("categoryName"))
                    .brandId(rs.getInt("brandId"))
                    .brandName(rs.getString("brandName"))
                    .discountPercent(rs.getDouble("discountPercent"))
                    .build()).list();
        });
    }

    public ProductDetailDTO findProductDetail(int id) {
        String sql = """
                WITH ProductColors AS (
                    SELECT * FROM product_colors WHERE productId = :id
                ),
                ProductAddons AS (
                    SELECT * FROM product_addons WHERE productId = :id
                ),
                MaxDiscount AS (
                    SELECT productId, MAX(s.discountPercentage) as maxDiscount
                    FROM product_sales ps
                    JOIN sales s ON ps.saleId = s.id
                    WHERE NOW() BETWEEN s.startDate AND s.endDate
                    GROUP BY productId
                )
                SELECT
                    p.id AS p_id,
                    p.name AS p_name,
                    p.description AS p_description,
                    p.basePrice AS p_basePrice,
                    p.totalViews AS p_totalViews,
                    p.featured AS p_featured,
                    p.status AS p_status,
                    p.stockManagementType AS p_stockManagementType,
                    (SELECT AVG(rating) FROM product_reviews WHERE productId = p.id AND status = 1) AS p_averageRating,
                    (SELECT COUNT(*) FROM product_reviews WHERE productId = p.id AND status = 1) AS p_totalReviews,
                    p.createdAt AS p_createdAt,
                    pi.id AS pi_id,
                    pi.image AS pi_image,
                    pi.main AS pi_main,
                    pi.sortOrder AS pi_sortOrder,
                    pc.id AS pc_id,
                    pc.name AS pc_name,
                    pc.additionalPrice AS pc_additionalPrice,
                    pa.id AS pa_id,
                    pa.name AS pa_name,
                    pa.additionalPrice AS pa_additionalPrice,
                    pv.id AS pv_id,
                    pv.stock AS pv_stock,
                    pv.status AS pv_status,
                    pv.colorId AS pv_colorId,
                    pv.addonId AS pv_addonId,
                    pv.imageId AS pv_imageId,
                    pr.id AS pr_id,
                    pr.userId AS pr_userId,
                    pr.orderId AS pr_orderId,
                    pr.rating AS pr_rating,
                    pr.content AS pr_content,
                    pr.status AS pr_status,
                    pr.createdAt AS pr_createdAt,
                    u.fullname AS pr_userName,
                    u.avatar AS pr_userAvatar,
                    c.id AS c_id,
                    c.name AS c_name,
                    b.id AS b_id,
                    b.name AS b_name,
                    s.id AS s_id,
                    s.name AS s_name,
                    s.discountPercentage AS s_discountPercentage,
                    s.startDate AS s_startDate,
                    s.endDate AS s_endDate,
                    CASE
                        WHEN md.maxDiscount IS NOT NULL
                        THEN p.basePrice * (1 - md.maxDiscount/100)
                        ELSE p.basePrice
                    END AS p_salePrice,
                    COALESCE(md.maxDiscount, 0) AS p_discountPercent
                FROM products p
                LEFT JOIN product_images pi ON p.id = pi.productId
                LEFT JOIN product_variants pv ON p.id = pv.productId AND pv.status = 1
                LEFT JOIN ProductColors pc ON pc.id = pv.colorId
                LEFT JOIN ProductAddons pa ON pa.id = pv.addonId
                LEFT JOIN product_reviews pr ON p.id = pr.productId AND pr.status = 1
                LEFT JOIN users u ON pr.userId = u.id
                LEFT JOIN categories c ON p.categoryId = c.id
                LEFT JOIN brands b ON p.brandId = b.id
                LEFT JOIN product_sales ps ON p.id = ps.productId
                LEFT JOIN sales s ON ps.saleId = s.id
                    AND NOW() BETWEEN s.startDate AND s.endDate
                LEFT JOIN MaxDiscount md ON md.productId = p.id
                WHERE p.id = :id AND p.status = 1
                """;

        return jdbi.withHandle(handle -> {
            Map<Integer, ProductColorDTO> colorMap = new HashMap<>();
            Map<Integer, ProductAddonDTO> addonMap = new HashMap<>();
            Map<Integer, ProductVariantDTO> variantMap = new HashMap<>();

            return handle.createQuery(sql)
                    .bind("id", id)
                    .registerRowMapper(BeanMapper.factory(ProductDetailDTO.class, "p"))
                    .registerRowMapper(BeanMapper.factory(ProductImageDTO.class, "pi"))
                    .registerRowMapper(BeanMapper.factory(ProductColorDTO.class, "pc"))
                    .registerRowMapper(BeanMapper.factory(ProductAddonDTO.class, "pa"))
                    .registerRowMapper(BeanMapper.factory(ProductVariantDTO.class, "pv"))
                    .registerRowMapper(BeanMapper.factory(ProductReviewDTO.class, "pr"))
                    .registerRowMapper(BeanMapper.factory(ProductSaleDTO.class, "s"))
                    .reduceRows(new LinkedHashMap<Integer, ProductDetailDTO>(), (map, row) -> {
                        ProductDetailDTO dto = map.computeIfAbsent(
                                row.getColumn("p_id", Integer.class),
                                _ -> {
                                    ProductDetailDTO newDto = row.getRow(ProductDetailDTO.class);
                                    newDto.setImages(new ArrayList<>());
                                    newDto.setVariants(new ArrayList<>());
                                    newDto.setReviews(new ArrayList<>());
                                    newDto.setSales(new ArrayList<>());

                                    newDto.setCategoryId(row.getColumn("c_id", Integer.class));
                                    newDto.setCategoryName(row.getColumn("c_name", String.class));
                                    newDto.setBrandId(row.getColumn("b_id", Integer.class));
                                    newDto.setBrandName(row.getColumn("b_name", String.class));

                                    return newDto;
                                }
                        );

                        // Map ProductImage
                        if (row.getColumn("pi_id", Integer.class) != null) {
                            ProductImageDTO image = row.getRow(ProductImageDTO.class);
                            if (dto.getImages().stream().noneMatch(img -> img.getId() == image.getId())) {
                                dto.getImages().add(image);
                            }
                        }

                        // Map ProductColor
                        if (row.getColumn("pc_id", Integer.class) != null) {
                            ProductColorDTO color = row.getRow(ProductColorDTO.class);
                            colorMap.put(color.getId(), color);
                        }

                        // Map ProductAddon
                        if (row.getColumn("pa_id", Integer.class) != null) {
                            ProductAddonDTO addon = row.getRow(ProductAddonDTO.class);
                            addonMap.put(addon.getId(), addon);
                        }

                        // Map ProductVariant
                        if (row.getColumn("pv_id", Integer.class) != null) {
                            Integer variantId = row.getColumn("pv_id", Integer.class);

                            // Chỉ tạo variant mới nếu chưa tồn tại trong map
                            if (!variantMap.containsKey(variantId)) {
                                ProductVariantDTO v = row.getRow(ProductVariantDTO.class);

                                // Set color và addon ngay khi tạo variant
                                Integer colorId = row.getColumn("pv_colorId", Integer.class);
                                Integer addonId = row.getColumn("pv_addonId", Integer.class);

                                if (colorId != null && colorMap.containsKey(colorId)) {
                                    v.setColor(colorMap.get(colorId));
                                }

                                if (addonId != null && addonMap.containsKey(addonId)) {
                                    v.setAddon(addonMap.get(addonId));
                                }

                                variantMap.put(variantId, v);
                                dto.getVariants().add(v);
                            }
                        }

                        // Map ProductReview
                        if (row.getColumn("pr_id", Integer.class) != null) {
                            ProductReviewDTO review = row.getRow(ProductReviewDTO.class);
                            if (dto.getReviews().stream().noneMatch(r -> r.getId() == review.getId())) {
                                review.setUserName(row.getColumn("pr_userName", String.class));
                                review.setUserAvatar(row.getColumn("pr_userAvatar", String.class));
                                dto.getReviews().add(review);
                            }
                        }

                        // Map Sale
                        if (row.getColumn("s_id", Integer.class) != null) {
                            ProductSaleDTO sale = row.getRow(ProductSaleDTO.class);
                            if (dto.getSales().stream().noneMatch(s -> s.getId() == sale.getId())) {
                                dto.getSales().add(sale);
                            }
                        }
                        return map;
                    })
                    .values()
                    .stream()
                    .findFirst()
                    .orElse(null);
        });
    }

    public int store(ProductCreateDTO product) {
        String sql = """
                INSERT INTO products (name, description, basePrice, categoryId, brandId, stockManagementType, status, createdAt)
                VALUES (:name, :description, :basePrice, :categoryId, :brandId, :stockManagementType, 1, CURRENT_TIMESTAMP)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(product)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public ProductEditDTO findProductEdit(int id) {
        String sql = """
                SELECT
                    p.id AS p_id,
                    p.name AS p_name,
                    p.description AS p_description,
                    p.basePrice AS p_basePrice,
                    p.categoryId AS p_categoryId,
                    p.brandId AS p_brandId,
                    p.stockManagementType AS p_stockManagementType,
                    p.featured AS p_featured,
                    p.status AS p_status,
                    p.createdAt AS p_createdAt,
                
                    pi.id AS pi_id,
                    pi.productId AS pi_productId,
                    pi.image AS pi_image,
                    pi.main AS pi_main,
                    pi.sortOrder AS pi_sortOrder,
                
                    pc.id AS pc_id,
                    pc.productId AS pc_productId,
                    pc.name AS pc_name,
                    pc.additionalPrice AS pc_additionalPrice,
                
                    pa.id AS pa_id,
                    pa.productId AS pa_productId,
                    pa.name AS pa_name,
                    pa.additionalPrice AS pa_additionalPrice,
                
                    pv.id AS pv_id,
                    pv.productId AS pv_productId,
                    pv.colorId AS pv_colorId,
                    pv.addonId AS pv_addonId,
                    pv.stock AS pv_stock,
                    pv.status AS pv_status
                FROM products p
                LEFT JOIN product_images pi ON p.id = pi.productId
                LEFT JOIN product_colors pc ON p.id = pc.productId
                LEFT JOIN product_addons pa ON p.id = pa.productId
                LEFT JOIN product_variants pv ON p.id = pv.productId
                WHERE p.id = :id
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .registerRowMapper(BeanMapper.factory(ProductEditDTO.class, "p"))
                .registerRowMapper(BeanMapper.factory(ProductImageDTO.class, "pi"))
                .registerRowMapper(BeanMapper.factory(ProductColorDTO.class, "pc"))
                .registerRowMapper(BeanMapper.factory(ProductAddonDTO.class, "pa"))
                .registerRowMapper(BeanMapper.factory(ProductVariantDTO.class, "pv"))
                .reduceRows(new LinkedHashMap<Integer, ProductEditDTO>(), (map, row) -> {
                    ProductEditDTO dto = map.computeIfAbsent(
                            row.getColumn("p_id", Integer.class),
                            _ -> {
                                ProductEditDTO newDto = row.getRow(ProductEditDTO.class);
                                newDto.setImages(new ArrayList<>());
                                newDto.setColors(new ArrayList<>());
                                newDto.setAddons(new ArrayList<>());
                                newDto.setVariants(new ArrayList<>());
                                return newDto;
                            }
                    );

                    // Map ProductImage
                    if (row.getColumn("pi_id", Integer.class) != null) {
                        ProductImageDTO image = row.getRow(ProductImageDTO.class);
                        if (dto.getImages().stream().noneMatch(img -> img.getId() == image.getId())) {
                            dto.getImages().add(image);
                        }
                    }

                    // Map ProductColor
                    if (row.getColumn("pc_id", Integer.class) != null) {
                        ProductColorDTO color = row.getRow(ProductColorDTO.class);
                        if (dto.getColors().stream().noneMatch(c -> c.getId() == color.getId())) {
                            dto.getColors().add(color);
                        }
                    }

                    // Map ProductAddon
                    if (row.getColumn("pa_id", Integer.class) != null) {
                        ProductAddonDTO addon = row.getRow(ProductAddonDTO.class);
                        if (dto.getAddons().stream().noneMatch(a -> a.getId() == addon.getId())) {
                            dto.getAddons().add(addon);
                        }
                    }

                    // Map ProductVariant
                    if (row.getColumn("pv_id", Integer.class) != null) {
                        ProductVariantDTO variant = row.getRow(ProductVariantDTO.class);
                        if (dto.getVariants().stream().noneMatch(v -> v.getId() == variant.getId())) {
                            dto.getVariants().add(variant);
                        }
                    }

                    return map;
                })
                .values()
                .stream()
                .findFirst()
                .orElse(null));
    }

    public int storeImage(int productId, ProductImageDTO productImage) {
        String sql = """
                INSERT INTO product_images (productId, image, main, sortOrder, createdAt)
                VALUES (:productId, :image, :main, :sortOrder, CURRENT_TIMESTAMP)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .bind("image", productImage.getImage())
                        .bind("main", productImage.isMain())
                        .bind("sortOrder", productImage.getSortOrder())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int storeColor(int productId, ProductColorDTO color) {
        String sql = """
                INSERT INTO product_colors (productId, name, additionalPrice, createdAt)
                VALUES (:productId, :name, :additionalPrice, CURRENT_TIMESTAMP)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .bind("name", color.getName())
                        .bind("additionalPrice", color.getAdditionalPrice())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int storeAddon(int productId, ProductAddonDTO addon) {
        String sql = """
                INSERT INTO product_addons (productId, name, additionalPrice, createdAt)
                VALUES (:productId, :name, :additionalPrice, CURRENT_TIMESTAMP)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .bind("name", addon.getName())
                        .bind("additionalPrice", addon.getAdditionalPrice())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public int storeVariant(int productId, ProductVariantDTO variant) {
        String sql = """
                INSERT INTO product_variants (productId, colorId, addonId, imageId, stock, status, createdAt)
                VALUES (:productId, :colorId, :addonId, :imageId, :stock, 1, CURRENT_TIMESTAMP)
                """;

        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("productId", productId)
                        .bind("colorId", variant.getColorId())
                        .bind("addonId", variant.getAddonId())
                        .bind("imageId", variant.getImageId())
                        .bind("stock", variant.getStock())
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(Integer.class)
                        .one()
        );
    }

    public void incrementViewCount(int id) {
    }

    public CartItemDTO findMainProductVariant(int productVariantId) {
        String sql = """
                WITH MaxDiscount AS (
                    SELECT productId, MAX(s.discountPercentage) as maxDiscount
                    FROM product_sales ps
                    JOIN sales s ON ps.saleId = s.id
                    WHERE NOW() BETWEEN s.startDate AND s.endDate
                    GROUP BY productId
                )
                SELECT
                    p.id AS p_productId,
                    p.name AS p_name,
                    p.basePrice AS p_basePrice,
                    pi.image AS pi_image,
                    COALESCE(md.maxDiscount, 0) AS p_discountPercent,
                    pv.id AS pv_id,
                    pv.stock AS pv_stock,
                    pv.status AS pv_status,
                    pv.colorId AS pv_colorId,
                    pv.addonId AS pv_addonId,
                    pv.imageId AS pv_imageId,
                    pc.name AS pc_colorName,
                    pc.additionalPrice AS pc_additionalPrice,
                    pa.name AS pa_addonName,
                    pa.additionalPrice AS pa_additionalPrice
                FROM products p
                LEFT JOIN product_images pi ON p.id = pi.productId AND pi.main = 1
                LEFT JOIN product_variants pv ON p.id = pv.productId AND pv.status = 1
                LEFT JOIN product_colors pc ON pc.id = pv.colorId
                LEFT JOIN product_addons pa ON pa.id = pv.addonId
                LEFT JOIN MaxDiscount md ON md.productId = p.id
                WHERE pv.id = :productVariantId AND p.status = 1
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productVariantId", productVariantId)
                        .map((rs, ctx) -> {
                            // Tạo CartItemDTO
                            CartItemDTO dto = CartItemDTO.builder()
                                    .productId(rs.getInt("p_productId"))
                                    .name(rs.getString("p_name"))
                                    .basePrice(rs.getDouble("p_basePrice"))
                                    .discountPercent(rs.getDouble("p_discountPercent"))
                                    .mainImage(rs.getString("pi_image"))
                                    .build();

                            // Tạo ProductVariantDTO
                            ProductVariantDTO variant = ProductVariantDTO.builder()
                                    .id(rs.getInt("pv_id"))
                                    .stock(rs.getInt("pv_stock"))
                                    .status(rs.getInt("pv_status"))
                                    .imageId(rs.getInt("pv_imageId"))
                                    .build();

                            // Ánh xạ ProductColorDTO
                            Integer colorId = rs.getObject("pv_colorId", Integer.class);
                            if (colorId != null) {
                                ProductColorDTO color = ProductColorDTO.builder()
                                        .id(colorId)
                                        .name(rs.getString("pc_colorName"))
                                        .additionalPrice(rs.getDouble("pc_additionalPrice"))
                                        .build();
                                variant.setColor(color);
                            }

                            // Ánh xạ ProductAddonDTO
                            Integer addonId = rs.getObject("pv_addonId", Integer.class);
                            if (addonId != null) {
                                ProductAddonDTO addon = ProductAddonDTO.builder()
                                        .id(addonId)
                                        .name(rs.getString("pa_addonName"))
                                        .additionalPrice(rs.getDouble("pa_additionalPrice"))
                                        .build();
                                variant.setAddon(addon);
                            }

                            // Gán variant vào CartItemDTO
                            dto.setProductVariant(variant);
                            return dto;
                        })
                        .findFirst()
                        .orElse(null)
        );
    }

    public Map<String, List<Object>> findAllVariants(int productId) {
        String colorSql = """
                SELECT id AS pc_id, name AS pc_colorName, additionalPrice AS pc_additionalPrice 
                FROM product_colors WHERE productId = :productId
                """;

        String addonSql = """
                SELECT id AS pa_id, name AS pa_addonName, additionalPrice AS pa_additionalPrice 
                FROM product_addons WHERE productId = :productId
                """;

        return jdbi.withHandle(handle -> {
            List<ProductColorDTO> colorList = new ArrayList<>();
            List<ProductAddonDTO> addonList = new ArrayList<>();
            Map<String, List<Object>> variantMap = new LinkedHashMap<>();

            List<Map<String, Object>> colorResults = handle.createQuery(colorSql)
                    .bind("productId", productId)
                    .mapToMap()
                    .list();

            for (Map<String, Object> row : colorResults) {
                Integer colorId = (Integer) row.get("pc_id");
                String colorName = (String) row.get("pc_colorname");
                Double additionalPriceColor = row.get("pc_additionalprice") != null ? ((Number) row.get("pc_additionalprice")).doubleValue() : 0.0;
                if (colorId != null && colorName != null) {
                    ProductColorDTO color = ProductColorDTO.builder()
                            .id(colorId)
                            .name(colorName)
                            .additionalPrice(additionalPriceColor)
                            .build();
                    colorList.add(color);
                }
            }

            List<Map<String, Object>> addonResults = handle.createQuery(addonSql)
                    .bind("productId", productId)
                    .mapToMap()
                    .list();

            for (Map<String, Object> row : addonResults) {
                Integer addonId = (Integer) row.get("pa_id");
                String addonName = (String) row.get("pa_addonname");
                Double additionalPriceAddon = row.get("pa_additionalprice") != null ? ((Number) row.get("pa_additionalprice")).doubleValue() : 0.0;
                if (addonId != null && addonName != null) {
                    ProductAddonDTO addon = new ProductAddonDTO();
                    addon.setId(addonId);
                    addon.setName(addonName);
                    addon.setAdditionalPrice(additionalPriceAddon);
                    addonList.add(addon);
                }
            }

            variantMap.put("color", new ArrayList<>(colorList));
            variantMap.put("addon", new ArrayList<>(addonList));

            return variantMap;
        });
    }

    public CartItemDTO findProductWithVariant(int colorId, int addonId, int productId) {
        String sql = """
                WITH MaxDiscount AS (
                    SELECT productId, MAX(s.discountPercentage) as maxDiscount
                    FROM product_sales ps
                    JOIN sales s ON ps.saleId = s.id
                    WHERE NOW() BETWEEN s.startDate AND s.endDate
                    GROUP BY productId
                )
                SELECT
                    p.id AS p_productId,
                    p.name AS p_name,
                    p.basePrice AS p_basePrice,
                    pi.image AS pi_image,
                    COALESCE(md.maxDiscount, 0) AS p_discountPercent,
                    pv.id AS pv_id,
                    pv.stock AS pv_stock,
                    pv.status AS pv_status,
                    pv.colorId AS pv_colorId,
                    pv.addonId AS pv_addonId,
                    pv.imageId AS pv_imageId,
                    pc.name AS pc_colorName,
                    pc.additionalPrice AS pc_additionalPrice,
                    pa.name AS pa_addonName,
                    pa.additionalPrice AS pa_additionalPrice
                FROM products p
                LEFT JOIN product_variants pv ON p.id = pv.productId AND pv.status = 1
                LEFT JOIN product_colors pc ON pc.id = pv.colorId
                LEFT JOIN product_addons pa ON pa.id = pv.addonId
                LEFT JOIN MaxDiscount md ON md.productId = p.id
                LEFT JOIN product_images pi ON pi.id = pv.imageId 
                WHERE p.id = :productId
                    AND p.status = 1
                    AND (pv.colorId = NULLIF(:colorId, 0) OR (pv.colorId IS NULL AND :colorId = 0))
                    AND (pv.addonId = NULLIF(:addonId, 0) OR (pv.addonId IS NULL AND :addonId = 0))
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .bind("colorId", colorId)
                        .bind("addonId", addonId)
                        .map((rs, ctx) -> {
                            // Tạo CartItemDTO
                            CartItemDTO dto = new CartItemDTO();
                            dto.setProductId(rs.getInt("p_productId"));
                            dto.setName(rs.getString("p_name"));
                            dto.setBasePrice(rs.getDouble("p_basePrice"));
                            dto.setDiscountPercent(rs.getDouble("p_discountPercent"));
                            dto.setMainImage(rs.getString("pi_image"));

                            // Tạo ProductVariantDTO
                            ProductVariantDTO variant = new ProductVariantDTO();
                            variant.setId(rs.getInt("pv_id"));
                            variant.setStock(rs.getInt("pv_stock"));
                            variant.setStatus(rs.getInt("pv_status"));
                            variant.setImageId(rs.getInt("pv_imageId"));

                            // Ánh xạ ProductColorDTO
                            Integer currentColorId = rs.getObject("pv_colorId", Integer.class);
                            if (currentColorId != null) {
                                ProductColorDTO color = ProductColorDTO.builder()
                                        .id(currentColorId)
                                        .name(rs.getString("pc_colorName"))
                                        .additionalPrice(rs.getDouble("pc_additionalPrice"))
                                        .build();
                                variant.setColor(color);
                            }

                            // Ánh xạ ProductAddonDTO
                            Integer currentAddonId = rs.getObject("pv_addonId", Integer.class);
                            if (currentAddonId != null) {
                                ProductAddonDTO addon = new ProductAddonDTO();
                                addon.setId(currentAddonId);
                                addon.setName(rs.getString("pa_addonName"));
                                addon.setAdditionalPrice(rs.getDouble("pa_additionalPrice"));
                                variant.setAddon(addon);
                            }

                            // Gán variant vào CartItemDTO
                            dto.setProductVariant(variant);
                            return dto;
                        })
                        .findFirst()
                        .orElse(null)
        );
    }

    public ProductVariantDTO findProductVariantById(int variantId) {
        String sql = """
                    SELECT pv.id, pv.stock 
                    FROM product_variants AS pv 
                    WHERE pv.id = :variantId
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("variantId", variantId)
                        .mapToBean(ProductVariantDTO.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public int updateStock(Handle handle, int variantId, int quantity) {
        int updatedRows = handle.createUpdate("UPDATE product_variants SET stock = stock - :quantity WHERE id = :variantId AND stock >= :quantity")
                .bind("quantity", quantity)
                .bind("variantId", variantId)
                .execute();
        return updatedRows;
    }

    // lấy ra số lượng stock dựa trên OrderItem chứa variantId
    public ProductVariantDTO getStockByOrderItemId(int orderItemId) {
        String sql = """
                    SELECT pv.id, pv.stock
                    FROM order_items o
                    INNER JOIN product_variants pv ON o.variantId = pv.id
                    WHERE o.id = :id
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", orderItemId)
                        .map((rs, ctx) -> {
                            ProductVariantDTO dto = new ProductVariantDTO();
                            dto.setId(rs.getInt("id"));
                            dto.setStock(rs.getInt("stock"));
                            return dto;
                        })
                        .findFirst()
                        .orElse(null)
        );
    }

    public void update(ProductEditDTO productEditDTO) {
        String sql = """
                UPDATE products
                SET name = :name,
                    description = :description,
                    basePrice = :basePrice,
                    categoryId = :categoryId,
                    brandId = :brandId,
                    stockManagementType = :stockManagementType,
                    featured = :featured
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(productEditDTO)
                        .execute()
        );
    }

    public void updateColor(ProductColorDTO color) {
        String sql = """
                UPDATE product_colors
                SET name = :name,
                    additionalPrice = :additionalPrice
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(color)
                        .execute()
        );
    }

    public void updateAddon(ProductAddonDTO addon) {
        String sql = """
                UPDATE product_addons
                SET name = :name,
                    additionalPrice = :additionalPrice
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(addon)
                        .execute()
        );
    }

    public void updateVariant(ProductVariantDTO variant) {
        String sql = """
                UPDATE product_variants
                SET stock = :stock,
                    status = :status
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(variant)
                        .execute()
        );
    }

    public void updateMainImage(ProductImageDTO imageDTO) {
        String sql = """
                UPDATE product_images
                SET main = :main
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(imageDTO)
                        .execute()
        );
    }

    public List<ProductImageDTO> getProductImages(int productId) {
        String sql = """
                SELECT * FROM product_images
                WHERE productId = :productId
                ORDER BY sortOrder
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("productId", productId)
                        .mapToBean(ProductImageDTO.class)
                        .list()
        );
    }

    public void deleteImage(int imageId) {
        String sql = """
                DELETE FROM product_images
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", imageId)
                        .execute()
        );
    }

    public void updateImage(ProductImageDTO imageDTO) {
        String sql = """
                UPDATE product_images
                SET image = :image,
                    main = :main,
                    sortOrder = :sortOrder
                WHERE id = :id
                """;

        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(imageDTO)
                        .execute()
        );
    }
}