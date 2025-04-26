<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
  <title>Quản lý Quyền</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
<div class="container mt-4">
  <div class="card">
    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
      <h4 class="mb-0"><i class="fas fa-key me-2"></i>Quản lý Quyền</h4>
      <a href="${pageContext.request.contextPath}/dashboard/permissions?action=create" class="btn btn-light">
        <i class="fas fa-plus-circle me-2"></i>Thêm Quyền mới
      </a>
    </div>
    <div class="card-body">
      <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
          <i class="fas fa-check-circle me-2"></i>${success}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>
      <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <i class="fas fa-exclamation-circle me-2"></i>${error}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>
      <c:if test="${not empty errors.general}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
          <i class="fas fa-exclamation-circle me-2"></i>${errors.general}
          <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
      </c:if>

      <div class="table-responsive">
        <table class="table table-striped table-hover">
          <thead class="table-light">
          <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Mô tả</th>
            <th>Thao tác</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach var="permission" items="${permissions}">
            <tr>
              <td>${permission.id}</td>
              <td>${permission.name}</td>
              <td>${permission.description}</td>
              <td>
                <div class="btn-group" role="group">
                  <a href="${pageContext.request.contextPath}/dashboard/permissions?action=edit&id=${permission.id}"
                     class="btn btn-sm btn-primary" title="Sửa">
                    <i class="fas fa-edit"></i>
                  </a>
                  <button type="button" onclick="deletePermission(${permission.id})" 
                          class="btn btn-sm btn-danger" title="Xóa">
                    <i class="fas fa-trash"></i>
                  </button>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<form id="deleteForm" method="POST" style="display: none;">
  <input type="hidden" name="action" value="delete">
  <input type="hidden" name="id" id="deleteId">
</form>

<script>
  function deletePermission(id) {
    if (confirm('Bạn có chắc chắn muốn xóa quyền này?')) {
      document.getElementById('deleteId').value = id;
      document.getElementById('deleteForm').submit();
    }
  }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>