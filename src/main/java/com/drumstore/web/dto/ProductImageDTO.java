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
public class ProductImageDTO implements Serializable {
    private int id;
    private int productId;
    private String image;
    private boolean main;
    private int sortOrder;
    private LocalDateTime createdAt;
}
