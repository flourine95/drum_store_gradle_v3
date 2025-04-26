<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid px-4">
  <h1 class="mt-4">Chỉnh sửa vai trò người dùng</h1>
  <ol class="breadcrumb mb-4">
    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/dashboard/user-roles">Quản lý vai trò người dùng</a></li>
    <li class="breadcrumb-item active">Chỉnh sửa</li>
  </ol>

  <div class="card mb-4">
    <div class="card-header">
      <i class="fas fa-user-edit me-1"></i>
      Thông tin người dùng
    </div>
    <div class="card-body">
      <div class="row mb-3">
        <div class="col-md-6">
          <p><strong>Email:</strong> ${user.email}</p>
        </div>
        <div class="col-md-6">
          <p><strong>Họ và tên:</strong> ${user.fullname}</p>
        </div>
      </div>

      <form action="${pageContext.request.contextPath}/dashboard/user-roles?action=update" method="POST">
        <input type="hidden" name="userId" value="${user.id}">

        <div class="mb-3">
          <label class="form-label">Vai trò</label>
          <div class="row">
            <c:forEach items="${allRoles}" var="role">
              <div class="col-md-4 mb-2">
                <div class="form-check">
                  <input class="form-check-input" type="checkbox"
                         name="roles[]" value="${role.id}" id="role${role.id}"
                  <c:forEach var="ur" items="${userRoles}">
                         <c:if test="${ur.id == role.id}">checked</c:if>
                  </c:forEach>
                  >
                  <label class="form-check-label" for="role${role.id}">
                      ${role.name}
                  </label>
                </div>
              </div>
            </c:forEach>
          </div>
        </div>

        <div class="mb-3">
          <button type="submit" class="btn btn-primary">
            <i class="fas fa-save"></i> Lưu thay đổi
          </button>
          <a href="${pageContext.request.contextPath}/dashboard/user-roles" class="btn btn-secondary">
            <i class="fas fa-times"></i> Hủy
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // Add any client-side validation or UI enhancement code here
  });
</script>