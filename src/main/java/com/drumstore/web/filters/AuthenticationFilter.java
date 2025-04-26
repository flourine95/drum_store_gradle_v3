package com.drumstore.web.filters;

import com.drumstore.web.dto.UserDTO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    private static final List<String> authRoutes = List.of(
            "/login",
            "/register",
            "/forgot-password"
    );

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        HttpSession session = request.getSession(false);

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        if (authRoutes.contains(path)) {
            UserDTO user = (session != null) ? (UserDTO) session.getAttribute("user") : null;

            if (user != null) {
                if (user.getRoles() != null && !user.getRoles().isEmpty()) {
                    response.sendRedirect(contextPath + "/dashboard");
                } else {
                    response.sendRedirect(contextPath + "/");
                }
                return;
            }
        }

        chain.doFilter(request, response);
    }
}
