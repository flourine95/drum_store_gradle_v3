package com.drumstore.web.repositories;

import com.drumstore.web.models.Brand;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class BrandRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<Brand> all() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM brands")
                        .mapToBean(Brand.class)
                        .list()
        );
    }
}
