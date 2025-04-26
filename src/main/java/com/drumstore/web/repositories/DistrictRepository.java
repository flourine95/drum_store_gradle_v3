package com.drumstore.web.repositories;

import com.drumstore.web.models.District;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class DistrictRepository {
    private final Jdbi jdbi;

    public DistrictRepository() {
        this.jdbi = DBConnection.getJdbi();
    }

    public List<District> getDistrictsByProvinceId(int provinceId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM districts WHERE provinceId = :provinceId")
                        .bind("provinceId", provinceId)
                        .mapToBean(District.class)
                        .list()
        );
    }

    public District getDistrictById(int districtId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM districts WHERE id = :id")
                        .bind("id", districtId)
                        .mapToBean(District.class)
                        .findFirst()
                        .orElse(null)
        );
    }
}
