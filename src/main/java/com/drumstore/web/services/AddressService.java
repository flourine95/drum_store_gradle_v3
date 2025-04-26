package com.drumstore.web.services;

import com.drumstore.web.dto.AddressDTO;
import com.drumstore.web.repositories.AddressRepository;

import java.util.List;

public class AddressService {
    private final AddressRepository addressRepository = new AddressRepository();

    public List<AddressDTO> getAddressesByUserId(int userId) {
        return addressRepository.getAddressesByUserId(userId);
    }

    public boolean addAddress(AddressDTO addressDTO) {
        return addressRepository.addAddress(addressDTO);
    }

    public boolean updateAddress(AddressDTO addressDTO) {
        return addressRepository.updateAddress(addressDTO);
    }

    public boolean deleteAddress(int addressId, int id) {
        return addressRepository.deleteAddress(addressId, id);
    }

    public AddressDTO getAddressById(int addressId) {
        return addressRepository.getAddressById(addressId);
    }
}
