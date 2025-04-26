package com.drumstore.web.validators;

import com.drumstore.web.constants.ValidationPatterns;
import com.drumstore.web.dto.RegisterRequestDTO;
import com.drumstore.web.services.UserService;

import java.util.HashMap;
import java.util.Map;


public class RegisterValidator {
    private final UserService userService = new UserService();

    public Map<String, String> validate(RegisterRequestDTO req) {
        Map<String, String> errors = new HashMap<>();

        if (isBlank(req.getFullname())) {
            errors.put("fullname", "Họ và tên không được để trống.");
        }

        if (isBlank(req.getPhone())) {
            errors.put("phone", "Số điện thoại không được để trống.");
        } else if (!ValidationPatterns.PHONE.matcher(req.getPhone()).matches()) {
            errors.put("phone", "Số điện thoại không hợp lệ.");
        }

        if (isBlank(req.getEmail())) {
            errors.put("email", "Email không được để trống.");
        } else if (!ValidationPatterns.EMAIL.matcher(req.getEmail()).matches()) {
            errors.put("email", "Email không hợp lệ.");
        } else if (userService.isEmailExists(req.getEmail())) {
            errors.put("email", "Email đã tồn tại.");
        }

        if (isBlank(req.getPassword())) {
            errors.put("password", "Mật khẩu không được để trống.");
        } else if (!ValidationPatterns.PASSWORD.matcher(req.getPassword()).matches()) {
            errors.put("password", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%^&*).");
        }

        if (isBlank(req.getConfirmPassword())) {
            errors.put("confirmPassword", "Xác nhận mật khẩu không được để trống.");
        } else if (!req.getConfirmPassword().equals(req.getPassword())) {
            errors.put("confirmPassword", "Mật khẩu xác nhận không khớp.");
        }

        return errors;
    }

    private boolean isBlank(String str) {
        return str == null || str.trim().isEmpty();
    }
}
