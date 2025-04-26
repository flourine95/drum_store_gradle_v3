package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductCardDTO implements Serializable {
    private int id;
    private String name;
    private String mainImage;
    private double basePrice;
    private double lowestSalePrice;
    private double averageRating;
    private boolean featured;
    private double discountPercent;
    private int totalViews;
    private int totalReviews;
    private int categoryId;
    private String categoryName;
    private int brandId;
    private String brandName;
}