<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section id="categoryForm">
    <input type="hidden" name="id" value="${category.id}">
    <section class="row mb-3">
        <div class="col-md-4">
            <img src="/assets/images/data/${category.image}"
                 alt="${category.image}"
                 class="img-fluid category-image">
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Họ tên:</label>
                    <input type="text" value="${category.name}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Email:</label>
                    <input type="text" value="${category.image}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Mô tả:</label>
                    <textarea class="form-control" readonly>${category.description}</textarea>
                </div>

            </div>
        </div>
    </section>

    <div class="form-actions">
        <a href="${pageContext.request.contextPath}/dashboard/categories" class="btn btn-secondary">Quay lại</a>
    </div>
</section>

<style>
    .category-image {
        width: 400px;
        height: 400px;
        object-fit: cover;
    }

    .form-actions {
        margin-top: 20px;
    }
</style>
<script>
    $(document).ready(function () {
        $('#addressTable').DataTable({
            responsive: true, // Bảng responsive
            paging: true,      // Bật phân trang
            searching: true,   // Bật tìm kiếm
            ordering: true,    // Cho phép sắp xếp
            lengthMenu: [5, 10, 20, 100] // Tùy chọn số hàng hiển thị
        });
    });
</script>
