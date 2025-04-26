package com.drumstore.web.repositories;

import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class RoleRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<RoleDTO> getAllRoles() {
        String sql = "SELECT * FROM roles";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(RoleDTO.class)
                        .list()
        );
    }

    public List<Integer> getUserIdsByRoleId(int roleId) {
        String sql = "SELECT userId FROM user_roles WHERE roleId = :roleId";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("roleId", roleId)
                        .mapTo(Integer.class)
                        .list()
        );
    }

    public RoleDTO getRoleById(int id) {
        String sql = "SELECT * FROM roles WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(RoleDTO.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public boolean deleteRole(int id) {
        String sql = "DELETE FROM roles WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }

    public boolean roleExists(String name) {
        String sql = "SELECT COUNT(*) FROM roles WHERE name = :name";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("name", name)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public boolean createRole(RoleDTO roleRequest) {
        String sql = "INSERT INTO roles (name, description) VALUES (:name, :description)";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(roleRequest)
                        .execute() > 0
        );
    }

    public boolean updateRole(RoleDTO roleRequest) {
        String sql = "UPDATE roles SET name = :name, description = :description WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(roleRequest)
                        .execute() > 0
        );
    }
}
