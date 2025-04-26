package com.drumstore.web.validators;

import com.drumstore.web.dto.PermissionDTO;
import com.drumstore.web.repositories.PermissionRepository;
import com.drumstore.web.utils.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class PermissionValidator {
    private final PermissionRepository permissionRepository = new PermissionRepository();

    public Map<String, String> validate(PermissionDTO permission) {
        return validate(permission, false);
    }

    public Map<String, String> validate(PermissionDTO permission, boolean checkId) {
        Map<String, String> errors = new HashMap<>();

        if (checkId && (permission.getId() == null || permission.getId() <= 0)) {
            errors.put("id", "ID không hợp lệ.");
        }

        if (StringUtils.isBlank(permission.getName())) {
            errors.put("name", "Tên quyền không được để trống.");
        } else if (permission.getName().length() > 50) {
            errors.put("name", "Tên quyền không được vượt quá 50 ký tự.");
        } else if (permissionRepository.permissionExists(permission.getName())) {
            errors.put("name", "Tên quyền đã tồn tại.");
        }

        if (permission.getDescription() != null && permission.getDescription().length() > 255) {
            errors.put("description", "Mô tả không được vượt quá 255 ký tự.");
        }

        return errors;
    }
}
