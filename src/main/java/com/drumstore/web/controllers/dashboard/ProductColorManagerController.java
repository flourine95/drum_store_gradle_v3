package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.dto.ProductColorDTO;
import com.drumstore.web.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/dashboard/products/colors/*")
public class ProductColorManagerController extends HttpServlet {
    private final ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int productId = Integer.parseInt(request.getParameter("productId"));
        String name = request.getParameter("name");
        double additionalPrice = Double.parseDouble(request.getParameter("additionalPrice"));

        ProductColorDTO colorDTO = ProductColorDTO.builder()
                .name(name)
                .additionalPrice(additionalPrice)
                .build();

        productService.createColor(productId, colorDTO);

        response.sendRedirect(request.getContextPath() + "/dashboard/products?action=edit&id=" + productId + "#colors");
    }
}
