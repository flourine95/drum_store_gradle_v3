package com.drumstore.web.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Voucher {
    private int id;
    private String code;
    private String description;
    private int discountType;
    private double discountValue;
    private double minOrderValue;
    private Double maxDiscountValue;
    private String startDate;
    private String endDate;
    private Integer usageLimit;
    private Integer perUserLimit;
    private int status;

}
