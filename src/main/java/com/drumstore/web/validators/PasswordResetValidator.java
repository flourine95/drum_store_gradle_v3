package com.drumstore.web.validators;

import com.drumstore.web.constants.ValidationPatterns;
import com.drumstore.web.utils.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class PasswordResetValidator {
    public Map<String, String> validate(String password, String confirmPassword) {
        Map<String, String> errors = new HashMap<>();

        if (StringUtils.isBlank(password)) {
            errors.put("password", "Mật khẩu không được để trống.");
        } else if (!ValidationPatterns.PASSWORD.matcher(password).matches()) {
            errors.put("password", "Mật khẩu phải có ít nhất 8 ký tự, gồm chữ hoa, chữ thường, số và ký tự đặc biệt (!@#$%^&*).");
        }

        if (StringUtils.isBlank(confirmPassword)) {
            errors.put("confirmPassword", "Vui lòng nhập lại mật khẩu.");
        } else if (!password.equals(confirmPassword)) {
            errors.put("confirmPassword", "Mật khẩu nhập lại không khớp.");
        }

        return errors;
    }
}
