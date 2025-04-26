package com.drumstore.web.repositories;

import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.dto.RoleDTO;
import com.drumstore.web.models.User;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;
import org.mindrot.jbcrypt.BCrypt;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.stream.Collectors;

public class UserRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public int store(UserDTO user) {
        String query = """
                INSERT INTO users (email, password, fullname, status, avatar, createdAt)
                VALUES (:email, :password, :fullname, :status, :avatar, CURRENT_TIMESTAMP)
                """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(query)
                        .bindBean(user)
                        .execute()
        );
    }

    public int update(UserDTO user) {
        String query = """
                UPDATE users SET phone = :phone, fullname = :fullname WHERE id = :id
                """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(query)
                        .bindBean(user)
                        .execute()
        );
    }


    public boolean register(User user) {
        String query = """
                INSERT INTO users (email, password, fullname, status, createdAt)
                VALUES (:email, :password, :fullname, 1, CURRENT_TIMESTAMP)
                """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(query)
                        .bindBean(user)
                        .execute() > 0
        );
    }

    public boolean registerWithNotAuthen(User user) {
        String query = """
                INSERT INTO users (email, password, fullname, status, createdAt)
                VALUES (:email, :password, :fullname, 0, CURRENT_TIMESTAMP)
                """;
        return jdbi.withHandle(handle ->
                handle.createUpdate(query)
                        .bindBean(user)
                        .execute() > 0
        );
    }

    public boolean isPhoneExists(String phone) {
        String query = "SELECT COUNT(*) FROM users WHERE phone = ?";
        return jdbi.withHandle(handle -> handle.createQuery(query).bind(0, phone).mapTo(Integer.class).one()) > 0;
    }

    public boolean isEmailExists(String email) {
        String query = "SELECT COUNT(*) FROM users WHERE email = ?";
        return jdbi.withHandle(handle -> handle.createQuery(query).bind(0, email).mapTo(Integer.class).one()) > 0;
    }

    public void saveResetToken(int userId, String token, LocalDateTime expiryTime) {
        String sql = """
                INSERT INTO password_resets
                (userId, token, expiryTime, used, createdAt)
                VALUES (:userId, :token, :expiryTime, 0, CURRENT_TIMESTAMP)
                """;
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("token", token)
                        .bind("expiryTime", expiryTime)
                        .execute()
        );
    }

    public boolean isResetTokenValid(String token) {
        String sql = """
                SELECT COUNT(*) FROM password_resets 
                WHERE token = :token 
                AND expiryTime > CURRENT_TIMESTAMP
                AND used = 0
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("token", token)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }

    public void markResetTokenAsUsed(String token) {
        String sql = """
                UPDATE password_resets
                SET used = 1,
                    usedAt = CURRENT_TIMESTAMP
                WHERE token = :token
                """;
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("token", token)
                        .execute()
        );
    }

    public User findByResetToken(String token) {
        String sql = """
                SELECT u.* FROM users u
                JOIN password_resets pr ON u.id = pr.userId
                WHERE pr.token = :token
                AND pr.expiryTime > CURRENT_TIMESTAMP
                AND pr.used = 0
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("token", token)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void updatePassword(int userId, String newPassword) {
        String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        String sql = "UPDATE users SET password = :password WHERE id = :userId";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("password", hashedPassword)
                        .execute()
        );
    }

    public boolean hasPermission(int userId, String permissionName) {
        String sql = """
                    SELECT COUNT(*) > 0
                    FROM users u
                    JOIN user_roles ur ON u.id = ur.userId
                    JOIN role_permissions rp ON ur.roleId = rp.roleId
                    JOIN permissions p ON rp.permissionId = p.id
                    WHERE u.id = :userId
                    AND p.name = :permissionName
                    AND u.status = 1
                """;

        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("permissionName", permissionName)
                        .mapTo(Boolean.class)
                        .findFirst()
                        .orElse(false)
        );

    }

    public UserDTO login(String username, String password) {
        String query = """
                SELECT
                    u.id AS u_id, u.email AS u_email, u.password AS u_password, u.fullname AS u_fullname,
                    u.phone AS u_phone, u.status AS u_status, u.avatar AS u_avatar,
                    r.name AS r_name, p.name AS p_name
                FROM users u
                LEFT JOIN user_roles ur ON u.id = ur.userId
                LEFT JOIN roles r ON ur.roleId = r.id
                LEFT JOIN role_permissions rp ON r.id = rp.roleId
                LEFT JOIN permissions p ON rp.permissionId = p.id
                WHERE (u.email = :username) 
                 
                """;
//        AND u.status = 1
        return jdbi.withHandle(handle -> handle.createQuery(query)
                .bind("username", username)
                .registerRowMapper(BeanMapper.factory(UserDTO.class, "u"))
                .reduceRows(new LinkedHashMap<Integer, UserDTO>(), (map, row) -> {
                    UserDTO user = map.computeIfAbsent(
                            row.getColumn("u_id", Integer.class),
                            _ -> row.getRow(UserDTO.class)
                    );

                    String role = row.getColumn("r_name", String.class);
                    if (role != null) {
                        user.addRole(role);
                    }

                    String permission = row.getColumn("p_name", String.class);
                    if (permission != null) {
                        user.addPermission(permission);
                    }

                    return map;
                })
                .values()
                .stream()
                .findFirst()
                .filter(user -> {
                    boolean isValid = BCrypt.checkpw(password, user.getPassword());
                    user.setPassword(null);
                    return isValid;
                })
                .orElse(null)
        );
    }

    public UserDTO findUser(String field, Object value) {
        String sql = """
                SELECT
                    u.id AS u_id, u.email AS u_email, u.password AS u_password, u.fullname AS u_fullname,
                    u.phone AS u_phone, u.status AS u_status, u.avatar AS u_avatar,
                    r.name AS r_name, p.name AS p_name
                FROM users u
                LEFT JOIN user_roles ur ON u.id = ur.userId
                LEFT JOIN roles r ON ur.roleId = r.id
                LEFT JOIN role_permissions rp ON r.id = rp.roleId
                LEFT JOIN permissions p ON rp.permissionId = p.id
                WHERE u.""" + field +
                """ 
                        = :value
                        """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("value", value)
                .registerRowMapper(BeanMapper.factory(UserDTO.class, "u"))
                .reduceRows(new LinkedHashMap<Integer, UserDTO>(), (map, row) -> {
                    UserDTO user = map.computeIfAbsent(
                            row.getColumn("u_id", Integer.class),
                            _ -> row.getRow(UserDTO.class)
                    );

                    String role = row.getColumn("r_name", String.class);
                    if (role != null) {
                        user.addRole(role);
                    }

                    String permission = row.getColumn("p_name", String.class);
                    if (permission != null) {
                        user.addPermission(permission);
                    }

                    return map;
                })
                .values()
                .stream()
                .findFirst()
                .orElse(null)
        );
    }

    public void updateStatus(String email){
        String sql = "UPDATE users SET status = 1 WHERE email = :email";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("email", email)
                        .execute()
        );
    }

    public List<UserDTO> getAllUsers() {
        String sql = """
                SELECT
                    u.id AS u_id, u.email AS u_email, u.fullname AS u_fullname,
                    u.phone AS u_phone, u.status AS u_status, u.avatar AS u_avatar,
                    r.name AS r_name, p.name AS p_name
                FROM users u
                LEFT JOIN user_roles ur ON u.id = ur.userId
                LEFT JOIN roles r ON ur.roleId = r.id
                LEFT JOIN role_permissions rp ON r.id = rp.roleId
                LEFT JOIN permissions p ON rp.permissionId = p.id
                """;
        return jdbi.withHandle(handle -> new ArrayList<>(handle.createQuery(sql)
                .registerRowMapper(BeanMapper.factory(UserDTO.class, "u"))
                .reduceRows(new LinkedHashMap<Integer, UserDTO>(), (map, row) -> {
                    UserDTO user = map.computeIfAbsent(
                            row.getColumn("u_id", Integer.class),
                            _ -> row.getRow(UserDTO.class)
                    );

                    String role = row.getColumn("r_name", String.class);
                    if (role != null) {
                        user.addRole(role);
                    }

                    String permission = row.getColumn("p_name", String.class);
                    if (permission != null) {
                        user.addPermission(permission);
                    }

                    return map;
                })
                .values())
        );
    }

    public UserDTO findById(int id) {
        return findUser("id", id);
    }

    public List<RoleDTO> getUserRoles(int userId) {
        String sql = """
                SELECT r.*
                FROM roles r
                JOIN user_roles ur ON r.id = ur.roleId
                WHERE ur.userId = :userId
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .mapToBean(RoleDTO.class)
                .list()
        );
    }

    public void addUserRole(int userId, int roleId) {
        String sql = "INSERT INTO user_roles (userId, roleId) VALUES (:userId, :roleId)";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("roleId", roleId)
                        .execute()
        );
    }

    public void removeUserRole(int userId, int roleId) {
        String sql = "DELETE FROM user_roles WHERE userId = :userId AND roleId = :roleId";
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userId", userId)
                        .bind("roleId", roleId)
                        .execute()
        );
    }
}