package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRoleMatrixDTO {
    private Integer userId;
    private String userEmail;
    private String userFullName;
    private Map<Integer, Boolean> roleCheckboxMap;
}
