package com.drumstore.web.api;

import com.drumstore.web.dto.OrderHistoryDTO;
import com.drumstore.web.dto.ProductDashboardDTO;
import com.drumstore.web.services.OrderService;
import com.drumstore.web.services.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/orders/*")
public class OrderApiController extends BaseApiController {
    private final OrderService  orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                List<OrderHistoryDTO> list = orderService.orderHistoryList();
                sendResponse(response, list);
            }
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
}
