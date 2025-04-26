package com.drumstore.web.services;

import com.drumstore.web.dto.VoucherDTO;
import com.drumstore.web.models.Voucher;
import com.drumstore.web.models.VoucherUser;
import com.drumstore.web.repositories.VoucherRepository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class VoucherService {
    private final VoucherRepository voucherRepository = new VoucherRepository();

    /**
     * Áp mã khuyến mãi
     */
    public Map<String, Object> applyVoucher(int userId, String code, double orderValue) {
        Map<String, Object> response = new HashMap<>();

        // Tìm voucher
        Optional<VoucherDTO> voucherOpt = voucherRepository.findByCode(code);
        if (voucherOpt.isEmpty()) {
            response.put("status", "error");
            response.put("error", "invalid");
            response.put("message", "Mã khuyến mãi không hợp lệ!");
            return response;
        }
        VoucherDTO voucher = voucherOpt.get();

        // Kiểm tra trạng thái voucher
        if (!voucher.isActive()) {
            response.put("status", "error");
            response.put("error", "expired");
            response.put("message", "Mã khuyến mãi đã hết hạn hoặc chưa hoạt động!");
            return response;
        }

        // Kiểm tra usageLimit
        if (!getTotalUsageCount(voucher, userId)) {
            response.put("status", "error");
            response.put("error", "usage_limit_exceeded");
            response.put("message", "Mã khuyến mãi đã được sử dụng hết số lần cho phép!");
            return response;
        }

        // Kiểm tra perUserLimit
        int userUsageCount = voucherRepository.getUserUsageCount(voucher.getId(), userId);
        if (userUsageCount >= voucher.getPerUserLimit()) {
            response.put("status", "error");
            response.put("error", "user_limit_exceeded");
            response.put("message", "Bạn đã sử dụng mã này quá số lần cho phép!");
            return response;
        }

        // Kiểm tra minOrderValue
        if (orderValue < voucher.getMinOrderValue()) {
            response.put("status", "error");
            response.put("error", "not_applicable");
            response.put("message", "Đơn hàng chưa đạt giá trị tối thiểu để áp dụng mã này! Cần tối thiểu " +
                    voucher.getMinOrderValue() + " VND.");
            return response;
        }

        // Tính số tiền giảm
        double discount = voucher.calculateDiscount(orderValue);
        if (discount == 0.0) {
            response.put("status", "error");
            response.put("error", "not_applicable");
            response.put("message", "Không thể áp dụng mã khuyến mãi cho đơn hàng này!");
            return response;
        }
        response.put("status", "success");
        response.put("discount", discount);
        response.put("voucher", voucher);

        return response;
    }

    private boolean getTotalUsageCount(VoucherDTO voucher, int userId) {
        // Kiểm tra người dùng đã sử dụng chưa
        Optional<VoucherUser> optVoucherUser = voucherRepository.findVoucherUser(voucher.getId(), userId);
        return optVoucherUser.map(voucherUser -> voucherUser.getUsed() < voucher.getPerUserLimit()).orElse(true);
    }

    public List<VoucherDTO> getAllVouchers(){
        return voucherRepository.getAllVouchers();
    }

    public Voucher getVoucherById(int voucherId) {
        return voucherRepository.findVoucherById(voucherId)
                .orElse(null);
    }

    public boolean updateVoucher(Voucher voucher) {
        return voucherRepository.updateVoucher(voucher);
    }

    public boolean addVoucher(Voucher voucher) {
        return voucherRepository.addVoucher(voucher);
    }

    public boolean deleteVoucher(int voucherId) {
        return voucherRepository.deleteVoucherById(voucherId);
    }
}