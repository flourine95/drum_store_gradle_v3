package com.drumstore.web.controllers.homepage;

import com.drumstore.web.dto.ProductCardDTO;
import com.drumstore.web.models.Category;
import com.drumstore.web.models.Post;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/")
public class HomeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<ProductCardDTO> featuredProducts = new ArrayList<>();
        List<Category> categories = new ArrayList<>();
        List<Post> latestPosts = new ArrayList<>();
        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("categories", categories);
        request.setAttribute("latestPosts", latestPosts);

        request.setAttribute("title", "Trang chủ");
        request.setAttribute("content", "index.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }
}

