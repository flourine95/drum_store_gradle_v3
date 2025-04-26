<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="container">
    <div class="product-details">
        <!-- Breadcrumb -->
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="/">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="/category/${product.categoryId}">${product.categoryName}</a></li>
                <li class="breadcrumb-item active">${product.name}</li>
            </ol>
        </nav>

        <div class="row">
            <!-- Cột trái cho hình ảnh -->
            <div class="col-md-5">
                <div class="product-images">
                    <div class="main-image mb-3">
                        <c:if test="${not empty product.images}">
                            <img src="/assets/images/products/${product.mainImage}"
                                 alt="${product.name}"
                                 class="img-fluid rounded main-product-image"/>
                        </c:if>
                    </div>
                    <div class="thumbnail-images d-flex gap-2">
                        <c:forEach items="${product.images}" var="image">
                            <img src="/assets/images/products/${image.image}"
                                 alt="Thumbnail"
                                 class="img-thumbnail product-thumbnail"
                                 data-image-id="${image.id}"
                                 style="width: 80px; cursor: pointer;"/>
                        </c:forEach>
                    </div>
                </div>
            </div>

            <!-- Cột phải cho thông tin -->
            <div class="col-md-7">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h1 class="product-title">${product.name}</h1>
                    <c:if test="${product.featured}">
                        <span class="badge bg-warning">Sản phẩm nổi bật</span>
                    </c:if>
                </div>

                <!-- Product Meta -->
                <div class="product-meta mb-4">
                    <div class="d-flex gap-3 mb-2">
                        <span class="brand">
                            <i class="fas fa-industry"></i> 
                            Thương hiệu: <a href="/brand/${product.brandId}">${product.brandName}</a>
                        </span>
                        <span class="category">
                            <i class="fas fa-tags"></i>
                            Danh mục: <a href="/category/${product.categoryId}">${product.categoryName}</a>
                        </span>
                    </div>
                    <div class="d-flex gap-3">
                        <span class="views">
                            <i class="fas fa-eye"></i> ${product.totalViews} lượt xem
                        </span>
                        <span class="rating">
                            <i class="fas fa-star"></i> 
                            <span class="rating-score">
                                <fmt:formatNumber value="${product.averageRating}" maxFractionDigits="1"/>
                            </span>/5 
                            <span class="rating-count">(${product.totalReviews} đánh giá)</span>
                        </span>
                    </div>
                </div>

                <!-- Sales Info -->
                <div class="sales-info mb-4">
                    <c:if test="${not empty product.sales}">
                        <div class="active-sales">
                            <h5>Chương trình khuyến mãi:</h5>
                            <ul class="list-unstyled">
                                <c:forEach items="${product.sales}" var="sale">
                                    <li class="sale-item">
                                        <span class="badge bg-danger">${sale.discountPercentage}% OFF</span>
                                            ${sale.name}
                                        <small>(<span class="sale-date" data-start="${sale.startDate}"
                                                      data-end="${sale.endDate}"></span>)</small>
                                    </li>
                                </c:forEach>
                            </ul>
                        </div>
                    </c:if>
                </div>

                <div class="pricing mb-4">
                    <div class="original-price">
                        <span class="label">Giá gốc:</span>
                        <span id="basePrice" class="price">
                            <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫"
                                              maxFractionDigits="0"/>
                        </span>
                    </div>
                    <div class="final-price">
                        <span class="label">Giá bán:</span>
                        <span id="salePrice" class="price">
                            <fmt:formatNumber value="${product.lowestSalePrice}" type="currency" currencySymbol="₫"
                                              maxFractionDigits="0"/>
                        </span>
                    </div>
                </div>

                <div class="variants mb-4">
                    <c:if test="${product.stockManagementType == 1 || product.stockManagementType == 3}">
                        <div class="variant-group mb-3">
                            <h5>Màu sắc:</h5>
                            <div id="colorOptions" class="variant-options">
                                <!-- JS sẽ render vào đây -->
                            </div>
                        </div>
                    </c:if>

                    <c:if test="${product.stockManagementType == 2 || product.stockManagementType == 3}">
                        <div class="variant-group mb-3">
                            <h5>Phụ kiện:</h5>
                            <div id="addonOptions" class="variant-options">
                                <!-- JS sẽ render vào đây -->
                            </div>
                        </div>
                    </c:if>
                </div>

                <div class="quantity-controls mb-4">
                    <h5>Số lượng:</h5>
                    <div class="d-flex align-items-center gap-3">
                        <div class="input-group" style="width: 150px;">
                            <button class="btn btn-outline-secondary" type="button" id="decreaseQuantity">-</button>
                            <input type="number" class="form-control text-center" id="quantity" value="1" min="1">
                            <button class="btn btn-outline-secondary" type="button" id="increaseQuantity">+</button>
                        </div>
                        <span id="maxQuantityMsg" class="text-muted"></span>
                    </div>
                </div>

                <div class="action-buttons mb-4">
                    <div class="d-flex gap-2">
                        <c:choose>
                            <c:when test="${not empty sessionScope.user}">
                                <button id="addToCart" class="btn btn-primary flex-grow-1" disabled>
                                    <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                </button>
                                <button id="buyNow" class="btn btn-danger flex-grow-1" disabled>
                                    <i class="fas fa-bolt"></i> Mua ngay
                                </button>
                                <button id="addToWishlist" class="btn btn-outline-danger"
                                        onclick="toggleWishList(${product.id})">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <button  class="btn btn-primary flex-grow-1"  onclick="redirectToLogin()">
                                    <i class="fas fa-shopping-cart"></i> Thêm vào giỏ
                                </button>
                                <button class="btn btn-danger flex-grow-1"  onclick="redirectToLogin()">
                                    <i class="fas fa-bolt"></i> Mua ngay
                                </button>
                                <button class="btn btn-outline-danger" onclick="redirectToLogin()">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </c:otherwise>
                        </c:choose>


                    </div>
                </div>

                <!-- Description -->
                <div class="description mb-4">
                    <h5>Mô tả sản phẩm:</h5>
                    <p>${product.description}</p>
                </div>

                <!-- Reviews Summary -->
                <div class="reviews-summary mb-4">
                    <h5>Đánh giá gần đây:</h5>
                    <div class="recent-reviews">
                        <c:forEach items="${product.reviews}" var="review" varStatus="status">
                            <c:if test="${status.index < 2}">
                                <div class="review-item p-3 mb-2 bg-light rounded">
                                    <div class="d-flex align-items-center mb-2">
                                        <img src="/assets/images/products/${review.userAvatar}"
                                             alt="${review.userName}"
                                             class="rounded-circle me-2"
                                             style="width: 40px; height: 40px; object-fit: cover;">
                                        <div>
                                            <strong>${review.userName}</strong>
                                            <div class="text-warning" data-rating="${review.rating}">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star${i <= review.rating ? '' : '-o'}"></i>
                                                </c:forEach>
                                                <span class="ms-1">${review.rating}/5</span>
                                            </div>
                                        </div>
                                    </div>
                                    <p class="mb-1">${review.content}</p>
                                    <small class="text-muted">${review.createdAt}</small>
                                </div>
                            </c:if>
                        </c:forEach>
                        <c:if test="${product.totalReviews > 2}">
                            <a href="#all-reviews" class="btn btn-link">Xem tất cả ${product.totalReviews} đánh giá</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    .product-details {
        padding: 2rem 0;
    }

    .product-title {
        font-size: 1.8rem;
        font-weight: 600;
    }

    .product-meta {
        color: #666;
    }

    .pricing .label {
        font-weight: 500;
        margin-right: 1rem;
    }

    .original-price .price {
        text-decoration: line-through;
        color: #666;
    }

    .final-price .price {
        font-size: 1.5rem;
        color: #e53935;
        font-weight: 600;
    }

    .variant-options {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .variant-btn {
        padding: 0.5rem 1rem;
        border: 2px solid #ddd;
        border-radius: 4px;
        background: white;
        cursor: pointer;
        transition: all 0.2s;
    }

    .variant-btn:hover {
        border-color: #666;
    }

    .variant-btn.selected {
        background: #1976d2;
        color: white;
        border-color: #1976d2;
    }

    .stock-info {
        padding: 1rem;
        background: #f5f5f5;
        border-radius: 4px;
    }

    .stock-info .label {
        font-weight: 500;
        margin-right: 1rem;
    }

    .main-product-image {
        width: 100%;
        height: auto;
        object-fit: cover;
    }

    .selected-thumbnail {
        border: 2px solid #1976d2 !important;
    }

    .sale-item {
        margin-bottom: 0.5rem;
        padding: 0.5rem;
        background: #fff4f4;
        border-radius: 4px;
    }

    .review-item {
        transition: all 0.2s;
    }

    .review-item:hover {
        background-color: #f8f9fa !important;
    }

    .description {
        line-height: 1.6;
    }

    .product-meta a {
        color: #1976d2;
        text-decoration: none;
    }

    .product-meta a:hover {
        text-decoration: underline;
    }

    .quantity-controls input[type="number"] {
        -moz-appearance: textfield;
    }

    .quantity-controls input[type="number"]::-webkit-outer-spin-button,
    .quantity-controls input[type="number"]::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }

    .action-buttons .btn {
        padding: 0.75rem 1.5rem;
    }

    .btn:disabled {
        cursor: not-allowed;
    }

    .rating {
        display: inline-flex;
        align-items: center;
        gap: 0.25rem;
    }

    .rating .fas.fa-star {
        color: #ffc107;
    }

    .rating-score {
        font-weight: 600;
    }

    .rating-count {
        color: #666;
    }

    .star-rating {
        color: #ffc107;
        font-size: 0.9rem;
    }

    .star-rating .fas.fa-star {
        margin-right: 2px;
    }

    .star-rating .fas.fa-star-half-alt {
        margin-right: 2px;
    }

    .star-rating .far.fa-star {
        margin-right: 2px;
    }
</style>

<script>
    $(document).ready(function () {
        const variants = [
            <c:forEach items="${product.variants}" var="variant" varStatus="status">
            {
                id: ${variant.id},
                imageId: ${variant.imageId},
                <c:if test="${product.stockManagementType == 1 || product.stockManagementType == 3}">
                color: {
                    id: ${variant.color.id},
                    name: '${variant.color.name}',
                    additionalPrice: ${variant.color.additionalPrice}
                },
                </c:if>
                <c:if test="${product.stockManagementType == 2 || product.stockManagementType == 3}">
                addon: {
                    id: ${variant.addon.id},
                    name: '${variant.addon.name}',
                    additionalPrice: ${variant.addon.additionalPrice}
                },
                </c:if>
                stock: ${variant.stock},
                status: ${variant.status}
            }<c:if test="${!status.last}">, </c:if>
            </c:forEach>
        ];
        const product = {
            basePrice: ${product.basePrice},
            discountPercent: ${product.discountPercent},
            stockManagementType: ${product.stockManagementType}
        };
        let selectedColor = null;
        let selectedAddon = null;
        const basePrice = product.basePrice;
        const discountPercent = product.discountPercent;
        let currentVariant = null;
        let maxQuantity = 0;

        function formatPrice(price) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND'
            }).format(price);
        }

        function findVariant(colorId, addonId) {
            switch (product.stockManagementType) {
                case 0:
                    return variants[0]; // Chỉ có 1 variant
                case 1:
                    return variants.find(v => v.color.id === parseInt(colorId));
                case 2:
                    return variants.find(v => v.addon.id === parseInt(addonId));
                case 3:
                    return variants.find(v =>
                        v.color.id === parseInt(colorId) &&
                        v.addon.id === parseInt(addonId)
                    );
            }
        }

        function calculateFinalPrice(basePrice, colorPrice, addonPrice) {
            const totalBeforeDiscount = basePrice + colorPrice + addonPrice;
            return totalBeforeDiscount * (1 - discountPercent / 100);
        }

        function updateVariantInfo() {
            let finalPrice = basePrice;
            let totalBasePrice = basePrice;  // Thêm biến này để tính tổng giá gốc
            let stockMessage = "Vui lòng chọn biến thể";
            let variant = null;

            switch (product.stockManagementType) {
                case 0:
                    variant = variants[0];
                    finalPrice = calculateFinalPrice(basePrice, 0, 0);
                    stockMessage = `\${variant.stock} sản phẩm`;
                    break;
                case 1:
                    if (selectedColor) {
                        variant = findVariant(selectedColor.data('colorId'));
                    }
                    break;
                case 2:
                    if (selectedAddon) {
                        variant = findVariant(null, selectedAddon.data('addonId'));
                    }
                    break;
                case 3:
                    if (selectedColor && selectedAddon) {
                        variant = findVariant(selectedColor.data('colorId'), selectedAddon.data('addonId'));
                    }
                    break;
            }

            if (variant) {
                const colorPrice = selectedColor ? parseFloat(selectedColor.data('price') || 0) : 0;
                const addonPrice = selectedAddon ? parseFloat(selectedAddon.data('price') || 0) : 0;

                // Cập nhật tổng giá gốc bao gồm cả phụ phí của variant
                totalBasePrice = basePrice + colorPrice + addonPrice;
                // Tính giá sau khi giảm giá
                finalPrice = calculateFinalPrice(basePrice, colorPrice, addonPrice);
                stockMessage = `\${variant.stock} sản phẩm`;

                // Cập nhật ảnh dựa trên imageId của variant
                if (variant.imageId) {
                    const thumbnailImage = $(`.product-thumbnail[data-image-id="\${variant.imageId}"]`);
                    if (thumbnailImage.length) {
                        const newSrc = thumbnailImage.attr('src');
                        $('.main-product-image').attr('src', newSrc);

                        // Cập nhật trạng thái selected cho thumbnail
                        $('.product-thumbnail').removeClass('selected-thumbnail');
                        thumbnailImage.addClass('selected-thumbnail');
                    }
                }

                currentVariant = variant;
                updateQuantityControls();
            } else {
                currentVariant = null;
                updateQuantityControls();
            }

            // Cập nhật cả giá gốc và giá bán
            $('#basePrice').text(formatPrice(totalBasePrice));
            $('#salePrice').text(formatPrice(finalPrice));
        }

        function renderVariants() {
            const processedColors = new Set();
            const processedAddons = new Set();

            const colorOptionsHtml = [];
            const addonOptionsHtml = [];

            variants.forEach(variant => {
                if (product.stockManagementType >= 1 && variant.color && !processedColors.has(variant.color.id)) {
                    processedColors.add(variant.color.id);
                    colorOptionsHtml.push(`
                    <button class="variant-btn color-option"
                            data-color-id="\${variant.color.id}"
                            data-price="\${variant.color.additionalPrice}">
                        \${variant.color.name}
                    </button>
                `);
                }

                if (product.stockManagementType >= 2 && variant.addon && !processedAddons.has(variant.addon.id)) {
                    processedAddons.add(variant.addon.id);
                    addonOptionsHtml.push(`
                    <button class="variant-btn addon-option"
                            data-addon-id="\${variant.addon.id}"
                            data-price="\${variant.addon.additionalPrice}">
                        \${variant.addon.name}
                    </button>
                `);
                }
            });

            $('#colorOptions').html(colorOptionsHtml.join(''));
            $('#addonOptions').html(addonOptionsHtml.join(''));

            // Nếu là simple product (type 0), update ngay thông tin variant
            if (product.stockManagementType === 0) {
                updateVariantInfo();
            } else {
                attachEventHandlers();
            }
        }

        function attachEventHandlers() {
            // Xử lý click cho màu sắc
            $('.color-option').click(function () {
                $('.color-option').removeClass('selected');
                $(this).addClass('selected');
                selectedColor = $(this);
                updateVariantInfo();
            });

            // Xử lý click cho addon
            $('.addon-option').click(function () {
                $('.addon-option').removeClass('selected');
                $(this).addClass('selected');
                selectedAddon = $(this);
                updateVariantInfo();
            });

            // Xử lý click cho thumbnail
            $('.product-thumbnail').click(function () {
                const newSrc = $(this).attr('src');
                $('.main-product-image').attr('src', newSrc);

                // Cập nhật trạng thái selected
                $('.product-thumbnail').removeClass('selected-thumbnail');
                $(this).addClass('selected-thumbnail');
            });
        }

        function formatShortDate(dateString) {
            const date = new Date(dateString);
            const day = date.getDate().toString().padStart(2, '0');
            const month = (date.getMonth() + 1).toString().padStart(2, '0');
            const year = date.getFullYear();

            return {
                shortDate: `\${day}/\${month}`,
                year: year
            };
        }

        // Format dates for sales
        $('.sale-date').each(function () {
            const startDate = $(this).data('start');
            const endDate = $(this).data('end');
            const start = formatShortDate(startDate);
            const end = formatShortDate(endDate);

            // Chỉ hiển thị năm một lần ở cuối
            $(this).text(`\${start.shortDate} - \${end.shortDate}/\${end.year}`);
        });

        function updateQuantityControls() {
            const quantityInput = $('#quantity');
            const currentQty = parseInt(quantityInput.val());

            // Cập nhật max quantity dựa trên variant được chọn
            if (currentVariant) {
                maxQuantity = currentVariant.stock;
                $('#maxQuantityMsg').text(`Còn \${maxQuantity} sản phẩm`);

                // Enable/disable các nút
                $('#addToCart, #buyNow').prop('disabled', false);
            } else {
                maxQuantity = 0;
                $('#maxQuantityMsg').text('Vui lòng chọn biến thể');

                // Disable các nút
                $('#addToCart, #buyNow').prop('disabled', true);
            }

            // Đảm bảo số lượng không vượt quá tồn kho
            if (currentQty > maxQuantity) {
                quantityInput.val(maxQuantity);
            }
        }

        // Xử lý số lượng
        $('#decreaseQuantity').click(function () {
            const quantityInput = $('#quantity');
            const currentQty = parseInt(quantityInput.val());
            if (currentQty > 1) {
                quantityInput.val(currentQty - 1);
            }
        });

        $('#increaseQuantity').click(function () {
            const quantityInput = $('#quantity');
            const currentQty = parseInt(quantityInput.val());
            if (currentQty < maxQuantity) {
                quantityInput.val(currentQty + 1);
            }
        });

        $('#quantity').on('input', function () {
            let value = parseInt($(this).val());

            // Kiểm tra giá trị hợp lệ
            if (isNaN(value) || value < 1) {
                value = 1;
            } else if (value > maxQuantity) {
                value = maxQuantity;
            }

            $(this).val(value);
        });

        // Xử lý các nút hành động
        $('#addToCart').click(function () {
            if (!currentVariant) {
                alert('Vui lòng chọn biến thể sản phẩm');
                return;
            }
            const quantity = parseInt($('#quantity').val());
            if(quantity ===0) {
             return  $('#quantity').focus();
            }
            $.ajax({
                url: '/cart/add',
                method: 'POST',
                data: {
                    action: "add",
                    variantId: currentVariant.id,
                    productId: ${product.id},
                    quantity: quantity
                },
                success: function (response) {
                    if (response.success) {
                        const quantityInCart = document.querySelectorAll('.bg-danger.cartCount');
                        quantityInCart.forEach(element => {
                            element.textContent = response.cartCount;
                        });
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
                                icon: 'success',
                                title: response.message || 'Đã thêm vào giỏ hàng!'
                            });
                        } else {
                            Toast.fire({
                                icon: 'error',
                                title: response.message || 'Có lỗi xảy ra!'
                            });
                        }

                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi',
                            text: response.message || 'Có lỗi xảy ra, vui lòng thử lại!',
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
        });

        $('#buyNow').click(function () {
            if (!currentVariant) {
                alert('Vui lòng chọn biến thể sản phẩm');
                return;
            }

            $.ajax({
                url: '/cart/add',
                method: 'POST',
                data: {
                    action: "add",
                    variantId: currentVariant.id,
                    productId: ${product.id},
                    quantity: 1
                },
                success: function (response) {
                    if (response.success) {
                        const quantityInCart = document.querySelectorAll('.bg-danger.cartCount');
                        quantityInCart.forEach(element => {
                            element.textContent = response.cartCount;
                        });


                        if (response.success) {
                           window.location.href = '/order'
                        } else {
                            Toast.fire({
                                icon: 'error',
                                title: response.message || 'Có lỗi xảy ra!'
                            });
                        }

                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi',
                            text: response.message || 'Có lỗi xảy ra, vui lòng thử lại!',
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
        });


        function renderStarRating(rating) {
            const fullStars = Math.floor(rating);
            const hasHalfStar = rating % 1 >= 0.5;
            const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

            let starsHtml = '';

            // Thêm sao đầy
            for (let i = 0; i < fullStars; i++) {
                starsHtml += '<i class="fas fa-star"></i>';
            }

            // Thêm nửa sao nếu có
            if (hasHalfStar) {
                starsHtml += '<i class="fas fa-star-half-alt"></i>';
            }

            // Thêm sao rỗng
            for (let i = 0; i < emptyStars; i++) {
                starsHtml += '<i class="far fa-star"></i>';
            }
            return `<span class="star-rating">\${starsHtml}</span>`;
        }

        // Cập nhật hiển thị rating trong reviews
        $('.review-item').each(function () {
            const rating = parseFloat($(this).find('.text-warning').data('rating'));
            $(this).find('.text-warning').html(`
                \${renderStarRating(rating)}
                <span class="ms-1">\${rating.toFixed(1)}/5</span>
            `);
        });

        // Gọi hàm render khi trang load
        renderVariants();
    });

    // xử lí thêm xóa trong danh sách yêu thích
    function toggleWishList(productId) {
        AjaxUtils.toggleWishList(productId);
    }


    function redirectToLogin() {
        let currentURL = encodeURIComponent(window.location.href);
        window.location.href = "/login?redirect=" + currentURL;
    }

</script>

