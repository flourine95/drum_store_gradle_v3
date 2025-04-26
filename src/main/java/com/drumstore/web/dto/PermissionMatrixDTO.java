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
public class PermissionMatrixDTO {
    private int permissionId;
    private String permissionName;
    private String permissionDescription;
    private Map<Integer, Boolean> roleCheckboxMap;
}

