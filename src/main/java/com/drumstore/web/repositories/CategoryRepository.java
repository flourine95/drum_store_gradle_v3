package com.drumstore.web.repositories;

import com.drumstore.web.models.Category;
import com.drumstore.web.models.Product;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class CategoryRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<Category> all() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM categories")
                        .mapToBean(Category.class)
                        .list()
        );
    }
}
