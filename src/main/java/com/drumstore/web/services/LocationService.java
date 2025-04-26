package com.drumstore.web.services;

import com.drumstore.web.models.District;
import com.drumstore.web.models.Province;
import com.drumstore.web.models.Ward;
import com.drumstore.web.repositories.DistrictRepository;
import com.drumstore.web.repositories.ProvinceRepository;
import com.drumstore.web.repositories.WardRepository;

import java.util.List;

public class LocationService {
    private final ProvinceRepository provinceRepository = new ProvinceRepository();
    private final DistrictRepository districtRepository = new DistrictRepository();
    private final WardRepository wardRepository = new WardRepository();

    public List<Province> getAllProvinces() {
        return provinceRepository.getAllProvinces();
    }

    public List<District> getDistrictsByProvinceId(int provinceId) {
        return districtRepository.getDistrictsByProvinceId(provinceId);
    }

    public List<Ward> getWardsByDistrictId(int districtId) {
        return wardRepository.getWardsByDistrictId(districtId);
    }

    public Province getProvinceById(int provinceId) {
        return provinceRepository.getProvinceById(provinceId);
    }

    public District getDistrictById(int districtId) {
        return districtRepository.getDistrictById(districtId);
    }

    public Ward getWardById(int wardId) {
        return wardRepository.getWardById(wardId);
    }
}
