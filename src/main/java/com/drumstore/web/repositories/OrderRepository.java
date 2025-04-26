package com.drumstore.web.repositories;

import com.drumstore.web.constants.OrderConstants;
import com.drumstore.web.constants.PaymentConstants;
import com.drumstore.web.dto.AddressDTO;
import com.drumstore.web.dto.OrderHistoryDTO;
import com.drumstore.web.dto.OrderItemDTO;
import com.drumstore.web.models.Order;
import com.drumstore.web.models.OrderItem;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;
import org.jdbi.v3.core.mapper.reflect.BeanMapper;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class OrderRepository {
    private final Jdbi jdbi;

    public OrderRepository() {
        this.jdbi = DBConnection.getJdbi();
    }

    public Order find(int id) {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders WHERE id = :id")
                        .bind("id", id)
                        .mapToBean(Order.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public List<Order> all() {
        return jdbi.withHandle(handle ->
                handle.createQuery("SELECT * FROM orders")
                        .mapToBean(Order.class)
                        .list()
        );
    }

    public Order findWithDetails(int id) {
        String sql = """
                SELECT
                    o.id AS o_id, o.userId AS o_userId, o.userAddressId AS o_userAddressId,
                    o.totalAmount AS o_totalAmount, o.orderDate AS o_orderDate, o.status AS o_status,
                    o.createdAt AS o_createdAt, o.updatedAt AS o_updatedAt, o.deletedAt AS o_deletedAt,
                    oi.id AS oi_id, oi.orderId AS oi_orderId, oi.productId AS oi_productId,
                    oi.quantity AS oi_quantity, oi.price AS oi_price, oi.createdAt AS oi_createdAt,
                    oi.updatedAt AS oi_updatedAt
                FROM orders o
                         LEFT JOIN order_items oi ON o.id = oi.orderId
                WHERE o.id = :id
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("id", id)
                .registerRowMapper(BeanMapper.factory(Order.class, "o"))
                .registerRowMapper(BeanMapper.factory(OrderItem.class, "oi"))
                .reduceRows(new LinkedHashMap<Integer, Order>(), (map, row) -> {
                    // Tạo hoặc lấy Order từ map
                    Order order = map.computeIfAbsent(
                            row.getColumn("o_id", Integer.class),
                            _ -> row.getRow(Order.class)
                    );

                    // Nếu có OrderItem, thêm vào danh sách
                    if (row.getColumn("oi_id", Integer.class) != null) {
                        order.getItems().add(row.getRow(OrderItem.class));
                    }

                    return map;
                })
                .values()
                .stream()
                .findFirst()
                .orElse(null)
        );
    }

    public boolean deleteOrder(int orderId) {
        try {
            // Sử dụng jdbi để thực thi câu lệnh xóa đơn hàng
            jdbi.useHandle(handle ->
                    handle.createUpdate("DELETE FROM orders WHERE id = :orderId")
                            .bind("orderId", orderId)
                            .execute()
            );
            return true; // Trả về true nếu xóa thành công
        } catch (Exception e) {
            // Xử lý lỗi nếu có
            e.printStackTrace();
            return false; // Trả về false nếu có lỗi xảy ra
        }
    }

    public Order save(Handle handle, Order order) {
        String insertQuery = "INSERT INTO orders (userId, userAddressId, totalAmount, orderDate, status, createdAt) " +
                "VALUES (:userId, :userAddressId, :totalAmount, :orderDate, :status, :createdAt)";

        int orderId = handle.createUpdate(insertQuery) // Sử dụng handle trực tiếp trong transaction
                .bindBean(order)
                .executeAndReturnGeneratedKeys("id")
                .mapTo(int.class)
                .one();

        order.setId(orderId);
        return order;
    }

    public List<OrderHistoryDTO> orderHistoryList() {
        String sql = """
                    SELECT o.id AS orderId, o.orderDate, o.totalAmount, o.status AS orderStatus,
                           o.userAddressId, p.paymentMethod, p.status AS paymentStatus, p.transactionId,
                           oi.id AS orderItemId, oi.variantId, oi.quantity, oi.basePrice, oi.finalPrice,
                           a.id AS addressId, a.userId AS addressUserId, a.fullname, a.address, 
                           a.phone, a.provinceId, a.districtId, a.wardId,
                           pi.image, ps.name AS product_name
                    FROM orders o
                    LEFT JOIN payments p ON o.id = p.orderId
                    LEFT JOIN order_items oi ON o.id = oi.orderId
                    LEFT JOIN user_addresses a ON o.userAddressId = a.id
                    LEFT JOIN product_variants pv ON oi.variantId = pv.id
                    LEFT JOIN product_images pi ON pv.imageId = pi.id
                    LEFT JOIN products ps ON pv.productId = ps.id
                    ORDER BY o.orderDate DESC
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .reduceRows(new LinkedHashMap<Integer, OrderHistoryDTO>(), (map, row) -> {
                    int orderId = row.getColumn("orderId", Integer.class);

                    OrderHistoryDTO order = map.computeIfAbsent(orderId, id -> {
                        OrderHistoryDTO dto = new OrderHistoryDTO();
                        dto.setOrderId(id);
                        dto.setOrderDate(row.getColumn("orderDate", LocalDateTime.class));
                        dto.setTotalAmount(row.getColumn("totalAmount", Double.class));
                        dto.setOrderStatus(row.getColumn("orderStatus", Integer.class));

                        Integer paymentMethod = row.getColumn("paymentMethod", Integer.class);
                        Integer paymentStatus = row.getColumn("paymentStatus", Integer.class);
                        dto.setOrderStatusText(OrderConstants.Status.fromValue(dto.getOrderStatus()).name());
                        dto.setPaymentMethodText(paymentMethod != null ? PaymentConstants.Method.fromValue(paymentMethod).name() : null);
                        dto.setPaymentStatusText(paymentStatus != null ? PaymentConstants.Status.fromValue(paymentStatus).name() : null);
                        dto.setTransactionId(row.getColumn("transactionId", String.class));

                        // Shipping Address
                        AddressDTO address = new AddressDTO();
                        address.setId(row.getColumn("addressId", Integer.class));
                        address.setUserId(row.getColumn("addressUserId", Integer.class));
                        address.setFullname(row.getColumn("fullname", String.class));
                        address.setAddress(row.getColumn("address", String.class));
                        address.setPhone(row.getColumn("phone", String.class));
                        address.setProvinceId(row.getColumn("provinceId", Integer.class));
                        address.setDistrictId(row.getColumn("districtId", Integer.class));
                        address.setWardId(row.getColumn("wardId", Integer.class));
                        dto.setShippingAddress(address);

                        dto.setItems(new ArrayList<>());
                        return dto;
                    });

                    Integer variantId = row.getColumn("variantId", Integer.class);
                    if (variantId != null) {
                        OrderItemDTO item = new OrderItemDTO();
                        item.setId(row.getColumn("orderItemId", Integer.class));
                        item.setVariantId(variantId);
                        item.setName(row.getColumn("product_name", String.class));
                        item.setQuantity(row.getColumn("quantity", Integer.class));
                        item.setBasePrice(row.getColumn("basePrice", Double.class));
                        item.setFinalPrice(row.getColumn("finalPrice", Double.class));
                        item.setImageUrl(row.getColumn("image", String.class));
                        order.getItems().add(item);
                    }

                    return map;
                }).values().stream().toList());
    }


    public List<OrderHistoryDTO> orderHistoryUserList(int userId) {
        String sql = """
                SELECT o.id AS orderId, o.orderDate, o.totalAmount, o.status AS orderStatus,
                       o.userAddressId, p.paymentMethod, p.status AS paymentStatus, p.transactionId,
                       oi.id AS orderItemId, oi.variantId, oi.quantity, oi.basePrice, oi.finalPrice,
                       a.id AS addressId, a.userId AS addressUserId, a.fullname, a.address, 
                       a.phone, a.provinceId, a.districtId, a.wardId,
                       pi.image, ps.name AS product_name
                FROM orders o
                LEFT JOIN payments p ON o.id = p.orderId
                LEFT JOIN order_items oi ON o.id = oi.orderId
                LEFT JOIN user_addresses a ON o.userAddressId = a.id
                LEFT JOIN product_variants pv ON oi.variantId = pv.id
                LEFT JOIN product_images pi ON pv.imageId = pi.id
                LEFT JOIN products ps ON pv.productId = ps.id
                WHERE o.userId = :userId
                ORDER BY o.orderDate DESC
                """;

        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("userId", userId)
                .reduceRows(new LinkedHashMap<Integer, OrderHistoryDTO>(), (map, row) -> {
                    int orderId = row.getColumn("orderId", Integer.class);
                    OrderHistoryDTO order = map.computeIfAbsent(orderId, id -> {
                        OrderHistoryDTO dto = new OrderHistoryDTO();
                        dto.setOrderId(id);
                        dto.setOrderDate(row.getColumn("orderDate", LocalDateTime.class));
                        dto.setTotalAmount(row.getColumn("totalAmount", Double.class));
                        dto.setOrderStatus((row.getColumn("orderStatus", Integer.class)));
                        dto.setOrderStatusText(OrderConstants.Status.fromValue(dto.getOrderStatus()).name());
                        dto.setPaymentMethodText(PaymentConstants.Method.fromValue(row.getColumn("paymentMethod", Integer.class)).name());
                        dto.setPaymentStatusText(PaymentConstants.Status.fromValue(row.getColumn("paymentStatus", Integer.class)).name());
                        dto.setTransactionId(row.getColumn("transactionId", String.class));

                        AddressDTO address = new AddressDTO();
                        address.setId(row.getColumn("addressId", Integer.class));
                        address.setUserId(row.getColumn("addressUserId", Integer.class));
                        address.setFullname(row.getColumn("fullname", String.class));
                        address.setAddress(row.getColumn("address", String.class));
                        address.setPhone(row.getColumn("phone", String.class));
                        address.setProvinceId(row.getColumn("provinceId", Integer.class));
                        address.setDistrictId(row.getColumn("districtId", Integer.class));
                        address.setWardId(row.getColumn("wardId", Integer.class));
                        dto.setShippingAddress(address);

                        dto.setItems(new ArrayList<>());
                        return dto;
                    });

                    // Thêm sản phẩm nếu có
                    if (row.getColumn("variantId", Integer.class) != null) {
                        OrderItemDTO item = new OrderItemDTO();
                        item.setId(row.getColumn("orderItemId", Integer.class));
                        item.setVariantId(row.getColumn("variantId", Integer.class));
                        item.setName(row.getColumn("product_name", String.class));
                        item.setQuantity(row.getColumn("quantity", Integer.class));
                        item.setBasePrice(row.getColumn("basePrice", Double.class));
                        item.setFinalPrice(row.getColumn("finalPrice", Double.class));
                        item.setImageUrl(row.getColumn("image", String.class));
                        order.getItems().add(item);
                    }
                    return map;
                })
                .values()
                .stream()
                .toList());
    }

    public boolean deleteOrder(Handle handle, int orderId) {
        try {
            handle.createUpdate("DELETE FROM orders WHERE id = :orderId")
                    .bind("orderId", orderId)
                    .execute();
            return true; // Trả về true nếu xóa thành công
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }


    public OrderHistoryDTO getOrderHistoryById(int orderId) {
        String sql = """
                SELECT o.id AS orderId, o.orderDate, o.totalAmount, o.status AS orderStatus,
                           o.userAddressId, p.paymentMethod, p.status AS paymentStatus, p.transactionId,
                           oi.id AS orderItemId, oi.variantId, oi.quantity, oi.basePrice, oi.finalPrice,
                           a.id AS addressId, a.userId AS addressUserId, a.fullname, a.address, 
                           a.phone, a.provinceId, a.districtId, a.wardId,
                           pi.image, ps.name AS product_name
                    FROM orders o
                    LEFT JOIN payments p ON o.id = p.orderId
                    LEFT JOIN order_items oi ON o.id = oi.orderId
                    LEFT JOIN user_addresses a ON o.userAddressId = a.id
                    LEFT JOIN product_variants pv ON oi.variantId = pv.id
                    LEFT JOIN product_images pi ON pv.imageId = pi.id
                    LEFT JOIN products ps ON pv.productId = ps.id
                WHERE o.id = :orderId
                """;

        return jdbi.withHandle(handle -> {
            Map<Integer, OrderHistoryDTO> orderMap = handle.createQuery(sql)
                    .bind("orderId", orderId)
                    .reduceRows(new LinkedHashMap<>(), (map, row) -> {
                        int currentId = row.getColumn("orderId", Integer.class);
                        OrderHistoryDTO order = map.computeIfAbsent(currentId, id -> {
                            OrderHistoryDTO dto = new OrderHistoryDTO();
                            dto.setOrderId(id);
                            dto.setOrderDate(row.getColumn("orderDate", LocalDateTime.class));
                            dto.setTotalAmount(row.getColumn("totalAmount", Double.class));
                            dto.setOrderStatus((row.getColumn("orderStatus", Integer.class)));
                            dto.setOrderStatusText(OrderConstants.Status.fromValue(dto.getOrderStatus()).name());
                            dto.setPaymentMethodText(PaymentConstants.Method.fromValue(row.getColumn("paymentMethod", Integer.class)).name());
                            dto.setPaymentStatusText(PaymentConstants.Status.fromValue(row.getColumn("paymentStatus", Integer.class)).name());
                            dto.setTransactionId(row.getColumn("transactionId", String.class));

                            AddressDTO address = new AddressDTO();
                            address.setId(row.getColumn("addressId", Integer.class));
                            address.setUserId(row.getColumn("addressUserId", Integer.class));
                            address.setFullname(row.getColumn("fullname", String.class));
                            address.setAddress(row.getColumn("address", String.class));
                            address.setPhone(row.getColumn("phone", String.class));
                            address.setProvinceId(row.getColumn("provinceId", Integer.class));
                            address.setDistrictId(row.getColumn("districtId", Integer.class));
                            address.setWardId(row.getColumn("wardId", Integer.class));
                            dto.setShippingAddress(address);

                            dto.setItems(new ArrayList<>());
                            return dto;
                        });

                        // Thêm sản phẩm nếu có
                        if (row.getColumn("variantId", Integer.class) != null) {
                            OrderItemDTO item = new OrderItemDTO();
                            item.setId(row.getColumn("orderItemId", Integer.class));
                            item.setVariantId(row.getColumn("variantId", Integer.class));
                            item.setName(row.getColumn("product_name", String.class));
                            item.setQuantity(row.getColumn("quantity", Integer.class));
                            item.setBasePrice(row.getColumn("basePrice", Double.class));
                            item.setFinalPrice(row.getColumn("finalPrice", Double.class));
                            item.setImageUrl(row.getColumn("image", String.class));
                            order.getItems().add(item);
                        }
                        return map;
                    });

            // Lấy đơn hàng duy nhất hoặc ném ngoại lệ nếu không tìm thấy
            return orderMap.values().stream().findFirst()
                    .orElseThrow(() -> new RuntimeException("Order not found with ID: " + orderId));
        });
    }

    public void updateTotalAmount(int orderId, double total) {
        String sql;
        sql = """
                    UPDATE orders
                    SET totalAmount =  :total
                    WHERE id = :id
                """;


        jdbi.useHandle(handle -> handle.createUpdate(sql)
                .bind("total", total)
                .bind("id", orderId)
                .execute());
    }


}
