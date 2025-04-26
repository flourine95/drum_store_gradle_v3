package com.drumstore.web.services;

import com.drumstore.web.models.Province;
import com.drumstore.web.repositories.ProvinceRepository;

import java.util.List;

public class ProvinceService {
    private final ProvinceRepository provinceRepository;

    public ProvinceService(ProvinceRepository provinceRepository) {
        this.provinceRepository = provinceRepository;
    }

    public List<Province> getProvinces() {
        return provinceRepository.getAllProvinces();
    }
}