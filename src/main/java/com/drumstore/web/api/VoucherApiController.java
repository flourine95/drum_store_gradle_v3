package com.drumstore.web.api;

import com.drumstore.web.dto.ProductDashboardDTO;
import com.drumstore.web.dto.VoucherDTO;
import com.drumstore.web.services.ProductService;
import com.drumstore.web.services.VoucherService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/api/vouchers/*")
public class VoucherApiController extends BaseApiController {
    private final VoucherService voucherService = new VoucherService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                List<VoucherDTO> list = voucherService.getAllVouchers();
                sendResponse(response, list);
            }
        } catch (Exception e) {
            sendError(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }

}
