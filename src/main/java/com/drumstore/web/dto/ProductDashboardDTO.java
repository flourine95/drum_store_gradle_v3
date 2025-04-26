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
public class ProductDashboardDTO implements Serializable {
    private int id;
    private String name;
    private double basePrice;
    private String categoryName;
    private String brandName;
    private int totalViews;
    private boolean featured;
    private int status;
    private int stock;
    private int totalColors;
    private int totalAddons;
    private int totalVariants;
    private int totalReviews;
    private double avgRating;
    private String mainImage;
    private LocalDateTime createdAt;
}
