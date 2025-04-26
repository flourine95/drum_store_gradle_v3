package com.drumstore.web.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OrderHistoryDTO {
    private int orderId;
    private LocalDateTime orderDate; // Ngày đặt hàng
    private double totalAmount; // Tổng tiền
    private int orderStatus; // Trạng thái đơn hàng (dạng số: 0, 1, 2, 3, 4)
    private String orderStatusText; // Trạng thái đơn hàng (dạng văn bản: PENDING, CONFIRMED, SHIPPING, DELIVERED, CANCELLED)
    private String paymentMethodText; // Phương thức thanh toán (COD, VNPAY)
    private String paymentStatusText; // Trạng thái thanh toán (PENDING, COMPLETED, FAILED)
    private String transactionId; // Mã giao dịch (có thể null với COD)
    private int userAddressId; // ID địa chỉ giao hàng (dùng cho thanh toán VNPay)
    private List<OrderItemDTO> items; // Danh sách sản phẩm trong đơn hàng
    private AddressDTO shippingAddress;

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public int getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(int orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getOrderStatusText() {
        return orderStatusText;
    }

    public void setOrderStatusText(String orderStatusText) {
        this.orderStatusText = orderStatusText;
    }

    public String getPaymentMethodText() {
        return paymentMethodText;
    }

    public void setPaymentMethodText(String paymentMethodText) {
        this.paymentMethodText = paymentMethodText;
    }

    public String getPaymentStatusText() {
        return paymentStatusText;
    }

    public void setPaymentStatusText(String paymentStatusText) {
        this.paymentStatusText = paymentStatusText;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public int getUserAddressId() {
        return userAddressId;
    }

    public void setUserAddressId(int userAddressId) {
        this.userAddressId = userAddressId;
    }

    public List<OrderItemDTO> getItems() {
        return items;
    }

    public void setItems(List<OrderItemDTO> items) {
        this.items = items;
    }

    public AddressDTO getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(AddressDTO shippingAddress) {
        this.shippingAddress = shippingAddress;
    }
}