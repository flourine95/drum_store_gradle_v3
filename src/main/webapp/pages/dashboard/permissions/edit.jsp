<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-edit me-2"></i>Sửa Quyền</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty errors}">
                <div class="alert alert-danger">
                    <ul class="mb-0">
                        <c:forEach var="error" items="${errors}">
                            <li>${error.value}</li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <form method="POST" action="${pageContext.request.contextPath}/dashboard/permissions">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="${permission.id}">

                <div class="mb-3">
                    <label for="name" class="form-label">Tên quyền <span class="text-danger">*</span></label>
                    <input type="text" class="form-control ${not empty errors.name ? 'is-invalid' : ''}"
                           id="name" name="name" value="${permission.name}" required>
                    <c:if test="${not empty errors.name}">
                        <div class="invalid-feedback">${errors.name}</div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả</label>
                    <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}"
                              id="description" name="description" rows="3">${permission.description}</textarea>
                    <c:if test="${not empty errors.description}">
                        <div class="invalid-feedback">${errors.description}</div>
                    </c:if>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/dashboard/permissions" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

