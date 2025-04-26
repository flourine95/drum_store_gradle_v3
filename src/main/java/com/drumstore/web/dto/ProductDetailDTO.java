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
public class ProductDetailDTO implements Serializable {
    private int id;
    private String name;
    private String description;
    private double basePrice;
    private boolean featured;
    private int status;
    private double averageRating;
    private int totalViews;
    private int totalReviews;
    private int stockManagementType;
    private int categoryId;
    private String categoryName;
    private int brandId;
    private String brandName;
    private String mainImage;
    private double discountPercent;
    private LocalDateTime createdAt;
    private List<ProductImageDTO> images;
    private List<ProductReviewDTO> reviews;
    private List<ProductSaleDTO> sales;
    private List<ProductVariantDTO> variants;

    public double getLowestSalePrice() {
        double discountedBasePrice = basePrice * (1 - discountPercent / 100.0);

        if (variants == null || variants.isEmpty()) {
            return discountedBasePrice;
        }

        double minAdditionalPrice = Double.MAX_VALUE;
        for (ProductVariantDTO variant : variants) {
            minAdditionalPrice = Math.min(minAdditionalPrice, variant.getAdditionalPrice());
        }

        return (basePrice + minAdditionalPrice) * (1 - discountPercent / 100.0);
    }

    public double getAverageRating() {
        if (reviews == null || reviews.isEmpty()) {
            return 0.0;
        }
        return reviews.stream()
                .mapToDouble(ProductReviewDTO::getRating)
                .average()
                .orElse(0.0);
    }

    public int getTotalReviews() {
        if (reviews == null) {
            return 0;
        }
        return reviews.size();
    }

    public String getMainImage() {
        return images.stream().filter(ProductImageDTO::isMain).findFirst().map(ProductImageDTO::getImage).orElse(null);
    }

}
