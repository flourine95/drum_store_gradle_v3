<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<style>
    body {
        background-color: #f8f9fa;
    }

    .order-container h5 {
        font-weight: bold;
        background-color: #F1F1F1;
    }

    .product-detail img {
        position: absolute;
        object-fit: cover;
        width: 30%;
        height: 100%;
    }

    .option button {
        width: 120px;
        height: 40px;
        margin-top: 10px;
        border: 1px solid #ddd;
    }


    @media (max-width: 768px) {
        .product-detail img {
            position: absolute;
            object-fit: cover;
            width: 30%;
            height: 100%;
        }

        .option button {
            width: 80px;
            height: 30px;
            border: 1px solid #ddd;
        }

    }

    .voucher-input input {
        width: 80%;
        height: 40px;
        margin-left: 0;
        border: none;
        border-radius: 0;
    }

    .voucher-input button {
        margin-left: 1px;
        width: 100px;
        height: 40px;
        background-color: #fd0;
        font-weight: bold;
        border: none;
    }

    .cart-item {
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 15px;
    }

    .color-options select {
        min-width: 100px;
    }

    .form-select-sm {
        padding: 0.25rem 2rem 0.25rem 0.5rem;
        font-size: 0.875rem;
    }

    .cart-item {
        transition: all 0.3s ease;
    }

    .cart-item:hover {
        background-color: #f8f9fa;
    }

    .cart-item img {
        transition: transform 0.3s ease;
    }

    .cart-item:hover img {
        transform: scale(1.05);
    }

    .cart-item a:hover h5 {
        color: #0d6efd !important;
    }

    .cart-item img {
        border-radius: 8px;
        object-fit: cover;
        height: 100px;
    }

    .cart-item .item-total {
        color: var(--price-sale);
        font-size: 1rem;
        font-weight: 700;
        margin: 0;
    }

    .dropdown-toggle {
        background: transparent;
        border: transparent;
        padding: 0;
    }

    .dropdown-menu {
        width: 30rem;
    }

    .btn.variant-button.active {
        background-color: transparent;
        color: black;
        border-color: var(--bs-primary);
    }

    .reset, .confirm {
        font-size: 1rem;
        padding: 6px 15px;
    }

    .btn.confirm {
        background-color: var(--bs-primary);
    }

    .btn.confirm:hover {
        background-color: var(--rating-star);
    }

    .order-summary {
        border: 1px solid #dee2e6;
        border-radius: 5px;
        background-color: #f8f9fa;
    }

    .promo-code {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .promo-code input {
        height: 35px;
        font-size: 14px;
        width: 73%;
    }

    .promo-code .btn {
        color: white;
        border: none;
        height: 35px;
        text-transform: uppercase;
        /*font-weight: bold;*/
    }


    .order-details p {
        margin-bottom: 0.5rem;
    }

    .order-details .total {
        font-weight: bold;
        font-size: 1rem;
    }

    .order-details hr {
        border: none;
        border-top: 2px dashed #555;

    }

    .checkout-btn {
        border: none;
        text-transform: uppercase;
        font-weight: bold;
    }
</style>

<div class="container my-5" style="min-height: 70vh">
    <div class="row">
        <div class="col-12">
            <h5 class="mb-4">GIỎ HÀNG</h5>
            <div class="cart-container">
                <c:choose>
                    <c:when test="${empty cart.items}">
                        <div class="text-center py-5">
                            <h3>Giỏ hàng trống</h3>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary mt-3">
                                Tiếp tục mua sắm
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="row">
                            <div class="col-md-8">
                                <c:forEach items="${cart.items}" var="item">
                                    <div class="cart-item" data-cart-id="${item.cartId}">
                                        <div class="row align-items-center">
                                            <div class="col-2">
                                                <img src="${pageContext.request.contextPath}/assets/images/products/${item.cartItem.mainImage}"
                                                     class="img-fluid cart-item-image" alt="${item.cartItem.name}">
                                            </div>
                                            <div class="col">
                                                <a href="${pageContext.request.contextPath}/product/${item.cartItem.productId}"
                                                   class="text-decoration-none">
                                                    <h5 class="text-dark">${item.cartItem.name}</h5>
                                                </a>
                                                <div class="color-options mb-2 d-flex flex-row">
                                                    <label class="me-2 classification-label">
                                                        <c:if test="${not empty item.cartItem and not empty item.cartItem.productVariant}">
                                                            Phân loại:
                                                            <c:if test="${not empty item.cartItem.productVariant.color}">
                                                                ${item.cartItem.productVariant.color.name}
                                                            </c:if>
                                                            <c:if test="${not empty item.cartItem.productVariant.color and not empty item.cartItem.productVariant.addon}">
                                                                ,
                                                            </c:if>
                                                            <c:if test="${not empty item.cartItem.productVariant.addon}">
                                                                ${item.cartItem.productVariant.addon.name}
                                                            </c:if>
                                                        </c:if>
                                                    </label>

                                                    <c:if test="${not empty item.cartItem.variants}">
                                                        <div class="dropdown">
                                                            <button class="dropdown-toggle "
                                                                    type="button"
                                                                    id="variantDropdown"
                                                                    data-bs-toggle="dropdown"
                                                                    aria-expanded="false">
                                                            </button>
                                                            <div class="dropdown-menu"
                                                                 aria-labelledby="variantDropdown">
                                                                <!-- Lặp qua tất cả các key trong variants (color, addon) -->
                                                                <c:forEach items="${item.cartItem.variants}"
                                                                           var="variantEntry">
                                                                    <div class="variant-group p-2">
                                                                        <div class="d-flex flex-row gap-2 flex-wrap align-items-center">
                                                                            <span class="variant-type fw-bold">${variantEntry.key == 'color' ? 'Màu sắc' : 'Phụ kiện'}</span>:
                                                                            <c:forEach items="${variantEntry.value}"
                                                                                       var="variant">
                                                                                <button class="btn btn-outline-dark variant-button ${variantEntry.key == 'color' && not empty item.cartItem.productVariant.color && item.cartItem.productVariant.color.id == variant.id ? 'active' : ''}
                                                                                ${variantEntry.key == 'addon' && not empty item.cartItem.productVariant.addon && item.cartItem.productVariant.addon.id == variant.id ? 'active' : ''}"
                                                                                        type="button"
                                                                                        data-type="${variantEntry.key}"
                                                                                        data-id="${variant.id}"
                                                                                        onclick="selectVariant(event, '${variantEntry.key}', ${variant.id}, '${variant.name}', '${item.cartId}')">
                                                                                        ${variant.name}
                                                                                </button>
                                                                            </c:forEach>
                                                                        </div>
                                                                    </div>
                                                                </c:forEach>
                                                                <div class="d-flex flex-row gap-2 justify-content-end p-2 ">
                                                                    <button class="btn btn-outline-secondary reset"
                                                                            id="resetButton"
                                                                            onclick="resetVariants(event, '${item.cartId}')">
                                                                        Trở lại
                                                                    </button>
                                                                    <button class="btn confirm" id="confirmButton"
                                                                            data-cart-id="${item.cartId}"
                                                                            data-product-id="${item.cartItem.productId}"
                                                                            data-color="${not empty item.cartItem.productVariant.color ? item.cartItem.productVariant.color.id : 0}"
                                                                            data-addon="${not empty item.cartItem.productVariant.addon ? item.cartItem.productVariant.addon.id : 0}"
                                                                    >
                                                                        Xác nhận
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <p class="item-price cart-item-price">
                                                    <c:choose>
                                                        <c:when test="${item.cartItem.discountPercent != 0}">
                                                                <span class="text-danger cart-item-sale-price">
                                                                    <fmt:formatNumber
                                                                            value="${item.cartItem.getLowestSalePrice()}"
                                                                            type="currency" currencySymbol="₫"/>
                                                                </span>
                                                            <del class="text-muted ms-2 cart-item-base-price">
                                                                <fmt:formatNumber value="${item.cartItem.basePrice}"
                                                                                  type="currency" currencySymbol="₫"/>
                                                            </del>
                                                            <span class="badge bg-danger ms-2 cart-item-discount">
                                                                    -<fmt:formatNumber
                                                                    value="${item.cartItem.discountPercent}"
                                                                    maxFractionDigits="0"/>%
                                                                </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="cart-item-base-price">
                                                             <fmt:formatNumber value="${item.cartItem.basePrice}"
                                                                               type="currency" currencySymbol="₫"/>
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </p>
                                            </div>
                                            <div class="col-2">
                                                <div class="input-group" style="width: 130px;">
                                                    <button class="btn btn-outline-secondary decrease" type="button"
                                                            aria-label="Giảm số lượng"
                                                            data-cart-id="${item.cartId}">
                                                        <i class="bi bi-dash"></i>
                                                    </button>
                                                    <input type="text" class="form-control text-center"
                                                           id="quantity-${item.cartId}"
                                                           value="${item.quantity}"
                                                           data-cart-quantity-id="${item.cartId}"
                                                           max="${item.cartItem.productVariant.stock}"
                                                           readonly>
                                                    <button class="btn btn-outline-secondary increase" type="button"
                                                            data-cart-id="${item.cartId}"
                                                            aria-label="Tăng số lượng">
                                                        <i class="bi bi-plus"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="col-2 d-flex align-items-center">
                                                <p class="item-total cart-item-total">
                                                    <fmt:formatNumber value="${item.getTotal()}" type="currency"
                                                                      currencySymbol="₫"/>
                                                </p>
                                            </div>
                                            <div class="col-1">
                                                <button class="btn btn-danger btn-sm"
                                                        onclick="removeItem(${item.cartId})">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                            <div class="col-md-4">
                                <div class="order-summary p-3">
                                    <h5 class="text-uppercase fw-bold mb-3">Đơn hàng</h5>
                                    <hr style="border: 1px solid black"/>
                                    <div class="promo-code mb-3 d-flex gap-2">
                                        <input type="text" class="form-control" placeholder="Nhập mã khuyến mãi"
                                               id="promoCodeInput">
                                        <button class="btn btn-primary" id="applyPromoButton">Áp dụng</button>
                                    </div>
                                    <!-- Phần hiển thị mã khuyến mãi -->
                                    <c:choose>
                                        <c:when test="${not empty cart.voucher}">
                                            <div class="applied-promo mb-3" id="appliedPromo" style="display: block;">
                                                <p class="d-flex justify-content-between align-items-center">
                                                    <span>Mã khuyến mãi: <strong
                                                            id="promoCodeName">${cart.voucher.code}</strong></span>
                                                    <button class="btn btn-sm btn-danger" id="removePromoButton"
                                                            data-voucher-id="${cart.voucher.id}">
                                                        <i class="bi bi-trash me-2"></i>Xóa
                                                    </button>
                                                </p>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="applied-promo mb-3" id="appliedPromo" style="display: none;">
                                                <p class="d-flex justify-content-between align-items-center">
                                                    <span>Mã khuyến mãi: <strong id="promoCodeName"></strong></span>
                                                    <button class="btn btn-sm btn-danger" id="removePromoButton"
                                                            data-voucher-id="">
                                                        <i class="bi bi-trash me-2"></i>Xóa
                                                    </button>
                                                </p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Phần hiển thị chi tiết đơn hàng -->
                                    <div class="order-details">
                                        <hr>
                                        <p class="d-flex justify-content-between">
                                            <span>Đơn hàng</span>
                                            <span id="subTotal">
                                                <fmt:formatNumber value="${cart.total}" type="currency"
                                                                  currencySymbol="₫"/>
                                             </span>
                                        </p>
                                        <p class="d-flex justify-content-between">
                                            <span>Giảm</span>
                                            <span id="discount">
                                                        <fmt:formatNumber value="${cart.discountTotal}"
                                                                          type="currency" currencySymbol="₫"/>
                                            </span>
                                        </p>
                                        <hr>
                                        <p class="d-flex justify-content-between total">
                                            <span>Tạm tính</span>
                                            <span class="h5 cart-total" id="total">
                                                <fmt:formatNumber value="${cart.total - cart.discountTotal}"
                                                                  type="currency"
                                                                  currencySymbol="₫"/>
                                            </span>
                                        </p>
                                    </div>
                                    <button class="btn btn-primary checkout-btn w-100 mt-3" id="payment">Tiếp tục thanh
                                        toán
                                    </button>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Overlay loading toàn trang -->
    <div id="loadingOverlay"
         class="d-none position-fixed top-0 start-0 w-100 h-100 bg-dark bg-opacity-50 d-flex justify-content-center align-items-center"
         style="z-index: 9999;">
        <div class="spinner-border text-light" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>
</div>

<c:if test="${vnp_TransactionStatus == true}">
    <div class="modal fade" id="paymentSuccessModal" tabindex="-1" aria-labelledby="paymentSuccessModalLabel"
         aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="paymentSuccessModalLabel">Thanh toán thành công</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Cảm ơn bạn đã mua sắm! Đơn hàng của bạn (ID: ${orderId}) đã được thanh toán thành công.</p>
                    <p>Mã giao dịch: ${transactionId}</p>
                </div>
                <div class="modal-footer">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Tiếp tục mua sắm</a>
                    <a href="${pageContext.request.contextPath}/profile?action=orders" class="btn btn-secondary">Xem
                        lịch sử đơn hàng</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Script để hiển thị modal khi trang được tải -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var paymentSuccessModal = new bootstrap.Modal(document.getElementById('paymentSuccessModal'));
            paymentSuccessModal.show();
        });
    </script>
</c:if>


<script>

    // Xử lý nút giảm số lượng
    $('.decrease').click(function (event) {
        event.stopPropagation();

        const cartId = $(this).data('cart-id');
        const quantityInput = $("#quantity-" + cartId);
        let currentQty = parseInt(quantityInput.val());
        quantityInput.val(currentQty - 1);
        updateQuantity(cartId, currentQty - 1);
    });

    // Xử lý nút tăng số lượng
    $('.increase').click(function (event) {
        event.stopPropagation();

        const cartId = $(this).data('cart-id');
        const quantityInput = $("#quantity-" + cartId);
        let currentQty = parseInt(quantityInput.val());
        const maxQty = parseInt(quantityInput.attr('max'));

        if (isNaN(currentQty)) {
            currentQty = 1;
            quantityInput.val(currentQty);
        }

        if (currentQty >= maxQty) {
            quantityInput.val(maxQty);
            quantityInput.focus();
            Swal.fire({
                title: `Số lượng không thể vượt quá ${maxQty}!`,
                icon: "warning",
                draggable: true
            });
            return;
        }

        const newQty = currentQty + 1;
        quantityInput.val(newQty);
        updateQuantity(cartId, newQty);
    });

    document.addEventListener('DOMContentLoaded', function () {
        const confirmButtons = document.querySelectorAll('#confirmButton');
        confirmButtons.forEach(button => {
            button.addEventListener('click', function (event) {
                event.stopPropagation();
                const cartId = this.dataset.cartId;
                const productId = this.dataset.productId;
                changeVariants(cartId, productId);
            });
        });
    })

    function resetVariants(event, cartId) {
        event.stopPropagation();
        const variantButtons = document.querySelectorAll('.variant-button');
        variantButtons.forEach(button => {
            button.classList.remove('active');
        });
        // Xóa các data-attribute trong nút "Xác nhận"
        const confirmButton = document.querySelector('#confirmButton[data-cart-id="' + cartId + '"]');
        if (confirmButton) {
            delete confirmButton.dataset.color;
            delete confirmButton.dataset.addon;
            delete confirmButton.dataset.colorName;
            delete confirmButton.dataset.addonName;
        }
    }

    function selectVariant(event, type, id, name, cartId) {
        event.stopPropagation();
        const buttons = document.querySelectorAll('.variant-button[data-type="' + type + '"]');
        buttons.forEach(button => {
            button.classList.remove('active');
            if (button.dataset.id == id) {
                button.classList.add('active');
            }
        });

        const confirmButton = document.querySelector('#confirmButton[data-cart-id="' + cartId + '"]');
        if (confirmButton) {
            confirmButton.dataset[type] = id;
            confirmButton.dataset[type + 'Name'] = name;
        }
    }


    function updateQuantity(cartId, newQuantity) {
        if (newQuantity === 0) return removeItem(cartId);

        $.ajax({
            url: "/cart",
            method: "POST",
            data: {
                action: "update",
                cartId: cartId,
                quantity: newQuantity
            },
            success: function (response) {
                const element = document.querySelector('.cart-item[data-cart-id="' + cartId + '"]');
                const inputGroup = element.querySelector('.input-group');
                const decreaseButton = inputGroup.querySelector('.decrease');
                const increaseButton = inputGroup.querySelector('.increase');
                const priceItem = response.price;
                const total = response.total;

                // Cập nhật số lượng
                const quantityInput = document.querySelector('input[data-cart-quantity-id="' + cartId + '"]');
                quantityInput.value = newQuantity;

                // // Cập nhật onclick cho các nút
                // decreaseButton.onclick = () => updateQuantity(cartId, newQuantity - 1);
                // increaseButton.onclick = () => updateQuantity(cartId, newQuantity + 1);

                // Cập nhật tổng tiền trong giỏ hàng
                const cartTotal = document.querySelector('.cart-total');
                if (cartTotal) {
                    cartTotal.innerHTML = formatCurrency(total - response.discount);
                }

                // Cập nhật tổng tiền
                const totalElement = element.querySelector('.item-total');
                if (totalElement) {
                    totalElement.innerHTML = formatCurrency(priceItem);
                }

                const subTotal = document.getElementById("subTotal")
                if (subTotal) {
                    subTotal.textContent = formatCurrency(total)
                }

                const quantityInCart = document.querySelectorAll('.bg-danger.cartCount');
                quantityInCart.forEach(element => {
                    element.textContent = response.cartCount;
                });
            },
            error: function (xhr, status, error) {
                console.error('Lỗi AJAX:', error);
                alert('Có lỗi khi cập nhật số lượng.');
            }
        });
    }

    // format price
    function formatCurrency(value) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(value);
    }

    function removeItem(cartId) {
        Swal.fire({
            title: 'Bạn có chắc muốn xóa sản phẩm này?',
            text: "Hành động này sẽ không thể hoàn tác!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonColor: "#3085d6",
            cancelButtonColor: "#d33",
            confirmButtonText: 'Xác nhận',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '/cart',
                    method: 'POST',
                    data: {
                        action: "remove",
                        cartId: cartId
                    },
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
                        });
                        if (response.success) {
                            Toast.fire({
                                title: response.message || "Đã xóa sản phẩm ra khỏi giỏ hàng!",
                                icon: "success"
                            });
                            // xóa đối tượng
                            const element = document.querySelector('.cart-item[data-cart-id="' + cartId + '"]');
                            element.classList.add('animate__animated', 'animate__fadeOutLeft');
                            setTimeout(() => {
                                element.remove();
                            }, 500);

                            // cập nhật lại quantity In Cart
                            const quantityInCart = document.querySelectorAll('.bg-danger.cartCount');
                            quantityInCart.forEach(element => {
                                element.textContent = response.cartCount;
                            });

                            const subTotal = document.getElementById("subTotal")
                            if (subTotal) {
                                subTotal.textContent = formatCurrency(response.total)
                            }

                            const cartTotal = document.querySelector('.cart-total');
                            if (cartTotal) {
                                if (response.total - response.discount <= 0) {
                                    cartTotal.innerHTML = formatCurrency(0)
                                } else {
                                    cartTotal.innerHTML = formatCurrency(response.total - response.discount);
                                }

                            }

                        } else {
                            Toast.fire({
                                title: response.message || "Có lỗi!",
                                icon: "error"
                            });
                        }
                    },
                    error: function (xhr) {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi',
                            text: 'Có lỗi xảy ra, vui lòng thử lại!',
                        });
                    }
                });
            }
        });
    }

    function changeVariants(cartId, productId) {
        const element = document.querySelector('.cart-item[data-cart-id="' + cartId + '"]');
        const confirmButton = document.querySelector('#confirmButton[data-cart-id="' + cartId + '"]');
        const colorId = confirmButton.dataset?.color || 0;
        const addonId = confirmButton.dataset?.addon || 0;


        const hasColorVariants = element.querySelector('.variant-group .variant-button[data-type="color"]') !== null;
        const hasAddonVariants = element.querySelector('.variant-group .variant-button[data-type="addon"]') !== null;

        // Kiểm tra và thông báo nếu thiếu lựa chọn
        if (hasColorVariants && colorId === 0) {
            Swal.fire({
                title: "Vui lòng chọn màu sắc!",
                icon: "warning",
                draggable: true
            });
            return;
        }
        if (hasAddonVariants && addonId === 0) {
            Swal.fire({
                title: "Vui lòng chọn phụ kiện!",
                icon: "warning",
                draggable: true
            });
            return;
        }

        if (!colorId && !addonId) {
            Swal.fire({
                title: "Vui lòng chọn biến thể trước khi xác nhận!",
                icon: "warning",
                draggable: true
            });
            return; // Thoát hàm nếu không có biến thể
        }

        // Hiển thị overlay (bỏ comment nếu cần)
        // const loadingOverlay = document.querySelector('#loadingOverlay');
        // if (loadingOverlay) {
        //     loadingOverlay.classList.remove('d-none');
        // }

        $.ajax({
            url: '/cart',
            method: 'POST',
            data: {
                action: 'change-variant',
                cartId: cartId,
                productId: productId,
                colorId: colorId,
                addonId: addonId
            },
            success: function (response) {
                if (response.success) {

                    const confirmButton = element.querySelector('#confirmButton');
                    // Đóng dropdown
                    const dropdown = confirmButton.closest('.dropdown');
                    if (dropdown) {
                        const dropdownToggle = dropdown.querySelector('.dropdown-toggle');
                        if (dropdownToggle) {
                            dropdownToggle.click();
                        }
                    }

                    console.log(response);
                    if (element && response.item) {
                        const item = response.item;

                        // Cập nhật hình ảnh
                        const imageElement = element.querySelector('.cart-item-image');
                        if (imageElement) {
                            if (item.cartItem.mainImage && item.cartItem.mainImage.trim() !== "") {
                                imageElement.src = "http://localhost:8080/assets/images/products/" + item.cartItem.mainImage;
                            }
                        }

                        // Cập nhật giá gốc, giá giảm giá, và phần trăm giảm giá
                        const priceElement = element.querySelector('.cart-item-price');
                        if (priceElement) {
                            if (item.cartItem.discountPercent && item.cartItem.discountPercent > 0) {
                                const salePrice = (item.cartItem.basePrice + (item.cartItem?.productVariant?.color?.additionalPrice || 0) + (item.cartItem?.productVariant?.addon?.additionalPrice || 0)) * (1 - item.cartItem.discountPercent / 100);
                                // Cập nhật giá giảm
                                const salePriceElement = priceElement.querySelector('.cart-item-sale-price');
                                salePriceElement.textContent = formatCurrency(salePrice);
                                <%--// Cập nhật giá gốc--%>
                                const basePriceElement = priceElement.querySelector('.cart-item-base-price');
                                basePriceElement.textContent = formatCurrency(item.cartItem.basePrice + (item.cartItem?.productVariant?.color?.additionalPrice || 0) + (item.cartItem?.productVariant?.addon?.additionalPrice || 0));
                                <%--// Cập nhật phần trăm giảm giá--%>
                                const discountElement = priceElement.querySelector('.cart-item-discount');
                                <%--discountElement.textContent = `-${Math.round(item.cartItem.discountPercent)}%`;--%>
                                <%--// Hiển thị các phần tử liên quan đến giảm giá--%>
                                if (salePriceElement) salePriceElement.style.display = 'inline';
                                if (basePriceElement) basePriceElement.style.display = 'inline';
                                if (discountElement) discountElement.style.display = 'inline';

                                // Ẩn phần tử giá gốc (không giảm giá)
                                const basePriceOnlyElement = priceElement.querySelector('.cart-item-base-price:not(del)');
                                if (basePriceOnlyElement) basePriceOnlyElement.style.display = 'none';
                            } else {
                                // Cập nhật giá gốc (không có giảm giá)
                                const basePriceOnlyElement = priceElement.querySelector('.cart-item-base-price:not(del)');
                                if (basePriceOnlyElement) {
                                    basePriceOnlyElement.textContent = formatCurrency(item.cartItem.basePrice);
                                    basePriceOnlyElement.style.display = 'inline';
                                }
                                // // Ẩn các phần tử liên quan đến giảm giá
                                const salePriceElement = priceElement.querySelector('.cart-item-sale-price');
                                const basePriceElement = priceElement.querySelector('.cart-item-base-price');
                                const discountElement = priceElement.querySelector('.cart-item-discount');
                                if (salePriceElement) salePriceElement.style.display = 'none';
                                if (basePriceElement) basePriceElement.style.display = 'none';
                                if (discountElement) discountElement.style.display = 'none';
                            }
                        }

                        // Cập nhật phân loại
                        const classificationLabel = element.querySelector('.classification-label');
                        if (classificationLabel && item.cartItem && item.cartItem.productVariant) {
                            let classificationText = "Phân loại: ";
                            const variant = item.cartItem.productVariant;
                            if (variant.color && variant.color.name) {
                                classificationText += variant.color.name;
                            }
                            if (variant.color && variant.color.name && variant.addon && variant.addon.name) {
                                classificationText += ", ";
                            }
                            if (variant.addon && variant.addon.name) {
                                classificationText += variant.addon.name;
                            }
                            classificationLabel.textContent = classificationText;
                        } else if (classificationLabel) {
                            // Nếu không có phân loại, để trống
                            classificationLabel.textContent = "";
                        }

                        // Cập nhật price
                        const totalElement = element.querySelector('.cart-item-total');
                        if (totalElement) {
                            totalElement.textContent = formatCurrency(response.price);
                        }

                        // cập nhật total
                        const cartTotal = document.querySelector('.cart-total');
                        if (cartTotal) {

                            cartTotal.textContent = formatCurrency(response.total - response.discount)
                        }

                        const subTotal = document.getElementById("subTotal")
                        if (subTotal) {
                            subTotal.textContent = formatCurrency(response.total)
                        }

                        // cập nhật lại giá trị của max của stock
                        const quantityInput = document.querySelector("#quantity-" + item.cartId);
                        if (quantityInput) {
                            quantityInput.setAttribute("max", item.cartItem.productVariant.stock);
                            quantityInput.value = 1;
                        }

                        // cập nhật lại quantity In Cart
                        const quantityInCart = document.querySelectorAll('.bg-danger.cartCount');
                        quantityInCart.forEach(element => {
                            element.textContent = response.totalQuantity;
                        });

                    }
                } else {
                    Swal.fire({
                        title: "Có lỗi khi cập nhật biến thể!",
                        icon: "error",
                        draggable: true
                    });
                }
            },
            error: function (xhr, status, error) {
                console.error('Lỗi AJAX:', error);
                Swal.fire({
                    title: "Có lỗi khi cập nhật biến thể!",
                    icon: "error",
                    draggable: true
                });
            },
            complete: function () {
                // Ẩn overlay loading (bỏ comment nếu cần)
                // if (loadingOverlay) {
                //     loadingOverlay.classList.add('d-none');
                // }
            }
        });
    }

    $('#applyPromoButton').click(function () {
        const promoCode = $('#promoCodeInput').val().trim();

        if (!promoCode) {
            Swal.fire({
                title: "Vui lòng nhập mã khuyến mãi!",
                icon: "warning",
                draggable: true
            });
            return;
        }


        $.ajax({
            url: '/voucher',
            method: 'POST',
            data: {
                action: 'add',
                code: promoCode,
            },
            success: function (response) {
                if (response.success) {
                    appliedPromo = {
                        code: promoCode,
                    };
                    $('#promoCodeName').text(promoCode);
                    $('#removePromoButton').data('voucher-id', response.voucher.id);
                    $('#appliedPromo').show();


                    $('#discount').text(formatCurrency(response.discount));
                    $('#total').text(formatCurrency(response.total - response.discount));

                } else {
                    let message = response.message || 'Không thể áp dụng mã khuyến mãi!';
                    Swal.fire({
                        title: "Lỗi!",
                        text: message,
                        icon: "error",
                        draggable: true
                    });
                }
            },
            error: function () {
                Swal.fire({
                    title: "Lỗi hệ thống!",
                    text: "Không thể xử lý mã khuyến mãi. Vui lòng thử lại sau!",
                    icon: "error",
                    draggable: true
                });
            }
        });
    });

    $('#removePromoButton').click(function () {
        var voucherId = $(this).data('voucher-id');


        $.ajax({
            url: '/voucher',
            type: 'POST',
            data: {
                action: 'remove',
                voucherId: voucherId
            },
            success: function (response) {
                if (response.success) {
                    $('#appliedPromo').hide();
                    $('#promoCodeName').text('');
                    $('#removePromoButton').data('voucher-id', '');

                    // Cập nhật chi tiết đơn hàng
                    $('#subTotal').text(formatCurrency(response.total));
                    $('#discount').text('₫ 0');
                    $('#total').text(formatCurrency(response.total));
                } else {
                    Swal.fire({
                        title: "Lỗi hệ thống!",
                        text: "Không thể xử lý mã khuyến mãi. Vui lòng thử lại sau!",
                        icon: "error",
                        draggable: true
                    });
                }
            },
            error: function (xhr, status, error) {
                alert('Đã có lỗi xảy ra: ' + error);
            }
        });
    });
    $('#payment').click(function (event) {
        event.preventDefault();

        $.ajax({
            url: '/profile',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({action: "count_user_address"}),
            success: function (response) {
                if (response.status) {
                    window.location.href = '/order';
                } else {
                    Swal.fire({
                        icon: "warning",
                        title: "Cập nhật địa chỉ!",
                        text: "Vui lòng cập nhật địa chỉ trong hồ sơ của bạn trước khi đặt hàng.",
                        confirmButtonText: "Cập nhật ngay",
                        showCancelButton: true,
                        cancelButtonText: "Để sau"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            window.location.href = '/profile?action=addresses';
                        }
                    });
                }
            },
            error: function (xhr, status, error) {
                Swal.fire({
                    icon: "error",
                    title: "Lỗi!",
                    text: "Không thể kiểm tra địa chỉ. Vui lòng thử lại sau.",
                    confirmButtonText: "OK"
                });
                console.error("Lỗi khi gọi API:", error);
            }
        });
    });
</script>


