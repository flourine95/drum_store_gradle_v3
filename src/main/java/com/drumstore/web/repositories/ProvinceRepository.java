package com.drumstore.web.repositories;

import com.drumstore.web.models.Province;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class ProvinceRepository {
    private final Jdbi jdbi;

    public ProvinceRepository() {
        this.jdbi = DBConnection.getJdbi();
    }

    public List<Province> getAllProvinces() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name FROM provinces")
                        .mapToBean(Province.class)
                        .list()
        );
    }

    public Province getProvinceById(int provinceId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT id, name FROM provinces WHERE id = :id")
                        .bind("id", provinceId)
                        .mapToBean(Province.class)
                        .findFirst()
                        .orElse(null)
        );
    }
}