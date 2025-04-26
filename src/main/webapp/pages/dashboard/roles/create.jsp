<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Thêm Vai trò mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h4 class="mb-0"><i class="fas fa-plus-circle me-2"></i>Thêm Vai trò mới</h4>
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

            <form method="POST" action="${pageContext.request.contextPath}/dashboard/roles">
                <input type="hidden" name="action" value="store">

                <div class="mb-3">
                    <label for="name" class="form-label">Tên vai trò <span class="text-danger">*</span></label>
                    <input type="text" class="form-control ${not empty errors.name ? 'is-invalid' : ''}" 
                           id="name" name="name" value="${oldInput.name}" required>
                    <c:if test="${not empty errors.name}">
                        <div class="invalid-feedback">${errors.name}</div>
                    </c:if>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Mô tả</label>
                    <textarea class="form-control ${not empty errors.description ? 'is-invalid' : ''}" 
                              id="description" name="description" rows="3">${oldInput.description}</textarea>
                    <c:if test="${not empty errors.description}">
                        <div class="invalid-feedback">${errors.description}</div>
                    </c:if>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="${pageContext.request.contextPath}/dashboard/roles" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i>Lưu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>