package com.drumstore.web.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class RedirectRouteFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());

        HttpSession session = httpRequest.getSession(false);
        
        boolean isProtectedRoute = path.startsWith("/dashboard");
        boolean isStaticResource = path.endsWith(".css") || path.endsWith(".js") || 
                                 path.endsWith(".png") || path.startsWith("/assets/");
        boolean isAuthRoute = path.equals("/login") || path.equals("/logout");
        
        if (!isStaticResource && !isAuthRoute && isProtectedRoute && session != null) {
            session.setAttribute("redirectUrl", requestURI);
        }

        chain.doFilter(request, response);
    }
}
