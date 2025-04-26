<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section id="brandForm">
    <input type="hidden" name="id" value="${brand.id}">
    <section class="row mb-3">
        <div class="col-md-4">
            <img src="/assets/images/data/${brand.image}"
                 alt="${brand.image}"
                 class="img-fluid brand-image">
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Tên:</label>
                    <input type="text" value="${brand.name}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Ảnh:</label>
                    <input type="text" value="${brand.image}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Mô tả:</label>
                    <textarea class="form-control" readonly>${brand.description}</textarea>
                </div>

            </div>
        </div>
    </section>

    <div class="form-actions">
        <a href="${pageContext.request.contextPath}/dashboard/categories" class="btn btn-secondary">Quay lại</a>
    </div>
</section>

<style>
    .brand-image {
        width: 400px;
        height: 400px;
        object-fit: cover;
    }

    .form-actions {
        margin-top: 20px;
    }
</style>
