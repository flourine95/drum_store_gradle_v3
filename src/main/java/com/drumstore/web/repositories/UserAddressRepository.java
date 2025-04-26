package com.drumstore.web.repositories;

import com.drumstore.web.dto.UserAddressDTO;
import com.drumstore.web.models.UserAddress;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserAddressRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public int isExistsUserAddress(int userId) {
        String sql = """
            SELECT COUNT(*) FROM user_addresses WHERE userid = :userId
            """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(int.class)
                        .one()
        );
    }

    public Map<String, List<UserAddressDTO>> getMainAddressAndSubAddress(int userId) {
        Map<String, List<UserAddressDTO>> map = new HashMap<>();
        List<UserAddressDTO> mainAddress = new ArrayList<>();
        List<UserAddressDTO> subAddress = new ArrayList<>();

        String sql = """
                    SELECT 
                        us.id, 
                        us.fullname,
                        us.phone,
                        p.name AS province, 
                        d.name AS district, 
                        w.name AS ward, 
                        us.address AS fullAddress, 
                        us.main 
                    FROM user_addresses us
                    INNER JOIN provinces p ON us.provinceId = p.id
                    INNER JOIN districts d ON us.districtId = d.id
                    INNER JOIN wards w ON us.wardId = w.id
                    WHERE us.userId = :userId
                """;
        List<UserAddressDTO> addresses = jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(UserAddressDTO.class)
                        .list()
        );

        for (UserAddressDTO address : addresses) {
            if (address.isMain()) {
                mainAddress.add(address);
            } else {
                subAddress.add(address);
            }
        }

        map.put("mainAddress", mainAddress);
        map.put("subAddress", subAddress);

        return map;
    }

}
