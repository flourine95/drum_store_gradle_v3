package com.drumstore.web.validators;

import com.drumstore.web.constants.ValidationPatterns;
import com.drumstore.web.dto.LoginRequestDTO;
import com.drumstore.web.utils.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class LoginValidator {
    public Map<String, String> validate(LoginRequestDTO loginRequest) {
        Map<String, String> errors = new HashMap<>();

        String email = loginRequest.getEmail();
        String password = loginRequest.getPassword();

        if (StringUtils.isBlank(email)) {
            errors.put("email", "Vui lòng nhập email");
        } else if (!ValidationPatterns.EMAIL.matcher(email).matches()) {
            errors.put("email", "Email không hợp lệ");
        }

        if (StringUtils.isBlank(password)) {
            errors.put("password", "Vui lòng nhập mật khẩu");
        }

        return errors;
    }
}
