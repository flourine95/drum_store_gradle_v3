package com.drumstore.web.services;

import com.drumstore.web.constants.OrderConstants;
import com.drumstore.web.constants.PaymentConstants;
import com.drumstore.web.dto.OrderHistoryDTO;
import com.drumstore.web.dto.ProductVariantDTO;
import com.drumstore.web.models.*;
import com.drumstore.web.repositories.OrderItemRepository;
import com.drumstore.web.repositories.OrderRepository;
import com.drumstore.web.repositories.PaymentRepository;
import com.drumstore.web.repositories.ProductRepository;
import com.drumstore.web.utils.DBConnection;
import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.Jdbi;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderService {
    private final OrderRepository orderRepository = new OrderRepository();
    private final OrderItemRepository orderItemRepository = new OrderItemRepository();
    private final ProductRepository productRepository = new ProductRepository();
    private final PaymentService paymentService = new PaymentService();
    private final Jdbi jdbi = DBConnection.getJdbi();

    public List<Order> all() {
        return orderRepository.all();
    }

    public Order find(int id) {
        return orderRepository.find(id);
    }

    public Order findWithDetails(int id) {
        return orderRepository.findWithDetails(id);
    }

    public boolean deleteOrder(int orderId) {
        return orderRepository.deleteOrder(orderId);
    }

    //  Tạo đơn hàng
    public Order createOrder(Handle handle, int userId, double totalAmount, int userAddressId) {
        Order order = new Order();
        order.setUserId(userId);
        order.setUserAddressId(userAddressId);
        order.setTotalAmount((float) totalAmount);
        order.setOrderDate(new Timestamp(System.currentTimeMillis()));
        order.setStatus((byte) 0); // Pending
        order.setCreatedAt(new Timestamp(System.currentTimeMillis()));
        return orderRepository.save(handle, order);
    }

    //  Kiểm tra & cập nhật stock
    public boolean updateStock(Handle handle, int variantId, int quantity) {
        ProductVariantDTO productVariantDTO = productRepository.findProductVariantById(variantId);

        if (productVariantDTO.getStock() < quantity) {
            return false;
        }
        return productRepository.updateStock(handle, variantId, quantity) > 0;
    }

    //  Xử lý đơn hàng
    public void processOrder(Handle handle, int orderId, Cart cart) {
        for (CartItem cartItem : cart.getItems()) {
            int variantId = cartItem.getCartItem().getProductVariant().getId();
            int quantity = cartItem.getQuantity();

            // Kiểm tra và cập nhật stock ngay lập tức
            if (!updateStock(handle, variantId, quantity)) {
                throw new IllegalStateException("Sản phẩm ID " + variantId + " không đủ hàng để đặt hàng.");
            }

            OrderItem orderItem = new OrderItem();
            orderItem.setOrderId(orderId);
            orderItem.setVariantId(variantId);
            orderItem.setQuantity(quantity);
            orderItem.setBasePrice(cartItem.getCartItem().getBasePrice());
            orderItem.setFinalPrice(cartItem.getCartItem().getLowestSalePrice());
            orderItem.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            orderItemRepository.save(handle, orderItem);
        }
    }

    //  Đặt hàng với COD (Kiểm tra stock & rollback nếu thiếu hàng)
    public Map<String, Object> orderWithCod(int userId, double totalAmount, int userAddressId, Cart cart) {
        return jdbi.inTransaction(handle -> {
            Map<String, Object> response = new HashMap<>();
            try {
                Order order = createOrder(handle, userId, totalAmount, userAddressId);
                processOrder(handle, order.getId(), cart);
                paymentService.paymentOrderWithCod(handle, order.getId());

                response.put("success", true);
                response.put("orderId", order.getId());
            } catch (IllegalStateException e) {
                handle.rollback();
                response.put("success", false);
                response.put("message", e.getMessage());
            } catch (Exception e) {
                response.put("success", false);
                response.put("message", "Không thể tạo đơn hàng. Vui lòng thử lại sau.");
                throw e;
            }
            return response;
        });
    }

    //  Đặt hàng với VNPay (Kiểm tra stock & rollback nếu thiếu hàng)
    public Map<String, Object> orderWithVNPay(int userId, double totalAmount, int userAddressId, Cart cart) {
        return jdbi.inTransaction(handle -> {
            Map<String, Object> response = new HashMap<>();
            try {
                Order order = createOrder(handle, userId, totalAmount, userAddressId);
                processOrder(handle, order.getId(), cart);
                paymentService.paymentOrderWithVNPay(handle, order.getId(), totalAmount);

                response.put("success", true);
                response.put("orderId", order.getId());
            } catch (IllegalStateException e) {
                handle.rollback();
                response.put("success", false);
                response.put("message", e.getMessage());
            } catch (Exception e) {
                response.put("success", false);
                response.put("message", "Không thể tạo đơn hàng. Vui lòng thử lại sau.");
                throw e;
            }
            return response;
        });
    }

    //  Lịch sử đặt hàng của khách hàng
    public List<OrderHistoryDTO> orderHistoryList(int userId) {
        return orderRepository.orderHistoryUserList(userId);
    }
    //  Lịch sử đặt hàng
    public List<OrderHistoryDTO> orderHistoryList() {
        return orderRepository.orderHistoryList();
    }

    public OrderHistoryDTO getOrderHistory(int orderId) {
        return orderRepository.getOrderHistoryById(orderId);
    }


    // Xóa đơn hàng
    public boolean deleteOrderById(int orderId) {
        return jdbi.inTransaction(handle -> {
            try {
                List<OrderItem> orderItems = orderItemRepository.findByOrderId(handle, orderId);

                paymentService.deletePayment(handle, orderId);
                orderItemRepository.deleteByOrderId(handle, orderId);
                boolean deleted = orderRepository.deleteOrder(handle, orderId);


                for (OrderItem item : orderItems) {
                    productRepository.updateStock(handle, item.getVariantId(), -item.getQuantity());
                }

                if (!deleted) {
                    handle.rollback();
                    return false;
                }
                return true;
            } catch (Exception e) {
                handle.rollback();
                throw new RuntimeException("Lỗi khi xóa đơn hàng: " + e.getMessage());
            }
        });
    }

    public Map<String, String> updateQuantityFromDashboard(int orderItemId, int quantity) {
        Map<String, String> response = new HashMap<>();
        ProductVariantDTO productVariantDTO = productRepository.getStockByOrderItemId(orderItemId);
        if (productVariantDTO == null) {
            response.put("status", "error");
            response.put("message", "Không tìm thấy sản phẩm tương ứng với đơn hàng.");
            return response;
        }

        if (productVariantDTO.getStock() <= 0) {
            response.put("status", "error");
            response.put("message", "Sản phẩm đã hết hàng.");
            return response;
        }

        if (productVariantDTO.getStock() < quantity) {
            response.put("status", "error");
            response.put("message", "Số lượng tồn kho không đủ.Chỉ còn "+ productVariantDTO.getStock()+" sản phẩm ");
            return response;
        }

        jdbi.useTransaction(handle -> {
            // cập nhật lại stock
            productRepository.updateStock(handle, productVariantDTO.getId(), productVariantDTO.getStock() - quantity);
            // cập nhật quantity trong orderItem
            orderItemRepository.updateQuantity(handle, orderItemId, quantity);
        });



        response.put("status", "success");
        response.put("message", "Cập nhật số lượng thành công.");
        return response;
    }


    public Map<String, String> removeOrderItem(int orderItemId) {

        boolean isSuccess = orderItemRepository.removerOrderItem(orderItemId);

        Map<String, String> result = new HashMap<>();
        if (isSuccess) {
            result.put("status", "success");
            result.put("message", "Xóa sản phẩm khỏi đơn hàng thành công.");
        } else {
            result.put("status", "error");
            result.put("message", "Có lỗi xảy ra.");
        }

        return result;
    }

    public void updateTotalAmount(int orderId, double totalAmount) {
        orderRepository.updateTotalAmount(orderId,totalAmount);
    }

    public Map<String, String> modifyStatusOrder(int orderId, int statusId) {
        boolean isSuccess = orderItemRepository.modifyStatusOrder(orderId, statusId);

        Map<String, String> result = new HashMap<>();
        if (isSuccess) {
            result.put("status", "success");
            result.put("message", "Cập nhật trạng thái đơn hàng thành công.");
        } else {
            result.put("status", "error");
            result.put("message", "Có lỗi xảy ra khi cập nhật trạng thái đơn hàng.");
        }

        return result;
    }

    public Map<String, String> removerOrder(int orderId) {
        boolean isSuccess = orderItemRepository.removerOrder(orderId);

        Map<String, String> result = new HashMap<>();
        if (isSuccess) {
            result.put("status", "success");
            result.put("message", "Đơn hàng đã được xóa thành công.");
        } else {
            result.put("status", "error");
            result.put("message", "Có lỗi xảy ra khi xóa đơn hàng.");
        }

        return result;
    }
}
