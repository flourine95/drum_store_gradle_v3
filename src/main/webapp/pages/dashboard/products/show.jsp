<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<div class="container-fluid">
    <div class="row">
        <!-- Thông tin cơ bản -->
        <div class="col-md-8">
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">Thông tin cơ bản</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Tên sản phẩm:</label>
                            <input type="text" value="${product.name}" class="form-control" readonly>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-bold">Giá cơ bản:</label>
                            <input type="text" value="<fmt:formatNumber value='${product.basePrice}' type='number' groupingUsed='true'/>đ" class="form-control" readonly>
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label fw-bold">Mô tả:</label>
                            <textarea class="form-control" rows="3" readonly>${product.description}</textarea>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Danh mục:</label>
                            <input type="text" value="${product.categoryName}" class="form-control" readonly>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Thương hiệu:</label>
                            <input type="text" value="${product.brandName}" class="form-control" readonly>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Loại quản lý kho:</label>
                            <input type="text" value="${
                                product.stockManagementType == 0 ? 'Đơn giản' :
                                product.stockManagementType == 1 ? 'Theo màu sắc' :
                                product.stockManagementType == 2 ? 'Theo phụ kiện' :
                                'Theo màu sắc và phụ kiện'
                            }" class="form-control" readonly>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Thống kê -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">Thống kê</h5>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <div class="card bg-primary text-white">
                                <div class="card-body">
                                    <h6>Tổng tồn kho</h6>
                                    <h3>${product.totalStock}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-success text-white">
                                <div class="card-body">
                                    <h6>Lượt xem</h6>
                                    <h3>${product.totalViews}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-info text-white">
                                <div class="card-body">
                                    <h6>Đánh giá</h6>
                                    <h3><fmt:formatNumber value="${product.averageRating}" type="number" pattern="0.0"/> ⭐</h3>
                                    <small>${product.totalReviews} đánh giá</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3 mb-3">
                            <div class="card bg-warning text-white">
                                <div class="card-body">
                                    <h6>Biến thể</h6>
                                    <h3>${product.totalVariants}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="col-md-4">
            <!-- Trạng thái -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">Trạng thái</h5>
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Trạng thái sản phẩm:</label>
                        <div class="badge ${product.status == 1 ? 'bg-success' : 'bg-danger'} fs-6">
                            ${product.status == 1 ? 'Đang hoạt động' : 'Đã khóa'}
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Sản phẩm nổi bật:</label>
                        <div class="badge ${product.isFeatured ? 'bg-warning' : 'bg-secondary'} fs-6">
                            ${product.isFeatured ? 'Có' : 'Không'}
                        </div>
                    </div>
                    <div>
                        <label class="form-label fw-bold">Ngày tạo:</label>
                        <div>${product.createdAt}</div>
                    </div>
                </div>
            </div>

            <!-- Khuyến mãi đang áp dụng -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="card-title mb-0">Khuyến mãi đang áp dụng</h5>
                </div>
                <div class="card-body">
                    <c:choose>
                        <c:when test="${not empty product.sales}">
                            <c:forEach items="${product.sales}" var="sale">
                                <div class="alert alert-success mb-2">
                                    <h6 class="alert-heading">${sale.name}</h6>
                                    <p class="mb-0">Giảm ${sale.discountPercentage}%</p>
                                    <small>Từ ${sale.startDate} đến ${sale.endDate}</small>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-info mb-0">
                                Không có khuyến mãi nào đang áp dụng
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Hình ảnh sản phẩm -->
    <div class="card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="card-title mb-0">Hình ảnh sản phẩm</h5>
        </div>
        <div class="card-body">
            <div class="row">
                <c:forEach items="${product.images}" var="image">
                    <div class="col-md-3 mb-4">
                        <div class="card">
                            <img src="${pageContext.request.contextPath}/assets/images/products/${image.image}"
                                 class="card-img-top" alt="Product image"
                                 style="height: 200px; object-fit: cover;">
                            <div class="card-body">
                                <c:if test="${image.isMain}">
                                    <span class="badge bg-primary">Ảnh chính</span>
                                </c:if>
                                <small class="text-muted">Thứ tự: ${image.sortOrder}</small>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Biến thể sản phẩm -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="card-title mb-0">Biến thể sản phẩm</h5>
        </div>
        <div class="card-body">
            <table id="variantsTable" class="table table-striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Màu sắc</th>
                        <th>Phụ kiện</th>
                        <th>Tồn kho</th>
                        <th>Trạng thái</th>
                        <th>Hình ảnh</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${product.variants}" var="variant">
                        <tr>
                            <td>${variant.id}</td>
                            <td>${variant.colorName}</td>
                            <td>${variant.addonName}</td>
                            <td>${variant.stock}</td>
                            <td>
                                <span class="badge ${variant.status == 1 ? 'bg-success' : 'bg-danger'}">
                                    ${variant.status == 1 ? 'Đang bán' : 'Ngừng bán'}
                                </span>
                            </td>
                            <td>
                                <c:if test="${not empty variant.variantImage}">
                                    <img src="${pageContext.request.contextPath}/assets/images/data/${variant.variantImage}" 
                                         style="width: 50px; height: 50px; object-fit: cover;">
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Đánh giá gần đây -->
    <div class="card mb-4">
        <div class="card-header">
            <h5 class="card-title mb-0">Đánh giá gần đây</h5>
        </div>
        <div class="card-body">
            <c:choose>
                <c:when test="${not empty product.reviews}">
                    <div class="row">
                        <c:forEach items="${product.reviews}" var="review">
                            <div class="col-md-6 mb-3">
                                <div class="card">
                                    <div class="card-body">
                                        <div class="d-flex align-items-center mb-2">
                                            <img src="${review.userAvatar}" 
                                                 class="rounded-circle me-2" 
                                                 style="width: 40px; height: 40px; object-fit: cover;">
                                            <div>
                                                <h6 class="mb-0">${review.userName}</h6>
                                                <small class="text-muted">
                                                    ${review.createdAt}
                                                </small>
                                            </div>
                                        </div>
                                        <div class="mb-2">
                                            ${'⭐'.repeat(review.rating)}
                                        </div>
                                        <p class="card-text">${review.content}</p>
                                        <c:if test="${not empty review.reviewImages}">
                                            <div class="review-images">
                                                <c:forEach items="${review.reviewImages}" var="image">
                                                    <img src="${pageContext.request.contextPath}/assets/images/data/${image}" 
                                                         class="img-thumbnail" 
                                                         style="width: 80px; height: 80px; object-fit: cover;">
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info">
                        Chưa có đánh giá nào
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="mb-4">
        <a href="${pageContext.request.contextPath}/dashboard/products" class="btn btn-secondary">
            <i class="bi bi-arrow-left"></i> Quay lại
        </a>
        <a href="${pageContext.request.contextPath}/dashboard/products/${product.id}/edit" class="btn btn-primary">
            <i class="bi bi-pencil"></i> Chỉnh sửa
        </a>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#variantsTable').DataTable({
        responsive: true,
        pageLength: 10,
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/vi.json'
        }
    });
});
</script>

