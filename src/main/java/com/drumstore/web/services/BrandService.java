package com.drumstore.web.services;

import com.drumstore.web.models.Brand;
import com.drumstore.web.repositories.BrandRepository;

import java.util.List;

public class BrandService {
    private final BrandRepository brandRepository = new BrandRepository();

    public List<Brand> all() {
        return brandRepository.all();
    }
}
