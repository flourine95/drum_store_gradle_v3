<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

    <style>
        .orders-card {
            background: var(--text-white);
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            border-radius: 15px;
            overflow: hidden;
        }

        .order-item {
            border-bottom: 1px solid #eee;
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }

        .order-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .order-item:hover {
            background-color: rgba(253, 0, 0, 0.02);
        }

        .order-header {
            padding-bottom: 15px;
            border-bottom: 1px dashed #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .badge-pending {
            background-color: #ffd700;
            color: var(--hover-color);
        }

        .badge-confirmed {
            background-color: #17a2b8;
            color: var(--text-white);
        }

        .badge-shipping {
            background-color: #007bff;
            color: var(--text-white);
        }

        .badge-delivered {
            background-color: #28a745;
            color: var(--text-white);
        }

        .badge-cancelled {
            background-color: var(--bs-secondary);
            color: var(--text-white);
        }

        .payment-badge {
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .payment-pending {
            background-color: #ffd700;
            color: var(--hover-color);
        }

        .payment-completed {
            background-color: #28a745;
            color: var(--text-white);
        }

        .payment-failed {
            background-color: #dc3545;
            color: var(--text-white);
        }

        .product-img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            border-radius: 8px;
            transition: transform 0.3s ease;
        }

        .product-img:hover {
            transform: scale(1.05);
        }

        .btn-order {
            padding: 8px 20px;
            border-radius: 25px;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
        }

        .btn-cancel {
            background-color: #dc3545;
            color: var(--text-white);
        }

        .btn-cancel:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            background-color: #c82333;
            color: var(--text-white);
        }

        .btn-pay {
            background-color: #28a745;
            color: var(--text-white);
        }

        .btn-pay:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            background-color: #218838;
            color: var(--text-white);
        }

        .order-content {
            margin-top: 15px;
        }

        .product-list {
            margin-bottom: 20px;
        }

        .product-item {
            padding: 10px 0;
            border-bottom: 1px solid #f5f5f5;
            transition: all 0.3s ease;
        }

        .product-item:last-child {
            border-bottom: none;
        }

        .product-item:hover {
            background-color: #f9f9f9;
        }

        .order-footer {
            padding-top: 15px;
            border-top: 1px dashed #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-footer .order-info {
            flex: 1;
        }

        .order-footer .btn-actions {
            display: flex;
            gap: 10px;
        }

        .price-base {
            color: #6c757d;
            font-size: 0.9rem;
            text-decoration: line-through;
        }

        .price-final {
            color: #dc3545;
            font-size: 1.1rem;
            font-weight: bold;
        }
    </style>
<div class="col-md-9">
    <div class="orders-card animate__animated animate__fadeInRight">
        <div class="card-header p-4">
            <h5 class="mb-0">
                <i class="bi bi-bag-check me-2"></i>
                QUẢN LÝ ĐƠN HÀNG
            </h5>
        </div>

        <div class="card-body p-0">
            <c:if test="${empty orderHistory}">
                <div class="order-item">
                    <p class="text-muted text-center">Bạn chưa có đơn hàng nào.</p>
                </div>
            </c:if>

            <c:forEach var="order" items="${orderHistory}" varStatus="loop">
                <div class="order-item" data-order-id = ${order.orderId}>
                    <div class="order-header">
                        <div>
                            <span class="text-muted me-3">Mã đơn: #${order.orderId}</span>
                            <span class="text-muted">Ngày đặt: ${order.orderDate}</span>
                        </div>
                        <span class="order-badge badge-${order.orderStatusText.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${order.orderStatusText == 'PENDING'}">Đang xử lý</c:when>
                                    <c:when test="${order.orderStatusText == 'CONFIRMED'}">Đã xác nhận</c:when>
                                    <c:when test="${order.orderStatusText == 'SHIPPING'}">Đang giao</c:when>
                                    <c:when test="${order.orderStatusText == 'DELIVERED'}">Đã giao</c:when>
                                    <c:when test="${order.orderStatusText == 'CANCELLED'}">Đã hủy</c:when>
                                    <c:otherwise>Không xác định</c:otherwise>
                                </c:choose>
                            </span>
                    </div>

                    <div class="order-content">
                        <!-- Danh sách sản phẩm -->
                        <div class="product-list">
                            <c:forEach var="item" items="${order.items}">
                                <div class="product-item">
                                    <div class="row align-items-center">
                                        <div class="col-md-2">
                                            <img src="/assets/images/products/${item.imageUrl}" alt="Product" class="product-img w-100">
                                        </div>
                                        <div class="col-md-4">
                                            <h6 class="mb-1 fw-bold">${item.name}</h6>
                                            <p class="text-muted mb-0">Số lượng: ${item.quantity}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <p class="mb-0"><strong>Giá gốc:</strong> <span class="price-base"><fmt:formatNumber value="${item.basePrice}" type="currency" currencySymbol="đ"/></span></p>
                                            <p class="mb-0"><strong>Giá bán:</strong> <span class="price-final"><fmt:formatNumber value="${item.finalPrice}" type="currency" currencySymbol="đ"/></span></p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- Thông tin tổng quan và nút hành động -->
                        <div class="order-footer">
                            <div class="order-info">
                                <p class="mb-0"><strong>Tổng tiền:</strong><span class="price-final"> <fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="đ"/></span></p>
                                <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethodText}</p>
                                <p><strong>Trạng thái thanh toán:</strong>
                                    <span class="payment-badge payment-${order.paymentStatusText.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${order.paymentStatusText == 'PENDING'}">Đang chờ</c:when>
                                                <c:when test="${order.paymentStatusText == 'COMPLETED'}">Đã thanh toán</c:when>
                                                <c:when test="${order.paymentStatusText == 'FAILED'}">Thất bại</c:when>
                                                <c:otherwise>Không xác định</c:otherwise>
                                            </c:choose>
                                        </span>
                                </p>
                                <c:if test="${not empty order.transactionId}">
                                    <p><strong>Mã giao dịch:</strong> ${order.transactionId}</p>
                                </c:if>
                                <p><strong>Địa chỉ giao hàng:</strong> ${order.shippingAddress.address}</p>
                            </div>
                            <div class="btn-actions">
                                <c:if test="${order.orderStatus == 0}">
                                    <button class="btn btn-order btn-cancel cancel-order" data-order-id="${order.orderId}">
                                        <i class="bi bi-x-circle me-2"></i>Hủy đơn
                                    </button>
                                </c:if>
                                <c:if test="${order.paymentMethodText == 'BANK_TRANSFER' && order.paymentStatusText == 'PENDING'}">
                                    <button class="btn btn-order btn-pay pay-order" data-order-id="${order.orderId}" data-amount="${order.totalAmount}" data-address-id="${order.userAddressId}">
                                        <i class="bi bi-credit-card me-2"></i>Thanh toán
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>


<script>
    $(document).ready(function () {
        // Xử lý hủy đơn hàng
        $('.cancel-order').click(function () {
            const orderId = $(this).data('order-id');
            Swal.fire({
                title: 'Bạn có chắc chắn muốn hủy đơn hàng này?',
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Hủy đơn hàng',
                cancelButtonText: 'Không'
            }).then((result) => {
                if (result.isConfirmed) {
                    $.ajax({
                        url: '/profile',
                        method: 'POST',
                        contentType: 'application/json',
                        data: JSON.stringify({
                            action: 'cancle_order',
                            orderId: orderId
                        }),
                        success: function (response) {
                            const Toast = Swal.mixin({
                                toast: true,
                                position: 'top-end',
                                showConfirmButton: false,
                                timer: 3000,
                                timerProgressBar: true,
                                didOpen: (toast) => {
                                    toast.addEventListener('mouseenter', Swal.stopTimer);
                                    toast.addEventListener('mouseleave', Swal.resumeTimer);
                                }
                            })
                            if (response.success) {
                                Toast.fire({
                                    icon: 'success',
                                    title: response.message || 'Đã hủy đơn hàng của bạn !'
                                });

                                const $orderItemItem = $('.order-item[data-order-id=' + orderId + ']');
                                $orderItemItem.addClass('animate__animated animate__fadeOutRight');
                                setTimeout(() => {
                                    $orderItemItem.remove();
                                }, 500);

                            } else {
                                Toast.fire({
                                    icon: 'error',
                                    title: response.message || 'Lỗi hủy đơn hàng bạn!'
                                });
                            }
                        },
                        error: function () {
                            Swal.fire({
                                title: 'Có lỗi xảy ra!',
                                icon: 'error',
                                draggable: true
                            });
                        }
                    });
                }
            });
        });

        // Xử lý thanh toán VNPay
        $(document).ready(function () {
            $('.pay-order').click(function () {
                const orderId = $(this).data('order-id');
                const totalAmount = $(this).data('amount');
                $.ajax({
                    url: '/payment',
                    type: 'POST',
                    data: {
                        orderId: orderId,
                        amount: totalAmount
                    },
                    success: function (response) {
                        if (response.success && response.paymentUrl) {
                            window.location.href = response.paymentUrl;
                        } else {
                            Swal.fire({
                                title: 'Lỗi thanh toán!',
                                text: response.message || 'Không thể tạo thanh toán VNPay.',
                                icon: 'error',
                                confirmButtonText: 'OK'
                            });
                        }
                    },
                    error: function (xhr, status, error) {
                        Swal.close(); // Đóng hiệu ứng loading
                        Swal.fire({
                            title: 'Lỗi kết nối!',
                            text: `Lỗi: ${xhr.responseText || error}`,
                            icon: 'error',
                            confirmButtonText: 'OK'
                        });
                    }
                });
            });
        });

    });
</script>
