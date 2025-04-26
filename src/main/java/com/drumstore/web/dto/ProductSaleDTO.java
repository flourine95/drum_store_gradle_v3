package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductSaleDTO implements Serializable {
    private int id;
    private String name;
    private double discountPercentage;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
}
