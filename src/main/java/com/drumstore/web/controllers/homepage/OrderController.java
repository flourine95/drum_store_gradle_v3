package com.drumstore.web.controllers.homepage;

import com.drumstore.web.dto.UserAddressDTO;
import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.models.Cart;
import com.drumstore.web.services.OrderService;
import com.drumstore.web.services.UserAddressService;
import com.drumstore.web.services.VnPayService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/order")
public class OrderController extends HttpServlet {
    private final OrderService orderService;
    private final Gson gson;
    private final UserAddressService userAddressService;
    private final VnPayService vnPayService;

    public OrderController() {
        this.orderService = new OrderService();
        this.gson = new Gson();
        this.userAddressService = new UserAddressService();
        this.vnPayService = new VnPayService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cart cart = (Cart) req.getSession().getAttribute("cart");
        UserDTO user = (UserDTO) req.getSession().getAttribute("user");

        Map<String, List<UserAddressDTO>> addressMap = userAddressService.getMainAddressAndSubAddress(user.getId());
        req.setAttribute("title", "Thanh toán");
        req.setAttribute("cart", cart);
        req.setAttribute("address", addressMap);
        req.setAttribute("total", cart.getTotal() - cart.getDiscountTotal());
        req.setAttribute("content", "order.jsp");
        req.getRequestDispatcher("/pages/homepage/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, Object> result = new HashMap<>();

        Cart cart = (Cart) req.getSession().getAttribute("cart");
        UserDTO user = (UserDTO) req.getSession().getAttribute("user");


        Map<String, Object> requestData = validateRequestData(req, result);
        if (requestData == null) {
            sendResponse(resp, result);
            return;
        }

        double amount = (double) requestData.get("amount");
        int userAddressId = (int) requestData.get("userAddressId");
        String action = (String) requestData.get("action");

        switch (action) {
            case "cod" -> handleCodPayment(user, amount, userAddressId, cart, req, resp);
            case "payment" -> handleVNPayPayment(user, amount, userAddressId, cart, req, resp);
            default -> sendErrorResponse(resp, "Phương thức thanh toán không được hỗ trợ: " + action);
        }
    }

    private Map<String, Object> validateRequestData(HttpServletRequest req, Map<String, Object> result) {
        try {
            double amount = Double.parseDouble(req.getParameter("amount"));
            int userAddressId = Integer.parseInt(req.getParameter("userAddressId"));
            String action = req.getParameter("action");

            if (action == null || action.isEmpty()) {
                result.put("success", "false");
                result.put("message", "Phương thức thanh toán không được chỉ định.");
                return null;
            }

            Map<String, Object> requestData = new HashMap<>();
            requestData.put("amount", amount);
            requestData.put("userAddressId", userAddressId);
            requestData.put("action", action);
            return requestData;
        } catch (NumberFormatException e) {
            result.put("success", "false");
            result.put("message", "Dữ liệu đầu vào không hợp lệ (amount hoặc userAddressId).");
            return null;
        }
    }

    private void handleCodPayment(UserDTO user, double amount, int userAddressId, Cart cart, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = orderService.orderWithCod(user.getId(), amount, userAddressId, cart);
        if ("true".equalsIgnoreCase(String.valueOf(result.get("success")).trim())) {
            req.getSession().setAttribute("cart", new Cart());
        }
        sendResponse(resp, result);
    }

    private void handleVNPayPayment(UserDTO user, double amount, int userAddressId, Cart cart, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> orderResult = orderService.orderWithVNPay(user.getId(), amount, userAddressId, cart);
        Map<String, Object> result = new HashMap<>();

        if ("true".equalsIgnoreCase(String.valueOf(orderResult.get("success")).trim())) {
            req.getSession().setAttribute("cart", new Cart());
            long vnpayAmount = (long) (amount * 100L);
            String paymentUrl = vnPayService.createPaymentUrl(vnpayAmount, req);
            if (paymentUrl != null && !paymentUrl.isEmpty()) {
                result.put("success", "true");
                result.put("orderId", orderResult.get("orderId"));
                result.put("paymentUrl", paymentUrl);
                req.getSession().setAttribute("orderId", orderResult.get("orderId"));
            } else {
                sendErrorResponse(resp, "Không thể tạo URL thanh toán VNPay");
                return;
            }
        } else {
            sendErrorResponse(resp, (String) orderResult.get("message"));
            return;
        }
        sendResponse(resp, result);
    }

    private void sendResponse(HttpServletResponse resp, Map<String, Object> result) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.getWriter().write(gson.toJson(result));
    }

    private void sendErrorResponse(HttpServletResponse resp, String message) throws IOException {
        Map<String, Object> result = new HashMap<>();
        result.put("success", "false");
        result.put("message", message);
        sendResponse(resp, result);
    }
}
