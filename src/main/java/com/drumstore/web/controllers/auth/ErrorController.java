package com.drumstore.web.controllers.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/error/*")
public class ErrorController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String errorCode = request.getParameter("code");

        switch (errorCode) {
            case "403" -> {
                request.setAttribute("errorCode", "403");
                request.setAttribute("errorTitle", "Không có quyền truy cập");
                request.setAttribute("errorMessage", "Bạn không có quyền truy cập trang này");
                request.setAttribute("errorDescription", "Vui lòng liên hệ quản trị viên nếu bạn cần được hỗ trợ.");
            }
            case "404" -> {
                request.setAttribute("errorCode", "404");
                request.setAttribute("errorTitle", "Trang không tồn tại");
                request.setAttribute("errorMessage", "Không tìm thấy trang bạn yêu cầu");
                request.setAttribute("errorDescription", "Trang bạn đang tìm kiếm có thể đã bị xóa, đổi tên hoặc tạm thời không khả dụng.");
            }
            default -> {
                request.setAttribute("errorCode", "500");
                request.setAttribute("errorTitle", "Lỗi hệ thống");
                request.setAttribute("errorMessage", "Đã xảy ra lỗi");
                request.setAttribute("errorDescription", "Vui lòng thử lại sau hoặc liên hệ quản trị viên.");
            }
        }

        request.setAttribute("backUrl", request.getHeader("Referer"));
        request.getRequestDispatcher("/pages/homepage/error.jsp").forward(request, response);
    }
}
