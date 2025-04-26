<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

    <style>
        .order-details-container {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-bottom: 30px;
        }
        .order-details-container h4 {
            color: #1a73e8;
            font-weight: 600;
            margin-bottom: 25px;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 10px;
        }
        .order-info, .address-info {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
        }
        .order-info h5, .address-info h5 {
            color: #343a40;
            font-size: 1.25rem;
            font-weight: 500;
            margin-bottom: 15px;
        }
        .order-info p, .address-info p {
            margin: 8px 0;
            font-size: 1rem;
            color: #495057;
        }
        .status-pending { color: #f39c12; font-weight: bold; }
        .status-confirmed { color: #28a745; font-weight: bold; }
        .status-shipping { color: #17a2b8; font-weight: bold; }
        .status-delivered { color: #28a745; font-weight: bold; }
        .status-cancelled { color: #dc3545; font-weight: bold; }
        .payment-pending { color: #f39c12; font-weight: bold; }
        .payment-completed { color: #28a745; font-weight: bold; }
        .payment-failed { color: #dc3545; font-weight: bold; }
        .table th {
            background-color: #e9ecef;
            color: #343a40;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            padding: 12px;
        }
        .table td {
            vertical-align: middle;
            padding: 12px;
            font-size: 0.95rem;
            color: #495057;
        }
        .product-image {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 5px;
            border: 1px solid #dee2e6;
        }
        .btn-sm {
            padding: 6px 12px;
            font-size: 0.9rem;
            border-radius: 5px;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background-color: #1a73e8;
            border-color: #1a73e8;
        }
        .btn-primary:hover {
            background-color: #1557b0;
            border-color: #1557b0;
        }
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .btn-danger:hover {
            background-color: #b02a37;
            border-color: #b02a37;
        }
        .modal-dialog-centered {
            display: flex;
            align-items: center;
            min-height: calc(100% - 1rem);
        }
        .modal-content {
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
            border: none;
            animation: fadeIn 0.3s ease-in-out;
        }
        .modal-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
            padding: 20px;
        }
        .modal-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: #1a73e8;
            display: flex;
            align-items: center;
        }
        .modal-body {
            padding: 25px;
        }
        .form-control {
            border-radius: 6px;
            border: 1px solid #ced4da;
            padding: 10px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }
        .form-control:focus {
            border-color: #1a73e8;
            box-shadow: 0 0 0 0.2rem rgba(26, 115, 232, 0.25);
        }
        .modal-footer {
            border-top: 1px solid #dee2e6;
            padding: 15px 20px;
            background-color: #f8f9fa;
        }
        .btn-outline-secondary {
            border-color: #6c757d;
            color: #6c757d;
            padding: 8px 20px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .btn-outline-secondary:hover {
            background-color: #6c757d;
            color: #fff;
        }
        .btn-primary {
            background-color: #1a73e8;
            border-color: #1a73e8;
            padding: 8px 20px;
            border-radius: 6px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            background-color: #1557b0;
            border-color: #1557b0;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        @media (max-width: 576px) {
            .modal-dialog {
                margin: 0.5rem;
            }
            .modal-content {
                padding: 10px;
            }
            .modal-header, .modal-body, .modal-footer {
                padding: 15px;
            }
            .modal-title {
                font-size: 1.1rem;
            }
            .btn-outline-secondary, .btn-primary {
                padding: 6px 15px;
                font-size: 0.9rem;
            }
        }
        /* Thông báo trong modal */
        .alert {
            margin-bottom: 0;
            font-size: 0.9rem;
        }
    </style>

<div class="container">
    <div class="order-details-container">
        <h4>Chi tiết đơn hàng #${order.orderId}</h4>

        <!-- Thông tin đơn hàng -->
        <div class="order-info">
            <h5>Thông tin đơn hàng</h5>
            <p><strong>Ngày đặt hàng:</strong> ${order.orderDate}</p>
            <p><strong>Tổng tiền:</strong>
                <span id="order-total"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol=" đ"/></span>
            </p>
            <p><strong>Trạng thái:</strong>
                <span class="status-${order.orderStatusText.toLowerCase()}">${order.orderStatusText}</span>
            </p>
            <p><strong>Phương thức thanh toán:</strong> ${order.paymentMethodText}</p>
            <p><strong>Trạng thái thanh toán:</strong>
                <span class="payment-${order.paymentStatusText.toLowerCase()}">${order.paymentStatusText}</span>
            </p>
            <c:if test="${not empty order.transactionId}">
                <p><strong>Mã giao dịch:</strong> ${order.transactionId}</p>
            </c:if>
        </div>

        <!-- Địa chỉ giao hàng -->
        <div class="address-info">
            <h5>Địa chỉ giao hàng</h5>
            <c:if test="${not empty order.shippingAddress}">
                <p><strong>Tên người nhận:</strong> ${order.shippingAddress.fullname}</p>
                <p><strong>Số điện thoại:</strong> ${order.shippingAddress.phone}</p>
                <p><strong>Địa chỉ:</strong> ${order.shippingAddress.address}</p>
            </c:if>
            <c:if test="${empty order.shippingAddress}">
                <p>Chưa có thông tin địa chỉ giao hàng.</p>
            </c:if>
        </div>

        <!-- Danh sách sản phẩm -->
        <h5>Danh sách sản phẩm</h5>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>#</th>
                <th>Hình ảnh</th>
                <th>Tên sản phẩm</th>
                <th>Số lượng</th>
                <th>Giá gốc</th>
                <th>Giá cuối cùng</th>
                <th>Thành tiền</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="item" items="${order.items}" varStatus="loop">
                <tr data-variant-id="${item.id}">
                    <td>${loop.count}</td>
                    <td>
                        <c:if test="${not empty item.imageUrl}">
                            <img src="${pageContext.request.contextPath}/assets/images/products/${item.imageUrl}" alt="${item.name}" class="product-image">
                        </c:if>
                        <c:if test="${empty item.imageUrl}">
                            <span>Không có hình ảnh</span>
                        </c:if>
                    </td>
                    <td>${item.name}</td>
                    <td class="quantity">${item.quantity}</td>
                    <td><fmt:formatNumber value="${item.basePrice}" type="currency" currencySymbol=" đ"/></td>
                    <td><fmt:formatNumber value="${item.finalPrice}" type="currency" currencySymbol=" đ"/></td>
                    <td class="total-price"><fmt:formatNumber value="${item.quantity * item.finalPrice}" type="currency" currencySymbol=" đ"/></td>
                    <td>
                        <!-- Nút chỉnh sửa số lượng -->
                        <button type="button" class="btn btn-primary btn-sm me-2" data-bs-toggle="modal" data-bs-target="#editQuantityModal-${item.variantId}">
                            <i class="fas fa-edit"></i> Sửa
                        </button>
                        <!-- Nút xóa sản phẩm -->
                        <button type="button" class="btn btn-danger btn-sm" onclick="deleteOrderItem(${item.id}, ${order.orderId}, this)">
                            <i class="fas fa-trash"></i> Xóa
                        </button>
                    </td>
                </tr>

                <!-- Modal chỉnh sửa số lượng -->
                <div class="modal fade" id="editQuantityModal-${item.id}" tabindex="-1" aria-labelledby="editQuantityModalLabel-${item.variantId}" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="editQuantityModalLabel-${item.variantId}">
                                    <i class="fas fa-edit me-2"></i>Chỉnh sửa số lượng - ${item.name}
                                </h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <label for="quantity-${item.id}" class="form-label">Số lượng:</label>
                                    <input type="number" class="form-control" id="quantity-${item.id}" name="quantity" value="${item.quantity}" min="1" required>
                                    <input type="hidden" id="variantId-${item.id}" value="${item.variantId}">
                                    <input type="hidden" id="orderId-${item.id}" value="${order.orderId}">
                                    <input type="hidden" id="finalPrice-${item.id}" value="${item.finalPrice}">
                                </div>
                                <div id="message-${item.variantId}" class="mt-2"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="button" class="btn btn-primary" onclick="updateQuantity( ${item.id}, ${order.orderId})">Lưu</button>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<script>
    function updateQuantity(orderItemId , orderId) {
        const quantity = parseInt(document.getElementById('quantity-' + orderItemId).value);
        const finalPrice = parseFloat(document.getElementById('finalPrice-' + orderItemId).value);

        if (quantity < 1) {
            Swal.fire({
                icon: 'warning',
                title: 'Lỗi',
                text: 'Số lượng phải lớn hơn hoặc bằng 1.'
            });
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/dashboard/orders',
            type: 'POST',
            data: {
                action: 'update-quantity',
                orderItemId: orderItemId,
                quantity: quantity,
                orderId: orderId
            },
            success: function(response) {
                if (response.status === 'success') {
                    const row = $('tr[data-variant-id="' + orderItemId + '"]');
                    row.find('.quantity').text(quantity);
                    const newTotalPrice = (quantity * finalPrice).toLocaleString('vi-VN', { style: 'currency', currency: 'VND' });
                    row.find('.total-price').text(newTotalPrice);

                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công',
                        text: response.message,
                        timer: 1500,
                        showConfirmButton: false
                    });

                    // Cập nhật lại tổng tiền
                    if (response.total) {
                        const formattedTotal = new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(response.total);

                        $('#order-total').text(formattedTotal);
                    }

                    setTimeout(function () {
                        $('#editQuantityModal-' + orderItemId).modal('hide');
                    }, 1000);
                } else {
                    Swal.fire({
                        icon: 'error',
                        title: 'Thất bại',
                        text: response.message
                    });
                }
            },
            error: function(xhr) {
                const errorMessage = xhr.responseJSON && xhr.responseJSON.message
                    ? xhr.responseJSON.message
                    : 'Đã xảy ra lỗi khi cập nhật số lượng.';

                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: errorMessage
                });
            }
        });
    }

    function deleteOrderItem(orderItemId, orderId, buttonElement) {
        Swal.fire({
            title: 'Bạn có chắc muốn xóa?',
            text: "Sản phẩm sẽ bị xóa khỏi đơn hàng!",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonText: 'Vâng, xóa!',
            cancelButtonText: 'Hủy bỏ'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: `${pageContext.request.contextPath}/dashboard/orders`,
                    method: 'POST',
                    data: {
                        action: "remove-orderItem",
                        orderItemId: orderItemId,
                        orderId: orderId
                    },
                    success: function (response) {
                        Swal.fire('Đã xóa!', response.message, 'success');
                        $(buttonElement).closest('tr').remove();

                        // Cập nhật lại tổng tiền
                        if (response.total) {
                            const formattedTotal = new Intl.NumberFormat('vi-VN', {
                                style: 'currency',
                                currency: 'VND'
                            }).format(response.total);

                            $('#order-total').text(formattedTotal);
                        }
                    },
                    error: function (xhr) {
                        const message = xhr.responseJSON?.message || 'Không thể xóa sản phẩm.';
                        Swal.fire('Lỗi!', message, 'error');
                    }
                });
            }
        });
    }

</script>
