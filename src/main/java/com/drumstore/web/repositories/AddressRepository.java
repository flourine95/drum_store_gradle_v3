package com.drumstore.web.repositories;

import com.drumstore.web.dto.AddressDTO;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class AddressRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<AddressDTO> getAddressesByUserId(int userId) {
        String sql = """
                SELECT
                    a.id AS id, a.userId AS userId, a.address AS address,
                    a.fullname AS fullname,
                    a.phone AS phone, a.provinceId AS provinceId,
                    a.districtId AS districtId, a.wardId AS wardId, a.main AS main
                FROM user_addresses a
                WHERE a.userId = :userId
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapToBean(AddressDTO.class)
                .list()
        );
    }

    public boolean addAddress(AddressDTO addressDTO) {
        if (addressDTO.isMain()) {
            jdbi.useHandle(handle ->
                    handle.createUpdate("UPDATE user_addresses SET main = false WHERE userId = :userId")
                            .bind("userId", addressDTO.getUserId())
                            .execute()
            );
        }
        String sql = """
                    INSERT INTO user_addresses (userId, address, fullname, phone, provinceId, districtId, wardId, main)
                    VALUES (:userId, :address,:fullname, :phone, :provinceId, :districtId, :wardId, :main)
                """;
        int result = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(addressDTO)
                        .execute()
        );
        return result > 0;
    }

    public boolean updateAddress(AddressDTO addressDTO) {
        if (addressDTO.isMain()) {
            jdbi.useHandle(handle ->
                    handle.createUpdate("UPDATE user_addresses SET main = false WHERE userId = :userId")
                            .bind("userId", addressDTO.getUserId())
                            .execute()
            );
        }

        String sql = """
                UPDATE user_addresses
                SET address = :address, fullname = :fullname, phone = :phone,
                    provinceId = :provinceId, districtId = :districtId, wardId = :wardId, main = :main
                WHERE id = :id AND userId = :userId
                """;

        int result = jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(addressDTO)
                        .execute()
        );

        return result > 0;
    }

    public boolean deleteAddress(int addressId, int id) {
        String sql = """
                DELETE FROM user_addresses
                WHERE id = :addressId AND userId = :userId
                """;
        int result = jdbi.withHandle(handle -> handle.createUpdate(sql)
                .bind("addressId", addressId)
                .bind("userId", id)
                .execute()
        );
        return result > 0;
    }

    public AddressDTO getAddressById(int addressId) {
        String sql = """
                SELECT
                    a.id AS id, a.userId AS userId, a.address AS address,
                    a.fullname AS fullname,
                    a.phone AS phone, a.provinceId AS provinceId,
                    a.districtId AS districtId, a.wardId AS wardId, a.main AS main
                FROM user_addresses a
                WHERE a.id = :addressId
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("addressId", addressId)
                .mapToBean(AddressDTO.class)
                .findFirst()
                .orElse(null)
        );
    }
}
