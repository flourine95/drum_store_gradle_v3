package com.drumstore.web.controllers.auth;

import com.drumstore.web.dto.RegisterRequestDTO;
import com.drumstore.web.models.User;
import com.drumstore.web.services.MailService;
import com.drumstore.web.services.UserService;
import com.drumstore.web.validators.RegisterValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/register")
public class RegisterController extends HttpServlet {
    private final UserService userService = new UserService();
    private final RegisterValidator registerValidator = new RegisterValidator();
    private final MailService mailService = new MailService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Đăng ký");
        request.setAttribute("content", "register.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Map<String, String> errors = new HashMap<>();
        Map<String, String> oldInput = new HashMap<>();

        try {
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String terms = request.getParameter("terms");

            oldInput.put("fullname", fullname);
            oldInput.put("email", email);
            oldInput.put("phone", phone);

            if (terms == null) {
                errors.put("terms", "Bạn phải đồng ý với điều khoản sử dụng");
            }

            RegisterRequestDTO registerRequest = RegisterRequestDTO.builder()
                    .fullname(fullname)
                    .email(email)
                    .phone(phone)
                    .password(password)
                    .confirmPassword(confirmPassword)
                    .build();

            errors = registerValidator.validate(registerRequest);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("oldInput", oldInput);
                request.setAttribute("title", "Đăng ký");
                request.setAttribute("content", "register.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
                return;
            }

            String hashedPassword = userService.hashPassword(password);
            registerRequest.setPassword(hashedPassword);
            User user = registerRequest.toModel();

            // Tạo token và thời gian hết hạn, lưu vào session
            String token =mailService.generateVerificationCode();
            LocalDateTime expiration = LocalDateTime.now().plusMinutes(5);
            Map<String, Object> verificationData = new HashMap<>();
            verificationData.put("token", token);
            verificationData.put("expiration", expiration);
//            verificationData.put("user", user);

            if (userService.register(user)) {

                // Gửi email xác thực
                mailService.sendVerificationEmail(email,token);

                // Lưu thông tin xác thực vào session
                request.getSession().setAttribute("verificationData", verificationData);
                request.getSession().setAttribute("emailToVerify", email);
                response.sendRedirect(request.getContextPath() + "/verify-token");

//                request.getSession().setAttribute("successMessage", "Đăng ký thành công! Bạn có thể đăng nhập ngay.");
//                response.sendRedirect(request.getContextPath() + "/login");
            } else {
                errors.put("general", "Có lỗi xảy ra khi đăng ký. Vui lòng thử lại sau.");
                request.setAttribute("errors", errors);
                request.setAttribute("oldInput", oldInput);
                request.setAttribute("title", "Đăng ký");
                request.setAttribute("content", "register.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            }

        } catch (Exception e) {
            errors.put("general", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.setAttribute("errors", errors);
            request.setAttribute("title", "Đăng ký");
            request.setAttribute("content", "register.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
        }
    }
}
