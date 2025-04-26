package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.constants.ProductConstants;
import com.drumstore.web.dto.*;
import com.drumstore.web.services.BrandService;
import com.drumstore.web.services.CategoryService;
import com.drumstore.web.services.ProductService;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/dashboard/products/*")
public class ProductManagerController extends HttpServlet {
    private final ProductService productService = new ProductService();
    private final BrandService brandService = new BrandService();
    private final CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            index(request, response);
            return;
        }

        switch (action) {
            case "create" -> create(request, response);
            case "edit" -> edit(request, response);
            default -> index(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action == null || action.isEmpty()) {
            index(request, response);
            return;
        }

        switch (action) {
            case "store" -> store(request, response);
            case "update" -> update(request, response);
            case "delete" -> delete(request, response);
            default -> index(request, response);
        }
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer id = getIdParameter(request, response);

        if (id == null) return;
        ProductEditDTO product = productService.findProductEdit(id);

        request.setAttribute("title", "Chỉnh sửa sản phẩm");
        request.setAttribute("content", "products/edit.jsp");
        request.setAttribute("product", product);
        request.setAttribute("stockManagementTypes", ProductConstants.StockManagementType.values());
        request.setAttribute("categories", categoryService.all());
        request.setAttribute("brands", brandService.all());
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void create(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Thêm sản phẩm");
        request.setAttribute("content", "products/create.jsp");
        request.setAttribute("categories", categoryService.all());
        request.setAttribute("brands", brandService.all());
        request.setAttribute("stockManagementTypes", ProductConstants.StockManagementType.values());
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void index(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Quản lí sản phẩm");
        request.setAttribute("content", "products/index.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }


    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = getIdParameter(request, response);
        if (id == null) return;

//        productService.delete(id);
        response.sendRedirect(request.getContextPath() + "/dashboard/products");
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Integer id = getIdParameter(request, response);
            if (id == null) return;

            String updateType = request.getParameter("updateType");

            switch (updateType) {
                case "basic-info" -> updateBasicInfo(request, id);
                case "images" -> updateImages(request, response, id);
                case "colors" -> updateColors(request, id);
                case "addons" -> updateAddons(request, id);
                case "variants" -> updateVariants(request, id);
                default -> throw new IllegalArgumentException("Invalid update type: " + updateType);
            }

            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"message\": \"Cập nhật thành công\"}");

        } catch (Exception e) {
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"" + e.getMessage() + "\"}");
        }
    }

    private void updateVariants(HttpServletRequest request, Integer id) {
        String[] variantIds = request.getParameterValues("variantIds[]");
        String[] colorIds = request.getParameterValues("variantColorIds[]");
        String[] addonIds = request.getParameterValues("variantAddonIds[]");
        String[] stocks = request.getParameterValues("variantStocks[]");
        String[] statuses = request.getParameterValues("variantStatuses[]");

        List<ProductVariantDTO> variants = new ArrayList<>();
        if (stocks != null) {
            for (int i = 0; i < stocks.length; i++) {
                variants.add(ProductVariantDTO.builder()
                        .id(variantIds != null && variantIds[i] != null && !variantIds[i].isEmpty()
                                ? Integer.parseInt(variantIds[i]) : null)
                        .productId(id)
                        .colorId(colorIds != null && colorIds[i] != null && !colorIds[i].isEmpty()
                                ? Integer.parseInt(colorIds[i]) : null)
                        .addonId(addonIds != null && addonIds[i] != null && !addonIds[i].isEmpty()
                                ? Integer.parseInt(addonIds[i]) : null)
                        .stock(Integer.parseInt(stocks[i]))
                        .status(Integer.parseInt(statuses[i]))
                        .build());
            }
        }
        productService.updateVariants(variants);
    }

    private void updateAddons(HttpServletRequest request, Integer id) {
        String[] addonNames = request.getParameterValues("addonNames[]");
        String[] addonPrices = request.getParameterValues("addonPrices[]");
        String[] addonIds = request.getParameterValues("addonIds[]");

        List<ProductAddonDTO> addons = new ArrayList<>();
        if (addonNames != null) {
            for (int i = 0; i < addonNames.length; i++) {
                addons.add(ProductAddonDTO.builder()
                        .id(addonIds != null && addonIds[i] != null && !addonIds[i].isEmpty()
                                ? Integer.parseInt(addonIds[i]) : null)
                        .productId(id)
                        .name(addonNames[i])
                        .additionalPrice(Double.parseDouble(addonPrices[i]))
                        .build());
            }
        }
        productService.updateAddons(addons);
    }

    private void updateColors(HttpServletRequest request, Integer id) {
        String[] colorNames = request.getParameterValues("colorNames[]");
        String[] colorPrices = request.getParameterValues("colorPrices[]");
        String[] colorIds = request.getParameterValues("colorIds[]");

        List<ProductColorDTO> colors = new ArrayList<>();
        if (colorNames != null) {
            for (int i = 0; i < colorNames.length; i++) {
                colors.add(ProductColorDTO.builder()
                        .id(colorIds != null && colorIds[i] != null && !colorIds[i].isEmpty()
                                ? Integer.parseInt(colorIds[i]) : null)
                        .productId(id)
                        .name(colorNames[i])
                        .additionalPrice(Double.parseDouble(colorPrices[i]))
                        .build());
            }
        }
        productService.updateColors(colors);
    }

    private void updateImages(HttpServletRequest request, HttpServletResponse response, Integer id) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            StringBuilder requestBody = new StringBuilder();
            String line;
            try (BufferedReader reader = request.getReader()) {
                while ((line = reader.readLine()) != null) {
                    requestBody.append(line);
                }
            }
            System.out.println(requestBody);
            ObjectMapper mapper = new ObjectMapper();
            JsonNode rootNode = mapper.readTree(requestBody.toString());
            List<Map<String, Object>> images = mapper.convertValue(rootNode.get("images"), new TypeReference<>() {});

            if (images == null || images.isEmpty()) {
                throw new IllegalArgumentException("No image data provided");
            }

            List<ProductImageDTO> existingImages = productService.getProductImages(id);
            List<Integer> existingIds = existingImages.stream()
                    .map(ProductImageDTO::getId)
                    .toList();

            // Track which IDs we're keeping
            List<Integer> keepIds = new ArrayList<>();

            // Process each image from the request
            for (int i = 0; i < images.size(); i++) {
                Map<String, Object> imageData = images.get(i);
                String imageId = String.valueOf(imageData.get("id"));
                String image = String.valueOf(imageData.get("image"));
                boolean main = Boolean.TRUE.equals(imageData.get("main"));
                int sortOrder = Integer.parseInt(String.valueOf(imageData.get("sortOrder")));

                ProductImageDTO imageDTO = ProductImageDTO.builder()
                        .productId(id)
                        .image(image)
                        .sortOrder(sortOrder)
                        .main(main)
                        .build();

                if (imageId.startsWith("new_")) {
                    // Add new image
                    productService.addImage(imageDTO);
                } else {
                    try {
                        // Update existing image
                        int numericId = Integer.parseInt(imageId);
                        keepIds.add(numericId);
                        imageDTO.setId(numericId);
                        productService.updateImage(imageDTO);
                    } catch (NumberFormatException ignored) {
                        // Skip invalid IDs
                    }
                }
            }

            // Delete images that weren't included in the update
            existingIds.stream()
                    .filter(existingId -> !keepIds.contains(existingId))
                    .forEach(productService::deleteImage);

            // Send success response
            response.getWriter().write("{\"success\":true,\"message\":\"Images updated successfully\"}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"" + e.getMessage() + "\"}");
        }
    }

    private void updateBasicInfo(HttpServletRequest request, Integer id) {
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double basePrice = Double.parseDouble(request.getParameter("basePrice"));
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        int brandId = Integer.parseInt(request.getParameter("brandId"));
        int stockManagementType = Integer.parseInt(request.getParameter("stockManagementType"));
        boolean isFeatured = request.getParameter("isFeatured") != null;

        ProductEditDTO productEditDTO = ProductEditDTO.builder()
                .id(id)
                .name(name)
                .description(description)
                .basePrice(basePrice)
                .categoryId(categoryId)
                .brandId(brandId)
                .stockManagementType(stockManagementType)
                .featured(isFeatured)
                .build();

        productService.update(productEditDTO);
    }

    private void store(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Get basic product info
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double basePrice = Double.parseDouble(request.getParameter("basePrice"));
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            int brandId = Integer.parseInt(request.getParameter("brandId"));
            int stockManagementType = Integer.parseInt(request.getParameter("stockManagementType"));
            boolean isFeatured = request.getParameter("isFeatured") != null;

            // Create product DTO
            ProductCreateDTO productCreateDTO = ProductCreateDTO.builder()
                    .name(name)
                    .description(description)
                    .basePrice(basePrice)
                    .categoryId(categoryId)
                    .brandId(brandId)
                    .stockManagementType(stockManagementType)
                    .featured(isFeatured)
                    .build();

            // Create product and get ID
            int productId = productService.create(productCreateDTO);

            // Redirect to product detail page for adding colors, addons, and variants
            response.sendRedirect(request.getContextPath() + "/dashboard/products?action=edit&id=" + productId);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            create(request, response);
        }
    }

    private Integer getIdParameter(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            return Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ");
            return null;
        }
    }
}
