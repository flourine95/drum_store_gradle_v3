package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductDashboardDetailDTO implements Serializable {
    private int id;
    private String name;
    private String description;
    private double basePrice;
    private boolean featured;
    private int status;
    private int stockManagementType;
    private String categoryName;
    private String brandName;
    private int totalViews;
    private int totalStock;
    private int averageRating;
    private int totalVariants;
    private int totalReviews;
    private List<ProductImageDTO> images;
    private List<ProductSaleDTO> sales;
    private List<ProductColorDTO> colors;
    private List<ProductReviewDTO> reviews;
    private List<ProductVariantDTO> variants;
    private LocalDateTime createdAt;
}
