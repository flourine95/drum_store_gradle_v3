package com.drumstore.web.repositories;

import com.drumstore.web.models.Ward;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class WardRepository {
    private final Jdbi jdbi;

    public WardRepository() {
        this.jdbi = DBConnection.getJdbi();
    }

    public List<Ward> getWardsByDistrictId(int districtId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM wards WHERE districtId = :districtId")
                        .bind("districtId", districtId)
                        .mapToBean(Ward.class)
                        .list()
        );
    }

    public Ward getWardById(int wardId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM wards WHERE id = :id")
                        .bind("id", wardId)
                        .mapToBean(Ward.class)
                        .findFirst()
                        .orElse(null)
        );
    }
}
