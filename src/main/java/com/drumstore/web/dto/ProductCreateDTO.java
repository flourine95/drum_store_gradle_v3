package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProductCreateDTO implements Serializable {
    private int id;
    private String name;
    private String description;
    private double basePrice;
    private int categoryId;
    private int brandId;
    private int stockManagementType;
    private boolean featured;
    private List<ProductImageDTO> images;
    private List<ProductColorDTO> colors;
    private List<ProductAddonDTO> addons;
    private List<ProductVariantDTO> variants;
}
