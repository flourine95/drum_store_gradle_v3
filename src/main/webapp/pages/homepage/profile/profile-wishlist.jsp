<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .wishlist-card {
        background: #fff;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        overflow: hidden;
    }

    .wishlist-item {
        padding: 20px;
        border-bottom: 1px solid #eee;
        transition: 0.3s;
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 20px;
    }

    .wishlist-item:last-child {
        border-bottom: none;
    }

    .product-img-container {
        position: relative;
        width: 150px;
        margin-right: 20px;
    }

    .product-img {
        width: 100%;
        height: auto;
        border-radius: 10px;
        transition: transform 0.3s ease;
    }

    .product-img:hover {
        transform: scale(1.05);
    }

    .badges {
        position: absolute;
        top: 8px;
        right: 8px;
        display: flex;
        flex-direction: column;
        align-items: flex-end;
    }

    .discount-badge, .featured-badge {
        background: red;
        color: white;
        padding: 4px 8px;
        border-radius: 5px;
        font-size: 0.7rem;
        font-weight: bold;
        margin-bottom: 5px;
    }

    .product-info {
        flex: 1;
        text-align: center;
    }

    .product-name {
        font-size: 1.1rem;
        font-weight: 600;
        color: #333;
        text-decoration: none;
        transition: color 0.3s ease;
        margin-bottom: 10px;
    }

    .product-name:hover {
        color: red;
    }

    .price-container {
        display: flex;
        flex-direction: row;
        gap: 10px;
        justify-content: center;
    }

    .sale-price {
        color: red;
        font-size: 1.2rem;
        font-weight: bold;
    }

    .original-price {
        color: gray;
        font-size: 1rem;
        text-decoration: line-through;
    }

    .regular-price {
        font-size: 1.2rem;
        font-weight: bold;
        color: #333;
    }

    .button-row {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 20px;
    }

    .button-group {
        display: flex;
        flex-direction: row;
        gap: 5px;
    }

    .button-group button {
        padding:8px
    }

    .stock-badge {
        padding: 5px 10px;
        border-radius: 5px;
    }

    .in-stock {
        background-color: #28a745;
        color: white;
        padding: 6px;
    }
</style>

<div class="col-md-9">
    <div class="wishlist-card animate__animated animate__fadeInRight">
        <div class="card-header p-4">
            <h5 class="mb-0">
                <i class="bi bi-heart me-2"></i>
                SẢN PHẨM YÊU THÍCH
            </h5>
        </div>

        <div class="card-body p-0">
            <!-- Wishlist Item -->
            <c:forEach items="${products}" var="product">
                <div class="wishlist-item" data-product-id="${product.id}">
                    <div class="product-img-container">
                        <img src="${pageContext.request.contextPath}/assets/images/products/${product.mainImage}" alt="Product" class="product-img">
                        <div class="badges">
                            <c:if test="${product.discountPercent > 0}">
                                <div class="discount-badge">
                                    -<fmt:formatNumber value="${product.discountPercent}" type="number" maxFractionDigits="0"/>%
                                </div>
                            </c:if>
                            <c:if test="${product.isFeatured}">
                                <div class="featured-badge">
                                    <i class="bi bi-star-fill"></i> Nổi bật
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <div class="product-info">
                        <a href="${pageContext.request.contextPath}/product/${product.id}" class="product-name">${product.name}</a>
                        <c:choose>
                            <c:when test="${product.discountPercent > 0}">
                                <div class="price-container">
                                    <p class="sale-price">
                                        <fmt:formatNumber value="${product.lowestSalePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </p>
                                    <p class="original-price">
                                        <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                    </p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <p class="regular-price">
                                    <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                </p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="button-row">
                        <span class="stock-badge in-stock">Còn hàng</span>
                        <div class="button-group">
                            <button class="btn btn-primary btn-sm" onclick="goToProduct(${product.id})">
                                <i class="bi bi-cart-plus me-2"></i>Xem chi tiết
                            </button>
                            <button class="btn btn-danger btn-sm btn-remove" onclick="removeFromWishList(${product.id})">
                                <i class="bi bi-trash me-2"></i>Xóa
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // Animation khi xóa sản phẩm
        $('.btn-remove').click(function() {
            $(this).closest('.wishlist-item').addClass('animate__animated animate__fadeOutRight');
        });

        // Hiệu ứng hover cho ảnh sản phẩm
        $('.product-img').hover(
            function() {
                $(this).css('transform', 'scale(1.05)');
            },
            function() {
                $(this).css('transform', 'scale(1)');
            }
        );
    });

    function quickAddToCart(productId) {
        AjaxUtils.addToCart(productId, 1, null, true);
    }

    function removeFromWishList(productId) {
        AjaxUtils.toggleWishList(productId).then(function(data) {
            const $wishlistItem = $('.wishlist-item[data-product-id=' + productId + ']');
            $wishlistItem.addClass('animate__animated animate__fadeOutRight');
            setTimeout(() => {
                $wishlistItem.remove();
            }, 500);
        }).catch(function(error) {
            console.error("Lỗi trong removeFromWishList:", error);
        });
    }

    function goToProduct(productId, event) {
        const url = '${pageContext.request.contextPath}/product/' + productId;

        if (event.ctrlKey || event.metaKey) { // metaKey cho macOS
            window.open(url, '_blank');
        } else {
            window.location.href = url;
        }
    }
</script>