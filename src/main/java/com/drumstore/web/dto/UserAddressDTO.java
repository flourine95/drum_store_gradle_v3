package com.drumstore.web.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserAddressDTO {
    private int id;
    private String fullName;
    private String phone;
    private String province;
    private String district;
    private String ward;
    private String fullAddress;
    private boolean main;

}
