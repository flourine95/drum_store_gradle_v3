package com.drumstore.web.services;

import com.drumstore.web.dto.UserAddressDTO;
import com.drumstore.web.models.UserAddress;
import com.drumstore.web.repositories.UserAddressRepository;

import java.util.List;
import java.util.Map;

public class UserAddressService {
    private final UserAddressRepository userAddressRepository = new UserAddressRepository();

    public int isExitsUserAddress(int userId){
        return userAddressRepository.isExistsUserAddress(userId);
    }

    public Map<String, List<UserAddressDTO>> getMainAddressAndSubAddress(int userId){
        return userAddressRepository.getMainAddressAndSubAddress(userId);
    }

}
