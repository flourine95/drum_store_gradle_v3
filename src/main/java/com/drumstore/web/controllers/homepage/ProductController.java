package com.drumstore.web.controllers.homepage;

import com.drumstore.web.dto.ProductCardDTO;
import com.drumstore.web.dto.ProductDetailDTO;
import com.drumstore.web.services.BrandService;
import com.drumstore.web.services.CategoryService;
import com.drumstore.web.services.ProductService;
import com.drumstore.web.services.WishlistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet({"/products", "/product/*"})
public class ProductController extends HttpServlet {
    private ProductService productService;
    private CategoryService categoryService;
    private BrandService brandService;
    private static final int PRODUCTS_PER_PAGE = 9;
    private static final int RELATED_PRODUCTS_LIMIT = 4;

    @Override
    public void init() throws ServletException {
        super.init();
        this.productService = new ProductService();
        this.categoryService = new CategoryService();
        this.brandService = new BrandService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String pathInfo = request.getPathInfo();
        String servletPath = request.getServletPath();

        if ("/product".equals(servletPath) && pathInfo != null) {
            handleProductDetail(request, response);
        } else {
            handleProductList(request, response);
        }

    }

    private void handleProductList(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        int page = getPage(request);
        String searchKeyword = request.getParameter("search");
        String category = request.getParameter("category");
        String brand = request.getParameter("brand");
        String priceRange = request.getParameter("priceRange");
        String sortBy = request.getParameter("sortBy");

        int totalProducts = productService.countProducts(searchKeyword, category, brand, priceRange);
        int totalPages = (int) Math.ceil((double) totalProducts / PRODUCTS_PER_PAGE);

        List<ProductCardDTO> products = productService.getProductCards(page, PRODUCTS_PER_PAGE, searchKeyword, category, brand, priceRange, sortBy);
        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", searchKeyword);
        request.setAttribute("selectedCategory", category);
        request.setAttribute("selectedBrand", brand);
        request.setAttribute("selectedPriceRange", priceRange);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("categories", categoryService.all());
        request.setAttribute("brands", brandService.all());

        request.setAttribute("title", "Danh sách sản phẩm");
        request.setAttribute("content", "products.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }

    private void handleProductDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String pathInfo = request.getPathInfo();
        String productId = pathInfo.substring(1);

        ProductDetailDTO product = productService.getProductDetail(Integer.parseInt(productId));
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
//        List<ProductCardDTO> relatedProducts = productService.getRelatedProductCards(product.getId(), product.getCategoryId(), RELATED_PRODUCTS_LIMIT);
        request.setAttribute("product", product);
//        request.setAttribute("relatedProducts", relatedProducts);
        request.setAttribute("title", product.getName());
        request.setAttribute("content", "product-detail.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);

    }

    private int getPage(HttpServletRequest request) {
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                return Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                return 1;
            }
        }
        return 1;
    }
}

