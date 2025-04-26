package com.drumstore.web.dto;


import com.drumstore.web.models.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RegisterRequestDTO implements Serializable {
    private String fullname;
    private String email;
    private String phone;
    private String password;
    private String confirmPassword;

    public User toModel() {
        return new User(fullname, email, phone, password);
    }
}

