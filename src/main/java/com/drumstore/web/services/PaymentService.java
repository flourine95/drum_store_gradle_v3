package com.drumstore.web.services;

import com.drumstore.web.constants.PaymentConstants;
import com.drumstore.web.models.Payment;
import com.drumstore.web.repositories.PaymentRepository;
import org.jdbi.v3.core.Handle;

import java.sql.Timestamp;

public class PaymentService {
    private final PaymentRepository paymentRepository = new PaymentRepository();

    public void updatePayment(int orderId , String transactionId) {
        paymentRepository.updatePayment(orderId,transactionId);
    }

    //  Thanh toán VNPay
    public void paymentOrderWithVNPay(Handle handle, int orderId , double totalAmount) {
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setPaymentMethod(PaymentConstants.Method.BANK_TRANSFER.getValue());
        payment.setStatus(PaymentConstants.Status.PENDING.getValue());
        payment.setAmount(totalAmount);
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
        payment.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        paymentRepository.save(handle, payment);
    }

    //  Thanh toán COD
    public void paymentOrderWithCod(Handle handle, int orderId) {
        Payment payment = new Payment();
        payment.setOrderId(orderId);
        payment.setPaymentMethod(PaymentConstants.Method.COD.getValue());
        payment.setStatus(PaymentConstants.Status.PENDING.getValue());
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
        payment.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        paymentRepository.save(handle, payment);
    }

    // xóa thanh toán khi người dùng hủy đơn hàng
    public void deletePayment(Handle handle, int orderId) {
        Payment payment = paymentRepository.getPaymentByOrderId(orderId);
        paymentRepository.deletePayment(handle,payment.getId());
    }

}
