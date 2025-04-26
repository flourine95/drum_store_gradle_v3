package com.drumstore.web.repositories;

import com.drumstore.web.dto.OrderHistoryDTO;
import com.drumstore.web.dto.ProductVariantDTO;
import com.drumstore.web.models.OrderItem;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderItemRepository {
    private final Jdbi jdbi;

    public OrderItemRepository() {
        this.jdbi = DBConnection.getJdbi();
    }

    public OrderItem save(Handle handle, OrderItem orderItem) {
        String insertQuery = "INSERT INTO order_items (orderId, variantId, quantity, basePrice, finalPrice, createdAt) " +
                "VALUES (:orderId, :variantId, :quantity, :basePrice, :finalPrice, :createdAt)";
        int orderItemId =
                handle.createUpdate(insertQuery)
                        .bindBean(orderItem)
                        .executeAndReturnGeneratedKeys("id")
                        .mapTo(int.class)
                        .one();
        orderItem.setId(orderItemId);
        return orderItem;
    }

    public List<OrderItem> findByOrderId(Handle handle, int orderId) {
        return handle.createQuery("SELECT * FROM order_items WHERE orderId = :orderId")
                .bind("orderId", orderId)
                .mapToBean(OrderItem.class)
                .list();
    }

    public void deleteByOrderId(Handle handle, int orderId) {
        handle.createUpdate("DELETE FROM order_items WHERE orderId = :orderId")
                .bind("orderId", orderId)
                .execute();
    }


    public void updateQuantity(Handle handle, int orderItem, int quantity) {
        handle.createUpdate("UPDATE order_items SET quantity = :quantity WHERE id = :id")
                .bind("quantity", quantity)
                .bind("id", orderItem)
                .execute();
    }

    public boolean removerOrderItem(int orderItemId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("DELETE FROM order_items WHERE id = :id")
                        .bind("id", orderItemId)
                        .execute() > 0
        );
    }

    public OrderItem getOrderItemById(int orderItemId) {
        String sql = "SELECT * FROM order_items WHERE id = :id";
        return jdbi.withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", orderItemId)
                        .registerRowMapper(BeanMapper.factory(OrderItem.class))
                        .mapTo(OrderItem.class)
                        .findOne()
                        .orElse(null)
        );

    }

    public boolean modifyStatusOrder(int orderId, int statusId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("UPDATE  orders SET status = :status WHERE id = :id")
                        .bind("id", orderId)
                        .bind("status", statusId)
                        .execute() > 0
        );
    }

    public boolean removerOrder(int orderId) {
        return jdbi.withHandle(handle ->
                handle.createUpdate("DELETE FROM orders WHERE id = :id")
                        .bind("id", orderId)
                        .execute() > 0
        );
    }
}
