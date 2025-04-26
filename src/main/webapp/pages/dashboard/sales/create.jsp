<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<form id="createCategoryForm" action="${pageContext.request.contextPath}/dashboard/categories" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="_method" value="PUT">
    <input type="hidden" name="csrf_token" value="${csrfToken}">
    <section class="row mb-3">
        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Tên:</label>
                    <input type="text" name="name" class="form-control" required>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Ảnh:</label>
                    <input type="text" name="image" class="form-control" required>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Mô tả:</label>
                    <textarea name="description" class="form-control" required></textarea>
                </div>

            </div>
        </div>
    </section>

    <div class="form-actions">
        <button type="submit" class="btn btn-primary">Tạo mới</button>
        <a href="${pageContext.request.contextPath}/dashboard/categories" class="btn btn-secondary">Hủy</a>
    </div>
</form>

<style>
    .form-actions {
        margin-top: 20px;
    }
</style>