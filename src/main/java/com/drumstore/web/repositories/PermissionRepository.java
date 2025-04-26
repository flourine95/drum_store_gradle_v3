package com.drumstore.web.repositories;

import com.drumstore.web.dto.PermissionDTO;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class PermissionRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<PermissionDTO> getAllPermissions() {
        String sql = "SELECT * FROM permissions";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(PermissionDTO.class)
                        .list()
        );
    }

    public PermissionDTO getPermissionById(int id) {
        String sql = "SELECT * FROM permissions WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(PermissionDTO.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public List<Integer> getUserIdsByPermissionId(int id) {
        String sql = """
                    SELECT DISTINCT u.id
                    FROM users u
                    JOIN user_roles ur ON u.id = ur.userId
                    JOIN role_permissions rp ON ur.roleId = rp.roleId
                    WHERE rp.permissionId = :id
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapTo(Integer.class)
                        .list()
        );
    }

    public boolean deletePermission(int id) {
        String sql = "DELETE FROM permissions WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }

    public boolean createPermission(PermissionDTO permissionRequest) {
        String sql = "INSERT INTO permissions (name, description) VALUES (:name, :description)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(permissionRequest)
                        .execute() > 0
        );
    }

    public boolean permissionExists(String name) {
        String sql = "SELECT COUNT(*) FROM permissions WHERE name = :name";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("name", name)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean updatePermission(PermissionDTO permissionRequest) {
        String sql = "UPDATE permissions SET name = :name, description = :description WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(permissionRequest)
                        .execute() > 0
        );
    }
}
