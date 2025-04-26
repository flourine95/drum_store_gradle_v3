<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<form id="categoryForm" action="${pageContext.request.contextPath}/dashboard/categories/${category.id}" method="POST">
    <input type="hidden" name="_method" value="PUT">
    <input type="hidden" name="csrf_token" value="${csrfToken}">
    <section class="row mb-3">
        <div class="col-md-4">
            <img src="/assets/images/data/${category.image}"
                 alt="${category.image}"
                 class="img-fluid category-image">
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Tên:</label>
                    <input type="text" name="name" value="${category.name}" class="form-control">
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Ảnh:</label>
                    <input type="text" name="image" value="${category.image}" class="form-control">
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Mô tả:</label>
                    <textarea name="description" class="form-control">${category.description}"</textarea>
                </div>

            </div>
        </div>
    </section>

    <div class="form-actions">
        <button type="submit" class="btn btn-success">Lưu thay đổi</button>
        <a href="${pageContext.request.contextPath}/dashboard/categories" class="btn btn-secondary">Quay lại</a>
    </div>
</form>

<style>
    .category-image {
        width: 400px;
        height: 400px;
        object-fit: cover;
    }

    .form-actions {
        margin-top: 20px;
    }

    .btn-group {
        gap: 5px;
    }
</style>