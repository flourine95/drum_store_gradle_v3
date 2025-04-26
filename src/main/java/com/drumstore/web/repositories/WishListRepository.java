package com.drumstore.web.repositories;

import com.drumstore.web.dto.UserDTO;
import com.drumstore.web.models.User;
import com.drumstore.web.models.WishList;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class WishListRepository {
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<WishList> getAll(int userId) {
        String sql = """
                SELECT * FROM wishlist WHERE userId = :userId
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapToBean(WishList.class)
                        .list()
        );
    }

    public List<WishList> getAll(UserDTO user) {
        String sql = """
                SELECT * FROM wishlist WHERE userId = :userId
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", user.getId())
                        .mapToBean(WishList.class)
                        .list()
        );
    }

    public void save(WishList wishList) {
        String sql = """
                INSERT INTO wishlist (productId, userId, createdAt) VALUES (:productId, :userId, :createdAt)
                """;
        jdbi.useHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(wishList)
                        .execute()
        );
    }

    public void delete(int productId, int userId) {
        jdbi.useHandle(handle -> {
            handle.createUpdate("DELETE FROM wishlist WHERE productId = :productId AND userId = :userId")
                    .bind("productId", productId)
                    .bind("userId", userId).execute();
        });
    }

    public boolean isExists(int productId, int userId) {
        String sql = """
                SELECT COUNT(*) FROM wishlist WHERE userId = :userId AND productId = :productId
                """;
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .bind("productId", productId)
                        .mapTo(Integer.class)
                        .one() > 0
        );
    }
}
