package com.drumstore.web.validators;

import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.repositories.RoleRepository;
import com.drumstore.web.utils.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class RoleValidator {
    private final RoleRepository roleRepository = new RoleRepository();

    public Map<String, String> validate(RoleDTO role) {
        return validate(role, false);
    }

    public Map<String, String> validate(RoleDTO role, boolean checkId) {
        Map<String, String> errors = new HashMap<>();

        if (checkId && (role.getId() == null || role.getId() <= 0)) {
            errors.put("id", "ID không hợp lệ.");
        }

        if (StringUtils.isBlank(role.getName())) {
            errors.put("name", "Tên vai trò không được để trống.");
        } else if (role.getName().length() > 50) {
            errors.put("name", "Tên vai trò không được vượt quá 50 ký tự.");
        } else if (roleRepository.roleExists(role.getName())) {
            errors.put("name", "Tên vai trò đã tồn tại.");
        }

        if (role.getDescription() != null && role.getDescription().length() > 255) {
            errors.put("description", "Mô tả không được vượt quá 255 ký tự.");
        }

        return errors;
    }
}
