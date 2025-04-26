package com.drumstore.web.controllers.auth;

import com.drumstore.web.services.MailService;
import com.drumstore.web.services.UserService;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/verify-token")
public class VerifyTokenController extends HttpServlet {
    private final Gson gson = new Gson();
    private final UserService userService = new UserService();
    private final MailService emailService = new MailService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Xác thực tài khoản");
        request.setAttribute("content", "verify-token.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String email = (String) request.getSession().getAttribute("emailToVerify");
        Map<String, Object> result = new HashMap<>();

        if (email == null) {
            result.put("success", false);
            result.put("error", "Phiên đăng ký không hợp lệ. Vui lòng đăng ký lại.");
            sendResponse(response, result);
            return;
        }

        if ("resend".equals(action)) {
            resendToken(request, email, result);
        } else {
            verifyToken(request, result);
        }

        sendResponse(response, result);
    }

    private void verifyToken(HttpServletRequest request, Map<String, Object> result) {
        String tokenInput = request.getParameter("token");
        @SuppressWarnings("unchecked")
        Map<String, Object> verificationData = (Map<String, Object>) request.getSession().getAttribute("verificationData");

        if (verificationData == null) {
            result.put("success", false);
            result.put("error", "Không tìm thấy thông tin xác thực. Vui lòng nhấn nút gửi lại mã OTP.");
            return;
        }

        String token = (String) verificationData.get("token");
        LocalDateTime expiration = (LocalDateTime) verificationData.get("expiration");

        if (LocalDateTime.now().isAfter(expiration)) {
            result.put("success", false);
            result.put("error", "Token đã hết hạn. Vui lòng yêu cầu token mới.");
        } else if (!token.equals(tokenInput)) {
            result.put("success", false);
            result.put("error", "Token không đúng.");
        } else {
            userService.updateStatus((String) request.getSession().getAttribute("emailToVerify"));
            request.getSession().removeAttribute("verificationData");
            request.getSession().removeAttribute("emailToVerify");
            request.getSession().setAttribute("successMessage", "Tài khoản đã được xác thực! Bạn có thể đăng nhập.");
            result.put("success", true);
        }
    }

    private void resendToken(HttpServletRequest request, String email, Map<String, Object> result) {
        String newToken = emailService.generateVerificationCode();

        LocalDateTime expiration = LocalDateTime.now().plusMinutes(5);
        Map<String, Object> verificationData = new HashMap<>();
        verificationData.put("token", newToken);
        verificationData.put("expiration", expiration);

        request.getSession().setAttribute("verificationData", verificationData);
        request.getSession().setAttribute("emailToVerify", email);

        emailService.sendVerificationEmail(email, newToken);
        result.put("success", true);
        result.put("message", "Mã xác thực mới đã được gửi.");
    }



    private void sendResponse(HttpServletResponse response, Map<String, Object> result) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(result));
    }
}
