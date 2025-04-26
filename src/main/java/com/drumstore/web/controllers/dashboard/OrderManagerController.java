package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.dto.OrderHistoryDTO;
import com.drumstore.web.services.OrderService;
import com.drumstore.web.utils.LocalDateTimeTypeAdapter;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

@WebServlet("/dashboard/orders")
public class OrderManagerController extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final Gson gson ;

    public OrderManagerController() {
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeTypeAdapter())
                .create();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if (action == null || action.isEmpty()) {
            index(req, resp);
            return;
        }

        switch (action) {
            case "show" -> show(req, resp);
            case "edit" -> edit(req, resp);
            default -> index(req, resp);
        }
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    private void show(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        OrderHistoryDTO dto = orderService.getOrderHistory(Integer.parseInt(orderId));
        request.setAttribute("title", "Chi tiết đơn hàng");
        request.setAttribute("order", dto);
        request.setAttribute("content", "orders/show.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);

    }

    private void index(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Quản lý đơn hàng");
        request.setAttribute("content", "orders/index.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void sendResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        switch (action) {
            case "update-quantity" -> updateQuantity(req, resp);
            case "remove-orderItem" -> removeOrderItem(req,resp);
            case "modify-orderStatus" -> modifyOrderStatus(req,resp);
            case "remove-order" -> removeOrder(req, resp);
        }
    }

    private void removeOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String orderIdStr = req.getParameter("orderId");
        Map<String, String> result = new HashMap<>();

        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderHistoryDTO dto = orderService.getOrderHistory(orderId);

            int orderStatus = dto.getOrderStatus();
            if (orderStatus == 1 || orderStatus == 2 || orderStatus == 3) {
                result.put("status", "error");
                result.put("message", "Đơn hàng đã được xử lý và không thể xóa.");
            } else {
                result = orderService.removerOrder(orderId);
            }
        } catch (NumberFormatException e) {
            result.put("status", "error");
            result.put("message", "Dữ liệu không hợp lệ.");
        }

        sendResponse(resp, result);
    }


    private void modifyOrderStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String oderIdStr =req.getParameter("orderId");
        String statusIdStr =req.getParameter("statusId");
        Map<String, String> result = new HashMap<>();
        try {
            int orderId = Integer.parseInt(oderIdStr);
            int statusId = Integer.parseInt(statusIdStr);
            result = orderService.modifyStatusOrder(orderId,statusId);
        } catch (NumberFormatException e) {
            result.put("status", "error");
            result.put("message", "Dữ liệu không hợp lệ.");
        }
        sendResponse(resp,result);
    }

    private void removeOrderItem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String orderItemIdStr = req.getParameter("orderItemId");
        String oderIdStr =req.getParameter("orderId");
        Map<String, String> result = new HashMap<>();
        try {
            int orderItemId = Integer.parseInt(orderItemIdStr);
            int orderId = Integer.parseInt(oderIdStr);
            result = orderService.removeOrderItem(orderItemId);

            // cập nhật lại tổng tiền
            OrderHistoryDTO dto = orderService.getOrderHistory(orderId);
            double total = dto.getItems().stream().mapToDouble(item -> item.getQuantity()*item.getFinalPrice()).sum();
            orderService.updateTotalAmount(orderId,total);
            result.put("total", String.valueOf( total));
        } catch (NumberFormatException e) {
            result.put("status", "error");
            result.put("message", "Dữ liệu không hợp lệ.");
        }

        sendResponse(resp,result);
    }

    private void updateQuantity(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String orderItemIdStr = req.getParameter("orderItemId");
        String quantityStr = req.getParameter("quantity");
        String oderIdStr =req.getParameter("orderId");
        Map<String, String> result = new HashMap<>();

        try {
            int orderItemId = Integer.parseInt(orderItemIdStr);
            int quantity = Integer.parseInt(quantityStr);
            int orderId = Integer.parseInt(oderIdStr);

            result = orderService.updateQuantityFromDashboard(orderItemId, quantity);

            // cập nhật lại tổng tiền
            OrderHistoryDTO dto = orderService.getOrderHistory(orderId);
            double total = dto.getItems().stream().mapToDouble(item -> item.getQuantity()*item.getFinalPrice()).sum();
            orderService.updateTotalAmount(orderId,total);
            result.put("total", String.valueOf( total));
        } catch (NumberFormatException e) {
            result.put("status", "error");
            result.put("message", "Dữ liệu không hợp lệ.");
        }

        sendResponse(resp,result);

    }
}