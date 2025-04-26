package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VoucherDTO implements Serializable {
    private int id;
    private String code;
    private String description;
    private byte discountType;
    private double discountValue;
    private double minOrderValue;
    private double maxDiscountValue;
    private Timestamp startDate;
    private Timestamp endDate;
    private byte status;
    private int perUserLimit;

    // Kiểm tra trạng thái voucher
    public boolean isActive() {
        Timestamp now = new Timestamp(System.currentTimeMillis());
        return status == 1 &&
                startDate.before(now) &&
                endDate.after(now);
    }

    // Tính số tiền giảm
    public double calculateDiscount(double orderValue) {
        if (!isActive() || orderValue < minOrderValue) {
            return 0.0;
        }

        double discount;
        // Giảm theo phần trăm
        if (discountType == 0) {
            discount = orderValue * (discountValue / 100.0);
            if (maxDiscountValue != 0 && discount > maxDiscountValue) {
                discount = maxDiscountValue;
            }
        } else {
            discount = discountValue;
        }

        return discount;
    }
}