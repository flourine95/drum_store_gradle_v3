<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<style>
    .card {
        transition: transform 0.2s ease-in-out;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    }

    .btn-group .btn {
        padding: 0.5rem 0.75rem;
        margin: 0 2px;
    }

    .btn-group .btn i {
        font-size: 1.1rem;
    }

    .card-body {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        height: 100%;
    }

    .card-body .btn {
        margin-top: auto;
    }

    .page-link {
        color: var(--bs-primary);
    }

    .page-item.active .page-link {
        background-color: var(--bs-primary);
        border-color: var(--bs-primary);
        color: white;
    }

    .page-link:hover {
        color: white;
        background-color: var(--bs-primary);
        border-color: var(--bs-primary);
    }

    .form-control:focus,
    .form-select:focus {
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
    }

    .card {
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 0.5rem 1rem rgba(var(--bs-primary), 0.15);
    }

    .form-select {
        padding: 0.375rem 0.75rem;
        font-size: 1rem;
        font-weight: 400;
        line-height: 1.5;
        color: #212529;
        background-color: #fff;
        border: 1px solid #ced4da;
        border-radius: 0.25rem;
        transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
    }

    .form-select:focus {
        border-color: #86b7fe;
        outline: 0;
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, .25);
    }

    .form-label {
        margin-bottom: 0.5rem;
        font-weight: 500;
    }

    .pagination {
        margin-bottom: 2rem;
    }

    .page-link {
        color: #333;
        border: 1px solid #dee2e6;
        padding: 0.5rem 0.75rem;
    }

    .page-item.active .page-link {
        background-color: #0d6efd;
        border-color: #0d6efd;
        color: white;
    }

    .page-link:hover {
        background-color: #e9ecef;
        border-color: #dee2e6;
        color: #0d6efd;
    }

    .page-item.disabled .page-link {
        color: #6c757d;
        pointer-events: none;
        background-color: #fff;
        border-color: #dee2e6;
    }

    .product-card {
        position: relative;
        transition: transform 0.2s ease-in-out;
        border: 1px solid rgba(0,0,0,0.1);
        border-radius: var(--card-border-radius);
    }

    .product-card:hover {
        transform: translateY(-5px);
        box-shadow: var(--card-hover-shadow);
    }

    .card-img-wrapper {
        height: 200px;
        overflow: hidden;
        border-radius: var(--border-radius) var(--border-radius) 0 0;
    }

    .card-img-wrapper img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        transition: var(--transition);
    }

    .product-card:hover .card-img-wrapper img {
        transform: scale(1.1);
    }

    .card-title {
        color: var(--text-color);
        font-weight: 500;
        margin-bottom: 1rem;
    }

    .price-section {
        margin: 10px 0;
    }

    .sale-price {
        color: var(--bs-secondary);
        font-size: 1.2rem;
        font-weight: bold;
        margin-bottom: 0;
    }

    .original-price {
        text-decoration: line-through;
        color: #999;
        font-size: 0.9rem;
    }

    .regular-price {
        color: var(--bs-secondary);
        font-size: 1.2rem;
        font-weight: bold;
    }

    .product-meta {
        display: flex;
        justify-content: space-between;
        font-size: 0.9rem;
        color: #666;
    }

    .discount-badge {
        position: absolute;
        top: 10px;
        right: 10px;
        background-color: var(--bs-secondary);
        color: white;
        padding: 4px 8px;
        border-radius: 4px;
        font-weight: bold;
    }

    .rating-section {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    .stars {
        color: #ffc107;
        font-size: 0.9rem;
    }

    .stock-info {
        margin-top: 0.5rem;
    }

    .in-stock {
        color: #28a745;
    }

    .out-of-stock {
        color: var(--bs-secondary);
    }

    .product-tags {
        margin-top: 10px;
        display: flex;
        gap: 5px;
    }

    .category-tag, .brand-tag {
        font-size: 0.8rem;
        padding: 2px 8px;
        border-radius: 12px;
        background-color: #f8f9fa;
    }

    .category-tag {
        color: var(--bs-primary);
        border: 1px solid var(--bs-primary);
    }

    .brand-tag {
        color: var(--bs-secondary);
        border: 1px solid var(--bs-secondary);
    }
    .product-card {
    background: var(--card-bg);
    border-radius: var(--card-radius);
    border: var(--card-border);
    box-shadow: var(--card-shadow);
    transition: all 0.3s ease;
    overflow: hidden;
    cursor: pointer;
}

.product-card:hover {
    transform: var(--card-hover-transform);
    box-shadow: var(--card-hover-shadow);
}

/* Image Container */
.card-img-wrapper {
    position: relative;
    padding-top: 100%; /* 1:1 Aspect Ratio */
    overflow: hidden;
    background: #f5f5f5;
}

.card-img-wrapper img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    transition: transform 0.3s ease;
}

.product-card:hover .card-img-wrapper img {
    transform: scale(1.05);
}

/* Discount Badge */
.discount-badge {
    position: absolute;
    top: 12px;
    right: 12px;
    background: var(--badge-bg);
    color: var(--badge-color);
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: 600;
    font-size: 0.85rem;
    z-index: 1;
}

/* Card Body */
.card-body {
    padding: 1rem;
}

.card-title {
    font-size: 1rem;
    font-weight: 500;
    margin-bottom: 0.5rem;
    line-height: 1.4;
    height: 2.8em;
    overflow: hidden;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
}

/* Price Section */
.price-section {
    margin: 0.75rem 0;
}

.sale-price {
    color: var(--price-sale);
    font-size: 1.25rem;
    font-weight: 700;
    margin: 0;
}

.original-price {
    color: var(--price-original);
    font-size: 0.9rem;
    text-decoration: line-through;
    margin: 0;
}

.regular-price {
    color: var(--price-regular);
    font-size: 1.25rem;
    font-weight: 700;
    margin: 0;
}

/* Rating Section */
.rating-section {
    display: flex;
    align-items: center;
    gap: 8px;
    margin-bottom: 0.5rem;
}

.stars {
    color: var(--rating-star);
    font-size: 0.9rem;
}

.rating-count {
    color: var(--rating-count);
    font-size: 0.85rem;
}

/* Stock Info */
.stock-info {
    font-size: 0.85rem;
    margin-bottom: 0.5rem;
}

.in-stock {
    color: var(--stock-in);
}

.out-of-stock {
    color: var(--stock-out);
}

/* Tags */
.product-tags {
    display: flex;
    gap: 6px;
    flex-wrap: wrap;
    margin-top: 0.75rem;
}

.category-tag,
.brand-tag {
    background: var(--tag-bg);
    color: var(--tag-color);
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 0.75rem;
    font-weight: 500;
}

/* Product Meta */
.product-meta {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 0.5rem;
    padding-top: 0.5rem;
    border-top: 1px solid rgba(0, 0, 0, 0.05);
}

/* Responsive Adjustments */
@media (max-width: 768px) {
    .card-title {
        font-size: 0.95rem;
    }

    .sale-price,
    .regular-price {
        font-size: 1.1rem;
    }

    .product-card {
        margin-bottom: 1rem;
    }
}

.badges {
    position: absolute;
    top: 12px;
    right: 12px;
    display: flex;
    flex-direction: row;
    gap: 8px;
    z-index: 1;
}

.featured-badge {
    background-color: #ffc107;
    color: #000;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: 600;
    font-size: 0.85rem;
    display: flex;
    align-items: center;
    gap: 4px;
    order: 2;
}

.discount-badge {
    position: static;
    background-color: #dc3545;
    color: white;
    padding: 4px 8px;
    border-radius: 4px;
    font-weight: 600;
    font-size: 0.85rem;
    order: 1;
}

.product-card {
    cursor: default;
}

.product-card:hover {
    transform: translateY(-5px);
}
</style>

<main>
    <div class="container my-3">
        <div class="row">
            <div class="col-lg-3 mb-4">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Bộ lọc</h5>
                    </div>
                    <div class="card-body">
                        <!-- Form tìm kiếm -->
                        <form action="${pageContext.request.contextPath}/products" method="get" id="filterForm">
                            <div class="mb-3">
                                <label for="search" class="form-label">Tìm kiếm</label>
                                <input type="text" class="form-control" id="search" name="search"
                                       value="${searchKeyword}" placeholder="Nhập từ khóa...">
                            </div>

                            <!-- Select danh mục -->
                            <div class="mb-3">
                                <label for="category" class="form-label">Danh mục</label>
                                <select class="form-select" id="category" name="category" onchange="submitForm()">
                                    <option value="">Tất cả danh mục</option>
                                    <c:forEach var="category" items="${categories}">
                                        <option value="${category.id}"
                                            ${category.id == selectedCategory ? 'selected' : ''}>
                                                ${category.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Select thương hiệu -->
                            <div class="mb-3">
                                <label for="brand" class="form-label">Thương hiệu</label>
                                <select class="form-select" id="brand" name="brand" onchange="submitForm()">
                                    <option value="">Tất cả thương hiệu</option>
                                    <c:forEach var="brand" items="${brands}">
                                        <option value="${brand.id}"
                                            ${brand.id == selectedBrand ? 'selected' : ''}>
                                                ${brand.name}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Khoảng giá -->
                            <div class="mb-3">
                                <label class="form-label">Khoảng giá</label>
                                <select class="form-select" name="priceRange" onchange="submitForm()">
                                    <option value="">Tất cả giá</option>
                                    <option value="0-1000000" ${selectedPriceRange == '0-1000000' ? 'selected' : ''}>
                                        Dưới 1 triệu
                                    </option>
                                    <option value="1000000-5000000" ${selectedPriceRange == '1000000-5000000' ? 'selected' : ''}>
                                        1 triệu - 5 triệu
                                    </option>
                                    <option value="5000000-10000000" ${selectedPriceRange == '5000000-10000000' ? 'selected' : ''}>
                                        5 triệu - 10 triệu
                                    </option>
                                    <option value="10000000-100000000" ${selectedPriceRange == '10000000-100000000' ? 'selected' : ''}>
                                        Trên 10 triệu
                                    </option>
                                </select>
                            </div>

                            <!-- Sắp xếp -->
                            <div class="mb-3">
                                <label for="sortBy" class="form-label">Sắp xếp</label>
                                <select class="form-select" id="sortBy" name="sortBy" onchange="submitForm()">
                                    <option value="">Mặc định</option>
                                    <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>
                                        Tên A-Z
                                    </option>
                                    <option value="name_desc" ${sortBy == 'name_desc' ? 'selected' : ''}>
                                        Tên Z-A
                                    </option>
                                    <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>
                                        Giá tăng dần
                                    </option>
                                    <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>
                                        Giá giảm dần
                                    </option>
                                </select>
                            </div>

                            <!-- Nút reset filter -->
                            <button type="button" class="btn btn-secondary w-100" onclick="resetFilter()">
                                Xóa bộ lọc
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Phần danh sách sản phẩm -->
            <div class="col-lg-9">
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach items="${products}" var="product">
                        <div class="col-md-4 mb-4">
                            <div class="card product-card h-100" 
                                 onclick="goToProduct(${product.id}, event)" 
                                 title="Nhấn Ctrl + Click để mở trong tab mới">
                                <div class="card-img-wrapper">
                                    <img src="${pageContext.request.contextPath}/assets/images/products/${product.mainImage}" 
                                         class="card-img-top" 
                                         alt="${product.name}">
                                    <div class="badges">
                                        <c:if test="${product.discountPercent > 0}">
                                            <div class="discount-badge">
                                                -<fmt:formatNumber value="${product.discountPercent}" type="number" maxFractionDigits="0"/>%
                                            </div>
                                        </c:if>
                                        <c:if test="${product.featured}">
                                            <div class="featured-badge">
                                                <i class="bi bi-star-fill"></i> Nổi bật
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="card-body">
                                    <h5 class="card-title text-truncate">${product.name}</h5>
                                    
                                    <div class="price-section">
                                        <c:choose>
                                            <c:when test="${product.discountPercent > 0}">
                                                <p class="sale-price">
                                                    <fmt:formatNumber value="${product.lowestSalePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </p>
                                                <p class="original-price">
                                                    <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </p>
                                            </c:when>
                                            <c:otherwise>
                                                <p class="regular-price">
                                                    <fmt:formatNumber value="${product.basePrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                                                </p>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div class="product-meta">
                                        <div class="rating-section">
                                            <div class="stars">
                                                <c:set var="rating" value="${product.averageRating}"/>
                                                <c:forEach begin="1" end="5" var="i">
                                                    <c:choose>
                                                        <c:when test="${i <= Math.floor(rating)}">
                                                            <i class="bi bi-star-fill"></i>
                                                        </c:when>
                                                        <c:when test="${i == Math.ceil(rating) && rating % 1 != 0}">
                                                            <i class="bi bi-star-half"></i>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <i class="bi bi-star"></i>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                                <span class="rating-text">
                                                    (${product.averageRating > 0 ? String.format("%.1f", product.averageRating) : "Chưa có đánh giá"})
                                                </span>
                                            </div>
                                            <span class="review-count">
                                                ${product.totalReviews} đánh giá
                                            </span>
                                        </div>
                                        <div class="view-count">
                                            <i class="bi bi-eye"></i> ${product.totalViews}
                                        </div>
                                    </div>

                                    <div class="product-tags">
                                        <span class="category-tag">${product.categoryName}</span>
                                        <span class="brand-tag">${product.brandName}</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Phân trang -->
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <!-- Nút Previous -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="#" onclick="goToPage(${currentPage - 1})"
                                   aria-label="Previous">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>

                        <!-- Hiển thị các số trang -->
                        <c:choose>
                            <c:when test="${totalPages <= 5}">
                                <!-- Nếu tổng số trang <= 5, hiển thị tất cả -->
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Nếu tổng số trang > 5, hiển thị thông minh -->
                                <c:choose>
                                    <c:when test="${currentPage <= 3}">
                                        <!-- Hiển thị 1 2 3 4 5 ... last -->
                                        <c:forEach begin="1" end="5" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                        <li class="page-item">
                                            <a class="page-link" href="#"
                                               onclick="goToPage(${totalPages})">${totalPages}</a>
                                        </li>
                                    </c:when>
                                    <c:when test="${currentPage >= totalPages - 2}">
                                        <!-- Hiển thị 1 ... last-4 last-3 last-2 last-1 last -->
                                        <li class="page-item">
                                            <a class="page-link" href="#" onclick="goToPage(1)">1</a>
                                        </li>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                        <c:forEach begin="${totalPages - 4}" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                                            </li>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Hiển thị 1 ... current-1 current current+1 ... last -->
                                        <li class="page-item">
                                            <a class="page-link" href="#" onclick="goToPage(1)">1</a>
                                        </li>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                        <c:forEach begin="${currentPage - 1}" end="${currentPage + 1}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="#" onclick="goToPage(${i})">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item disabled"><span class="page-link">...</span></li>
                                        <li class="page-item">
                                            <a class="page-link" href="#"
                                               onclick="goToPage(${totalPages})">${totalPages}</a>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>

                        <!-- Nút Next -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="#" onclick="goToPage(${currentPage + 1})" aria-label="Next">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>

            </div>
        </div>
    </div>
</main>

<script>
    function handleSearch(event) {
        event.preventDefault();
        const searchValue = document.getElementById('searchInput').value;
        updateQueryParams({search: searchValue, page: 1});
    }

    function handleSort(value) {
        updateQueryParams({sortBy: value, page: 1});
    }

    function goToPage(page) {
        updateQueryParams({page: page});
    }

    function removeFilter(filterType) {
        const params = new URLSearchParams(window.location.search);
        params.delete(filterType);
        params.set('page', '1');
        window.location.search = params.toString();
    }

    function resetFilter() {
        window.location.href = `${pageContext.request.contextPath}/products`;
    }

    function updateQueryParams(newParams) {
        const params = new URLSearchParams(window.location.search);

        Object.entries(newParams).forEach(([key, value]) => {
            if (value) {
                params.set(key, value);
            } else {
                params.delete(key);
            }
        });

        window.location.search = params.toString();
    }

    function submitForm() {
        document.getElementById('filterForm').submit();
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





