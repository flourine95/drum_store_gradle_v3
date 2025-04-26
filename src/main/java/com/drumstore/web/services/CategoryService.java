package com.drumstore.web.services;

import com.drumstore.web.models.Category;
import com.drumstore.web.repositories.CategoryRepository;

import java.util.List;

public class CategoryService {
    private final CategoryRepository categoryRepository = new CategoryRepository();

    public List<Category> all() {
        return categoryRepository.all();
    }

}
