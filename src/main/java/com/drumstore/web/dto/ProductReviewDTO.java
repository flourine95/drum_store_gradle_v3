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
public class ProductReviewDTO implements Serializable {
    private int id;
    private int userId;
    private String userName;
    private String userAvatar;
    private int orderId;
    private double rating;
    private String content;
    private int status;
    private List<String> images;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
