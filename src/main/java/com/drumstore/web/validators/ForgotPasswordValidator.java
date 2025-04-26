package com.drumstore.web.validators;

import com.drumstore.web.constants.ValidationPatterns;
import com.drumstore.web.utils.StringUtils;

import java.util.HashMap;
import java.util.Map;

public class ForgotPasswordValidator {
    public Map<String, String> validate(String email) {
        Map<String, String> errors = new HashMap<>();

        if (StringUtils.isBlank(email)) {
            errors.put("email", "Vui lòng nhập email.");
        } else if (!ValidationPatterns.EMAIL.matcher(email).matches()) {
            errors.put("email", "Định dạng email không hợp lệ.");
        }

        return errors;
    }
}
