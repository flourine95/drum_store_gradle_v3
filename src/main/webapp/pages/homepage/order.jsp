<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    /* Reset và style chung */
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
    }

    body {
        font-family: Arial, sans-serif;
        background-color: #f5f5f5;
    }

    .container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
    }

    /* Section chung */
    .section {
        background-color: white;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 20px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
    }

    .section h5 {
        font-weight: bold;
        margin-bottom: 15px;
        color: #003087;
    }

    .section label {
        font-weight: 500;
        color: #333;
    }

    /* Form elements */
    .form-control, .form-select {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 8px;
        transition: border-color 0.3s ease;
    }

    .form-control:focus, .form-select:focus {
        border-color: #003087;
        box-shadow: 0 0 5px rgba(0, 48, 135, 0.2);
        outline: none;
    }

    .form-control.is-invalid {
        border-color: #dc3545;
    }

    .invalid-feedback {
        color: #dc3545;
        font-size: 14px;
    }

    .form-check-label {
        font-size: 14px;
        color: #333;
        cursor: pointer;
    }

    .form-check-input:checked + .form-check-label {
        color: #003087;
    }

    /* Shipping options */
    .shipping-options {
        display: flex;
        flex-direction: column;
        gap: 10px;
        margin: 10px 0;
    }

    .shipping-options h6 {
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .shipping-type {
        display: flex;
        align-items: center;
        justify-content: space-between;
        border: 2px solid #ddd;
        padding: 10px 15px;
        border-radius: 8px;
        cursor: pointer;
        transition: border-color 0.3s ease;
    }

    .shipping-type input {
        display: none;
    }

    .shipping-type label {
        cursor: pointer;
        font-weight: 500;
        color: #333;
        display: flex;
        justify-content: space-between;
        width: 100%;
    }

    .shipping-type .price {
        font-weight: bold;
        color: #333;
    }

    .shipping-type:hover {
        border-color: #007bff;
    }

    .shipping-type input:checked + label {
        color: #007bff;
    }

    .shipping-type input:checked + label .price {
        color: #007bff;
    }

    .shipping-type input:checked + .shipping-type {
        border-color: #007bff;
    }

    /* Payment methods */
    .payment-method {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 10px;
        transition: border-color 0.3s ease;
    }

    .payment-method:hover {
        border-color: #003087;
    }

    .payment-method input:checked + label {
        color: #003087;
    }

    .payment-method img {
        height: 20px;
        margin-left: 5px;
    }

    /* Order summary */
    .order-summary {
        background-color: white;
        padding: 20px;
        border-radius: 10px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        height: fit-content;
    }

    .order-item {
        display: flex;
        align-items: center;
        margin-bottom: 15px;
    }

    .order-item img {
        width: 50px;
        height: 50px;
        margin-right: 10px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    .order-item-details {
        flex-grow: 1;
    }

    .order-item-details p {
        margin: 0;
        font-size: 14px;
    }

    .order-total {
        font-weight: bold;
        color: #003087;
    }

    /* Buttons */
    .btn-primary {
        background-color: #003087;
        border: none;
        color: #fff;
        width: 100%;
        border-radius: 8px;
        padding: 10px;
        font-weight: 500;
        transition: background-color 0.3s ease;
    }

    .btn-primary:hover {
        background-color: #002669;
    }

    .btn-secondary {
        background-color: #6c757d;
        border: none;
        color: #fff;
        border-radius: 8px;
        padding: 8px 15px;
        font-weight: 500;
        transition: background-color 0.3s ease;
    }

    .btn-secondary:hover {
        background-color: #5a6268;
    }

    /* Popup */
    #addressPopup {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        z-index: 1000;
    }

    #addressPopup .modal-content {
        background-color: white;
        margin: 15% auto;
        padding: 20px;
        border-radius: 10px;
        width: 50%;
        max-height: 70vh;
        overflow-y: auto;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
    }

    .address-list {
        margin-bottom: 15px;
    }

    .address-item {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 8px;
        margin-bottom: 10px;
        cursor: pointer;
        transition: border-color 0.3s ease;
    }

    .address-item:hover {
        border-color: #003087;
    }

    .address-item.selected {
        border-color: #003087;
        background-color: #f0f4ff;
    }

    /* Utility classes */
    .text-muted {
        color: #6c757d;
    }

    .text-primary {
        color: #003087;
    }

    .hidden {
        display: none;
    }
</style>

<div class="container my-5">
    <div class="row">
        <!-- Phần thông tin khách hàng và thanh toán -->
        <div class="col-md-8">
            <!-- Tài khoản -->
            <c:set var="user" value="${sessionScope.user}"/>
            <div class="section">
                <label for="email">TÀI KHOẢN</label>
                <div class="input-group mb-3">
                    <input type="email" class="form-control" id="email" value="${user.email}" readonly>
                </div>
            </div>

            <!-- Giao hàng -->
            <div class="section">
                <h5>GIAO HÀNG</h5>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="radio" name="shippingMethod" id="shipToAddress"
                           value="shipToAddress" checked>
                    <label class="form-check-label" for="shipToAddress">Vận chuyển</label>
                </div>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="radio" name="shippingMethod" id="pickup" value="pickup">
                    <label class="form-check-label" for="pickup">Nhận hàng tại cửa hàng</label>
                </div>

                <div id="shippingOptions" class="shipping-options">
                    <h6>Phương thức vận chuyển</h6>
                    <div class="shipping-type">
                        <input class="form-check-input" type="radio" name="shippingType" id="fastShipping" value="fast"
                               checked>
                        <label class="form-check-label" for="fastShipping">
                            Vận chuyển nhanh <span class="price">50.000 đ</span>
                        </label>
                    </div>
                    <div class="shipping-type">
                        <input class="form-check-input" type="radio" name="shippingType" id="economyShipping"
                               value="economy">
                        <label class="form-check-label" for="economyShipping">
                            Vận chuyển tiết kiệm <span class="price">30.000 đ</span>
                        </label>
                    </div>
                </div>

                <c:set var="mainAddress" value="${address['mainAddress']}"/>
                <div class="row address-section"
                     data-address-id="${not empty mainAddress[0].id ? mainAddress[0].id : ''}">
                    <div class="col-md-6 mb-3">
                        <label for="name">Tên (*)</label>
                        <input type="text" class="form-control" id="name" name="name"
                               value="${not empty mainAddress[0].fullName ? mainAddress[0].fullName : ''}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label for="phone">Điện thoại (*)</label>
                        <input type="text" class="form-control" id="phone" name="phone"
                               value="${not empty mainAddress[0].phone ? mainAddress[0].phone : ''}" required>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="shippingProvince">Tỉnh/Thành phố <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="shippingProvince" readonly
                               value="${not empty mainAddress[0].province ? mainAddress[0].province : ''}"
                               placeholder="Tỉnh/Thành phố">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="shippingDistrict">Quận/Huyện <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="shippingDistrict" readonly
                               value="${not empty mainAddress[0].district ? mainAddress[0].district : ''}"
                               placeholder="Quận/Huyện">
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="shippingWard">Phường/Xã <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="shippingWard" readonly
                               value="${not empty mainAddress[0].ward ? mainAddress[0].ward : ''}"
                               placeholder="Phường/Xã">
                    </div>
                    <div class="col-12 mb-3">
                        <label for="shippingStreet">Địa chỉ cụ thể</label>
                        <input type="text" class="form-control" id="shippingStreet" readonly
                               value="${not empty mainAddress[0].fullAddress ? mainAddress[0].fullAddress : ''}"
                               placeholder="Căn hộ, phòng, khu, v.v.">
                    </div>
                </div>

                <div class="form-check mb-3">
                    <input class="form-check-input" type="checkbox" id="saveInfo">
                    <label class="form-check-label" for="saveInfo">Gửi chi tiết tài khoản và địa chỉ tới tin
                        nhắn</label>
                </div>

                <!-- Thanh toán -->
                <h5>THANH TOÁN</h5>
                <p>Tất cả các giao dịch được mã hóa và an toàn.</p>
                <div class="payment-method">
                    <div>
                        <input class="form-check-input" type="radio" name="paymentMethod" id="onepay" value="onepay">
                        <label class="form-check-label" for="onepay">VNPAY</label>
                    </div>

                </div>
                <div id="cardDetails" class="card-details hidden">
                    <div class="container">
                        <div class="d-flex flex-column justify-content-center align-items-center gap-2 ">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="-252.3 356.1 163 80.9" class="zjrzY" style="width: 25%">
                                <path fill="none" stroke="currentColor" stroke-miterlimit="10" stroke-width="2"
                                      d="M-108.9 404.1v30c0 1.1-.9 2-2 2H-231c-1.1 0-2-.9-2-2v-75c0-1.1.9-2 2-2h120.1c1.1 0 2 .9 2 2v37m-124.1-29h124.1"></path>
                                <circle cx="-227.8" cy="361.9" r="1.8" fill="currentColor"></circle>
                                <circle cx="-222.2" cy="361.9" r="1.8" fill="currentColor"></circle>
                                <circle cx="-216.6" cy="361.9" r="1.8" fill="currentColor"></circle>
                                <path fill="none" stroke="currentColor" stroke-miterlimit="10" stroke-width="2"
                                      d="M-128.7 400.1H-92m-3.6-4.1 4 4.1-4 4.1"></path>
                            </svg>
                            <p>Sau khi nhấp vào "Hoàn tất đơn hàng", bạn sẽ được chuyển hướng đến ONEPAY để hoàn tất mua
                                hàng an toàn.</p>
                        </div>
                    </div>
                </div>
                <div class="payment-method">
                    <div>
                        <input class="form-check-input" type="radio" name="paymentMethod" id="cod" value="cod" checked>
                        <label class="form-check-label" for="cod">Thanh toán khi nhận hàng (COD)</label>
                    </div>
                </div>

                <!-- Địa chỉ thanh toán -->
                <h5>ĐỊA CHỈ THANH TOÁN</h5>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="radio" name="billingAddress" id="sameAsShipping"
                           value="sameAsShipping" checked>
                    <label class="form-check-label" for="sameAsShipping">Sử dụng địa chỉ giao hàng</label>
                </div>
                <div class="form-check mb-3">
                    <input class="form-check-input" type="radio" name="billingAddress" id="differentAddress"
                           value="differentAddress">
                    <label class="form-check-label" for="differentAddress">Sử dụng địa chỉ thanh toán khác</label>
                </div>
            </div>
        </div>

        <!-- Phần tóm tắt đơn hàng -->
        <div class="col-md-4">
            <div class="order-summary">
                <c:forEach var="item" items="${cart.items}">
                    <div class="order-item">
                        <img src="${pageContext.request.contextPath}/assets/images/products/${item.cartItem.mainImage}"
                             alt="${item.cartItem.name}" width="100">
                        <div class="order-item-details">
                            <p>${item.cartItem.name}</p>
                            <p class="text-muted">
                                <c:if test="${not empty item.cartItem.productVariant.color}">
                                    Màu: ${item.cartItem.productVariant.color.name}
                                </c:if>
                            </p>
                        </div>
                        <span><fmt:formatNumber value="${item.cartItem.getLowestSalePrice() * item.quantity}"
                                                type="currency" currencySymbol="đ"/></span>
                    </div>
                    <hr>
                </c:forEach>

                <div class="d-flex justify-content-between mb-2">
                    <c:if test="${not empty cart.voucher}">
                        <span>MÃ GIẢM GIÁ HOẶC THẺ QUÀ TẶNG</span>
                        <span>${cart.voucher.code}</span>
                    </c:if>
                </div>

                <div class="d-flex justify-content-between mb-2">
                    <span>Tạm tính</span>
                    <span id="subTotal"><fmt:formatNumber value="${cart.total}" type="currency"
                                                          currencySymbol="đ"/></span>
                </div>

                <div class="d-flex justify-content-between mb-2">
                    <span>Vận chuyển</span>
                    <span id="shippingFee">30.000 đ</span>
                </div>

                <hr>
                <div class="d-flex justify-content-between order-total">
                    <span>TỔNG</span>
                    <span id="totalAmount"><fmt:formatNumber value="${cart.total + 30000}" type="currency"
                                                             currencySymbol="đ"/></span>
                </div>
                <button class="btn btn-primary mt-3" id="submitPayment">HOÀN TẤT ĐƠN HÀNG</button>
            </div>
        </div>
    </div>
</div>

<!-- Popup danh sách địa chỉ -->
<div id="addressPopup">
    <div class="modal-content p-3">
        <h5 class="mb-3">Danh sách địa chỉ</h5>
        <c:choose>
            <c:when test="${not empty address['subAddress']}">
                <div id="addressList" class="address-list">
                    <c:forEach var="addr" items="${address['subAddress']}">
                        <div class="address-item" data-address-id="${addr.id}">
                            <h6 class="mb-1">${addr.fullName}</h6>
                            <p class="mb-1">${addr.phone}</p>
                            <p class="mb-1">${addr.fullAddress}, ${addr.ward}, ${addr.district}, ${addr.province}</p>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <p class="text-center text-muted">Không có địa chỉ nào, hãy thêm địa chỉ mới.</p>
            </c:otherwise>
        </c:choose>
        <button class="btn btn-primary mt-2" id="addNewAddress">Thêm địa chỉ mới</button>
        <button class="btn btn-secondary mt-2" id="closePopup">Đóng</button>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Khởi tạo giá trị ban đầu
        const baseTotal = ${cart.total}; // Tổng tiền ban đầu từ server
        let shippingFee = 30000; // Phí vận chuyển mặc định (Vận chuyển nhanh)
        let totalAmount = baseTotal + shippingFee;

        // Cập nhật giao diện ban đầu
        $('#shipToAddress').prop('checked', true);
        $('#fastShipping').prop('checked', true);
        $('#cod').prop('checked', true);
        $('#sameAsShipping').prop('checked', true);
        $('#shippingOptions').show();
        $('#cardDetails').hide();
        $('#addressPopup').hide();
        updateTotal();

        // Hiển thị/ẩn tùy chọn vận chuyển và cập nhật phí vận chuyển
        $('input[name="shippingMethod"]').change(function () {
            if ($('#shipToAddress').is(':checked')) {
                $('#shippingOptions').show();
                shippingFee = $('#fastShipping').is(':checked') ? 50000 : 30000;
            } else {
                $('#shippingOptions').hide();
                shippingFee = 0; // Nhận hàng tại cửa hàng: phí vận chuyển = 0
            }
            updateTotal();
        });

        // Cập nhật phí vận chuyển khi thay đổi loại vận chuyển
        $('input[name="shippingType"]').change(function () {
            shippingFee = $(this).val() === 'fast' ? 30000 : 50000;
            updateTotal();
            $('.shipping-type').css('border-color', '#ddd');
            $(this).closest('.shipping-type').css('border-color', '#007bff');
        });

        // Hiển thị/ẩn popup địa chỉ thanh toán
        $('input[name="billingAddress"]').change(function () {
            if ($('#differentAddress').is(':checked')) {
                $('#addressPopup').show();
            } else {
                $('#addressPopup').hide();
            }
        });

        // Đóng popup và đặt lại radio button
        $('#closePopup').click(function () {
            $('#addressPopup').hide();
            $('#sameAsShipping').prop('checked', true);
        });

        // Xử lý chọn địa chỉ từ popup
        $('.address-item').click(function () {
            $('.address-item').removeClass('selected');
            $(this).addClass('selected');
            const addressId = $(this).data('address-id');
            const fullName = $(this).find('h6').text();
            const phone = $(this).find('p:eq(0)').text();
            const addressDetails = $(this).find('p:eq(1)').text().split(', ');
            const fullAddress = addressDetails[0];
            const ward = addressDetails[1];
            const district = addressDetails[2];
            const province = addressDetails[3];

            $('#name').val(fullName);
            $('#phone').val(phone);
            $('#shippingStreet').val(fullAddress);
            $('#shippingWard').val(ward);
            $('#shippingDistrict').val(district);
            $('#shippingProvince').val(province);
            $('.address-section').data('address-id', addressId);

            $('#addressPopup').hide();
            $('#sameAsShipping').prop('checked', true);
        });

        // Xử lý nút "Thêm địa chỉ mới"
        $('#addNewAddress').click(function () {
           window.location.href = '/profile?action=addresses'
        });

        // Hiển thị/ẩn chi tiết thẻ tín dụng
        $('input[name="paymentMethod"]').change(function () {
            $('#cardDetails').toggle($('#onepay').is(':checked'));
        });

        // Xử lý nút "Hoàn tất đơn hàng"
        $('#submitPayment').click(function (e) {
            e.preventDefault();
            const addressId = $('.address-section').data('address-id');
            if (!addressId) {
                Swal.fire({
                    title: 'Không tìm thấy ID địa chỉ giao hàng!',
                    icon: "error",
                    draggable: true
                });
                return;
            }

            const paymentMethod = $('input[name="paymentMethod"]:checked').val();
            if (paymentMethod === 'cod') {
                handleCodPayment(addressId, totalAmount);
            } else if (paymentMethod === 'onepay') {
                handleVNPayPayment(addressId, totalAmount);
            }
        });

        // Hàm cập nhật tổng tiền
        function updateTotal() {
            totalAmount = baseTotal + shippingFee;
            $('#shippingFee').text(formatCurrency(shippingFee));
            $('#totalAmount').text(formatCurrency(totalAmount));
        }

        // Hàm xử lý thanh toán COD
        function handleCodPayment(addressId, totalAmount) {
            $.ajax({
                url: '/order',
                method: 'POST',
                data: {
                    action: 'cod',
                    amount: totalAmount,
                    userAddressId: addressId
                },
                success: function (response) {
                    if (response.success) {
                        Swal.fire({
                            title: 'Đặt hàng thành công!',
                            text: 'Mã đơn hàng: #' + response.orderId,
                            icon: 'success',
                            draggable: true
                        }).then(() => {
                            window.location.href = '/cart';
                        });
                    } else {
                        Swal.fire({
                            title: 'Đặt hàng thất bại!',
                            text: response.message || 'Có lỗi xảy ra, vui lòng thử lại!',
                            icon: 'error',
                            draggable: true
                        });
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Lỗi AJAX:', status, error, xhr.responseText);
                    Swal.fire({
                        title: 'Lỗi hệ thống!',
                        text: xhr.responseJSON?.message || 'Không thể kết nối đến server. Vui lòng thử lại!',
                        icon: 'error',
                        draggable: true
                    });
                }
            });
        }

// Hàm xử lý thanh toán VNPay
        function handleVNPayPayment(addressId, totalAmount) {
            $.ajax({
                url: '/order',
                method: 'POST',
                data: {
                    action: 'payment',
                    amount: totalAmount,
                    userAddressId: addressId
                },
                success: function (response) {
                    if (response.success && response.paymentUrl) {
                        Swal.fire({
                            title: 'Đơn hàng đã được tạo!',
                            text: response.orderId ? `Mã đơn hàng: #`+ response.orderId : 'Đang chuyển hướng đến VNPay...',
                            icon: 'success',
                            timer: 1500,
                            showConfirmButton: false,
                            draggable: true
                        }).then(() => {
                            window.location.href = response.paymentUrl;
                        });
                    } else {
                        Swal.fire({
                            title: 'Thanh toán VNPay thất bại!',
                            text: response.message || 'Không thể tạo thanh toán VNPay, vui lòng thử lại.',
                            icon: 'error',
                            draggable: true
                        });
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Lỗi AJAX:', status, error, xhr.responseText);
                    Swal.fire({
                        title: 'Lỗi hệ thống!',
                        text: xhr.responseJSON?.message || 'Không thể tạo đơn hàng hoặc thanh toán VNPay.',
                        icon: 'error',
                        draggable: true
                    });
                }
            });
        }

// Hàm định dạng tiền tệ
        function formatCurrency(value) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(value);
        }

    });
</script>