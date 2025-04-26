package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CartItemDTO implements Serializable {
    private int productId;
    private String name;
    private double basePrice;
    private String mainImage;
    private double discountPercent;
    private ProductVariantDTO productVariant; // varient chính
    private Map<String, List<Object>> variants; // varient phục vụ cho update

    public double getLowestSalePrice() {
        double discountedBasePrice = basePrice * (1 - discountPercent / 100.0);

        if (productVariant == null) {
            return discountedBasePrice;
        }

        double colorAdditionalPrice = (productVariant.getColor() != null) ? productVariant.getColor().getAdditionalPrice() : 0.0;
        double addonAdditionalPrice = (productVariant.getAddon() != null) ? productVariant.getAddon().getAdditionalPrice() : 0.0;

        double totalAdditionalPrice = colorAdditionalPrice + addonAdditionalPrice;

        return (basePrice + totalAdditionalPrice) * (1 - discountPercent / 100.0);
    }

}
