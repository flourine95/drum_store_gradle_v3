package com.drumstore.web.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OrderItemDTO {
    private int id;
    private int variantId;
    private String name;
    private int quantity;
    private double basePrice;
    private double finalPrice;
    private String imageUrl;


}