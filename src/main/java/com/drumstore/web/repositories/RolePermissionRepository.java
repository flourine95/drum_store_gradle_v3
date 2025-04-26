package com.drumstore.web.repositories;

import com.drumstore.web.dto.RolePermissionDTO;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class RolePermissionRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<RolePermissionDTO> getAllRolePermissions() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM role_permissions")
                        .mapToBean(RolePermissionDTO.class)
                        .list()
        );
    }

    public boolean hasRolePermission(int roleId, int permissionId) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT COUNT(*) FROM role_permissions WHERE roleId = :roleId AND permissionId = :permissionId")
                        .bind("roleId", roleId)
                        .bind("permissionId", permissionId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public void deleteRolePermission(int roleId, int permissionId) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("DELETE FROM role_permissions WHERE roleId = :roleId AND permissionId = :permissionId")
                    .bind("roleId", roleId)
                    .bind("permissionId", permissionId)
                    .execute();
        });
    }

    public void saveRolePermission(int roleId, int permissionId) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("INSERT INTO role_permissions (roleId, permissionId) VALUES (:roleId, :permissionId)")
                    .bind("roleId", roleId)
                    .bind("permissionId", permissionId)
                    .execute();
        });
    }
}
