package com.drumstore.web.controllers.auth;

import com.drumstore.web.dto.LoginRequestDTO;
import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.services.UserService;
import com.drumstore.web.utils.FlashManager;
import com.drumstore.web.utils.LogUtils;
import com.drumstore.web.validators.LoginValidator;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    private final UserService userService = new UserService();
    private final LoginValidator loginValidator = new LoginValidator();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        FlashManager.exposeToRequest(request);
        String redirectUrl = request.getParameter("redirectUrl");
        request.setAttribute("redirectUrl", redirectUrl);
        request.setAttribute("title", "Đăng nhập");
        request.setAttribute("content", "login.jsp");
        request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        Map<String, String> errors = new HashMap<>();
        Map<String, String> oldInput = new HashMap<>();

        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");

            oldInput.put("email", email);

            LoginRequestDTO loginRequest = LoginRequestDTO.builder().email(email).password(password).build();
            errors = loginValidator.validate(loginRequest);

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("oldInput", oldInput);
                request.setAttribute("title", "Đăng nhập");
                request.setAttribute("content", "login.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
                return;
            }

            UserDTO user = userService.login(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                String originalURL = (String) session.getAttribute("redirectUrl");
                session.removeAttribute("redirectUrl");

                if (originalURL != null && !originalURL.isEmpty() && !originalURL.contains("/login")) {
                    response.sendRedirect(originalURL);
                } else if (user.getRoles() != null && !user.getRoles().isEmpty()) {
                    response.sendRedirect(request.getContextPath() + "/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/");
                }
            } else {
                errors.put("general", "Email hoặc mật khẩu không chính xác");
                request.setAttribute("errors", errors);
                request.setAttribute("oldInput", oldInput);
                request.setAttribute("title", "Đăng nhập");
                request.setAttribute("content", "login.jsp");
                request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
                LogUtils.logToDatabase(0, 2, "LOGIN_FAILED", "{\"email\":\"" + email + "\"}", null);
            }
        } catch (Exception e) {
            errors.put("general", "Có lỗi xảy ra. Vui lòng thử lại sau.");
            request.setAttribute("errors", errors);
            request.setAttribute("oldInput", oldInput);
            request.setAttribute("redirectUrl", request.getParameter("redirectUrl"));
            request.setAttribute("title", "Đăng nhập");
            request.setAttribute("content", "login.jsp");
            request.getRequestDispatcher("/pages/homepage/layout.jsp").forward(request, response);
            LogUtils.logToDatabase(0, 3, "LOGIN_ERROR", null, "{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
