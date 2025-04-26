package com.drumstore.web.controllers.dashboard;

import com.drumstore.web.constants.ProductConstants;
import com.drumstore.web.dto.OrderHistoryDTO;
import com.drumstore.web.dto.VoucherDTO;
import com.drumstore.web.models.Voucher;
import com.drumstore.web.services.OrderService;
import com.drumstore.web.services.VoucherService;
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

@WebServlet("/dashboard/vouchers")
public class VoucherManagerController extends HttpServlet {
    private final VoucherService voucherService = new VoucherService();
    private final Gson gson;

    public VoucherManagerController() {
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
            case "create" -> create(req, resp);
            default -> index(req, resp);
        }
    }

    private void create(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Thêm Voucher");
        request.setAttribute("content", "vouchers/create.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }


    private Voucher findVoucher(HttpServletRequest req) {
        String voucherId = req.getParameter("voucherId");
        return voucherService.getVoucherById(Integer.parseInt(voucherId));
    }

    private void edit(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Voucher voucher = findVoucher(request);
        request.setAttribute("title", "Chi tiết voucher");
        request.setAttribute("voucher", voucher);
        request.setAttribute("content", "vouchers/edit.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    private void show(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Voucher voucher = findVoucher(request);
        request.setAttribute("title", "Chi tiết voucher");
        request.setAttribute("voucher", voucher);
        request.setAttribute("content", "vouchers/show.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);

    }

    private void index(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("title", "Quản lý Vouchers");
        request.setAttribute("content", "vouchers/index.jsp");
        request.getRequestDispatcher("/pages/dashboard/layout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        switch (action) {
            case "update" -> updateVoucher(req, resp);
            case "store" -> addVoucher(req, resp);
            case "delete" -> delete(req, resp);
        }
    }

    private void delete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, String> result = new HashMap<>();
        try {
            int voucherId = Integer.parseInt(req.getParameter("voucherId"));
            boolean isDelete = voucherService.deleteVoucher(voucherId);

            if (isDelete) {
                result.put("status", "success");
                result.put("message", "Voucher đã dược xóa thành công!");
            } else {
                result.put("status", "error");
                result.put("message", "Xóa Voucher thất bại!");
            }
        } catch (NumberFormatException | NullPointerException e) {
            result.put("status", "error");
            result.put("message", "Invalid data");
        }
        sendResponse(resp, result);
    }


    private void addVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, String> result = new HashMap<>();
        try {
            String code = req.getParameter("code");
            String description = req.getParameter("description");
            int discountType = Integer.parseInt(req.getParameter("discountType"));
            double discountValue = Double.parseDouble(req.getParameter("discountValue"));
            double minOrderValue = Double.parseDouble(req.getParameter("minOrderValue"));

            String maxDiscountValueStr = req.getParameter("maxDiscountValue");
            Double maxDiscountValue = maxDiscountValueStr != null && !maxDiscountValueStr.isEmpty()
                    ? Double.parseDouble(maxDiscountValueStr) : null;

            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");

            String usageLimitStr = req.getParameter("usageLimit");
            Integer usageLimit = usageLimitStr != null && !usageLimitStr.isEmpty()
                    ? Integer.parseInt(usageLimitStr) : null;

            String perUserLimitStr = req.getParameter("perUserLimit");
            Integer perUserLimit = perUserLimitStr != null && !perUserLimitStr.isEmpty()
                    ? Integer.parseInt(perUserLimitStr) : null;

            int status = Integer.parseInt(req.getParameter("status"));

            Voucher voucher = Voucher.builder()
                    .code(code)
                    .description(description)
                    .discountType(discountType)
                    .discountValue(discountValue)
                    .minOrderValue(minOrderValue)
                    .maxDiscountValue(maxDiscountValue)
                    .startDate(startDate)
                    .endDate(endDate)
                    .usageLimit(usageLimit)
                    .perUserLimit(perUserLimit)
                    .status(status)
                    .build();

            boolean isUpdate = voucherService.addVoucher(voucher);
            if (isUpdate) {
                result.put("status", "success");
                result.put("message", "Voucher được thêm thành công!");
            } else {
                result.put("status", "error");
                result.put("message", "Thêm Voucher thất bại!");
            }


        } catch (NumberFormatException | NullPointerException e) {
            result.put("status", "error");
            result.put("message", "Invalid data");
        }

        sendResponse(resp, result);
    }

    private void updateVoucher(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Map<String, String> result = new HashMap<>();
        try {
            int voucherId = Integer.parseInt(req.getParameter("voucherId"));
            String code = req.getParameter("code");
            String description = req.getParameter("description");
            int discountType = Integer.parseInt(req.getParameter("discountType"));
            double discountValue = Double.parseDouble(req.getParameter("discountValue"));
            double minOrderValue = Double.parseDouble(req.getParameter("minOrderValue"));

            String maxDiscountValueStr = req.getParameter("maxDiscountValue");
            Double maxDiscountValue = maxDiscountValueStr != null && !maxDiscountValueStr.isEmpty()
                    ? Double.parseDouble(maxDiscountValueStr) : null;

            String startDate = req.getParameter("startDate");
            String endDate = req.getParameter("endDate");

            String usageLimitStr = req.getParameter("usageLimit");
            Integer usageLimit = usageLimitStr != null && !usageLimitStr.isEmpty()
                    ? Integer.parseInt(usageLimitStr) : null;

            String perUserLimitStr = req.getParameter("perUserLimit");
            Integer perUserLimit = perUserLimitStr != null && !perUserLimitStr.isEmpty()
                    ? Integer.parseInt(perUserLimitStr) : null;

            int status = Integer.parseInt(req.getParameter("status"));

            Voucher voucher = Voucher.builder()
                    .id(voucherId)
                    .code(code)
                    .description(description)
                    .discountType(discountType)
                    .discountValue(discountValue)
                    .minOrderValue(minOrderValue)
                    .maxDiscountValue(maxDiscountValue)
                    .startDate(startDate)
                    .endDate(endDate)
                    .usageLimit(usageLimit)
                    .perUserLimit(perUserLimit)
                    .status(status)
                    .build();

            boolean isUpdate = voucherService.updateVoucher(voucher);
            if (isUpdate) {
                result.put("status", "success");
                result.put("message", "Voucher đã được cập nhật thành công!");
            } else {
                result.put("status", "error");
                result.put("message", "Voucher cập nhật thất bại");
            }


        } catch (NumberFormatException | NullPointerException e) {
            result.put("status", "error");
            result.put("message", "Invalid data");

        }
        sendResponse(resp, result);
    }

    private void sendResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }


}