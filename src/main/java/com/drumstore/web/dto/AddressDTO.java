package com.drumstore.web.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AddressDTO implements Serializable {
    private int id;
    private int userId;
    private String fullname;
    private String address;
    private String phone;
    private int provinceId;
    private int districtId;
    private int wardId;
    private boolean main;
}
