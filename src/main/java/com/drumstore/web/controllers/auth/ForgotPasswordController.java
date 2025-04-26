package com.drumstore.web.controllers.auth;

import com.drumstore.web.services.ForgotPasswordService;
import com.drumstore.web.validators.ForgotPasswordValidator;
import com.drumstore.web.validators.PasswordResetValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/forgot-password/*")
public class ForgotPasswordController extends HttpServlet {
    private final ForgotPasswordService passwordResetService = new ForgotPasswordService();
    private final ForgotPasswordValidator forgotPasswordValidator = new ForgotPasswordValidator();
    private final PasswordResetValidator passwordResetValidator = new PasswordResetValidator();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");

        if (token != null) {
            if (passwordResetService.validateResetToken(token)) {
                request.setAttribute("token", token);
                request.setAttribute("title", "Đặt lại mật khẩu");
                request.setAttribute("content", "reset-password.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Mã khôi phục không hợp lệ hoặc đã hết hạn.");
                request.setAttribute("title", "Quên mật khẩu");
                request.setAttribute("content", "forgot-password.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("title", "Quên mật khẩu");
            request.setAttribute("content", "forgot-password.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        request.setCharacterEncoding("UTF-8");
        Map<String, String> errors = new HashMap<>();
        Map<String, String> oldInput = new HashMap<>();

        try {
            if ("request".equals(action)) {
                handleForgotPasswordRequest(request, response, errors, oldInput);
            } else if ("reset".equals(action)) {
                handlePasswordReset(request, response, errors);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            errors.put("general", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.setAttribute("errors", errors);
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("title", "Quên mật khẩu");
            request.setAttribute("content", "forgot-password.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
        }
    }

    private void handleForgotPasswordRequest(HttpServletRequest request, HttpServletResponse response, Map<String, String> errors, Map<String, String> oldInput) throws ServletException, IOException {
        String email = request.getParameter("email");
        oldInput.put("email", email);

       errors = forgotPasswordValidator.validate(email);

        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("title", "Quên mật khẩu");
            request.setAttribute("content", "forgot-password.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            return;
        }

        try {
            if (passwordResetService.requestPasswordReset(email)) {
                request.setAttribute("successMessage", "Hướng dẫn đặt lại mật khẩu đã được gửi đến email của bạn.");
            } else {
                errors.put("email", "Email không tồn tại trong hệ thống.");
                request.setAttribute("errors", errors);
                request.setAttribute("oldInput", oldInput);
            }
        } catch (Exception e) {
            errors.put("general", "Không thể gửi email. Vui lòng thử lại sau.");
            request.setAttribute("errors", errors);
            request.setAttribute("oldInput", oldInput);
        }

        request.setAttribute("title", "Quên mật khẩu");
        request.setAttribute("content", "forgot-password.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }

    private void handlePasswordReset(HttpServletRequest request, HttpServletResponse response, Map<String, String> errors) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        errors = passwordResetValidator.validate(newPassword, confirmPassword);
        if (!errors.isEmpty()) {
            request.setAttribute("errors", errors);
            request.setAttribute("token", token);
            request.setAttribute("title", "Đặt lại mật khẩu");
            request.setAttribute("content", "reset-password.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            return;
        }

        try {
            if (passwordResetService.resetPassword(token, newPassword)) {
                request.getSession().setAttribute("successMessage", 
                    "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập ngay.");
                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                errors.put("general", "Token không hợp lệ hoặc đã hết hạn.");
                request.setAttribute("errors", errors);
                request.setAttribute("token", token);
                request.setAttribute("title", "Đặt lại mật khẩu");
                request.setAttribute("content", "reset-password.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            }
        } catch (Exception e) {
            errors.put("general", "Có lỗi xảy ra khi đặt lại mật khẩu. Vui lòng thử lại.");
            request.setAttribute("errors", errors);
            request.setAttribute("token", token);
            request.setAttribute("title", "Đặt lại mật khẩu");
            request.setAttribute("content", "reset-password.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
        }
    }
} 