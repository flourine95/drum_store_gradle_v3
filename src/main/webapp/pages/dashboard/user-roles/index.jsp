<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid px-4">
  <h1 class="mt-4">Quản lý vai trò người dùng</h1>

  <!-- Search and Filter -->
  <div class="card mb-4">
    <div class="card-body">
      <form method="GET" action="${pageContext.request.contextPath}/dashboard/user-roles" class="row g-3">
        <div class="col-md-4">
          <input type="text" class="form-control" id="search" name="search"
                 placeholder="Tìm kiếm theo email hoặc tên..." value="${search}">
        </div>
        <div class="col-md-4">
          <select class="form-select" id="role" name="role">
            <option value="">Tất cả vai trò</option>
            <c:forEach items="${roles}" var="role">
              <option value="${role.id}" ${roleFilter == role.id ? 'selected' : ''}>
                  ${role.name}
              </option>
            </c:forEach>
          </select>
        </div>
        <div class="col-md-4">
          <button type="submit" class="btn btn-primary">Tìm kiếm</button>
        </div>
      </form>
    </div>
  </div>

  <!-- Flash Messages -->
  <c:if test="${not empty sessionScope.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.success}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>
  <c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <!-- Users Role Matrix -->
  <div class="card mb-4">
    <div class="card-header">
      <i class="fas fa-table me-1"></i>
      Danh sách người dùng và vai trò
    </div>
    <div class="card-body">
      <div class="table-responsive">
        <table class="table table-bordered table-hover">
          <thead class="table-light">
          <tr>
            <th>Email</th>
            <th>Họ và tên</th>
            <c:forEach items="${roles}" var="role">
              <th>${role.name}</th>
            </c:forEach>
            <th>Thao tác</th>
          </tr>
          </thead>
          <tbody>
          <c:forEach items="${matrixList}" var="matrix">
            <tr>
              <td>${matrix.userEmail}</td>
              <td>${matrix.userFullName}</td>
              <c:forEach items="${roles}" var="role">
                <td class="text-center">
                  <c:if test="${matrix.roleCheckboxMap[role.id]}">
                    <i class="fas fa-check text-success"></i>
                  </c:if>
                </td>
              </c:forEach>
              <td>
                <a href="${pageContext.request.contextPath}/dashboard/user-roles?action=edit&id=${matrix.userId}"
                   class="btn btn-primary btn-sm">
                  <i class="fas fa-edit"></i> Sửa
                </a>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>