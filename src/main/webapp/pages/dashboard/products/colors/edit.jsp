<%@ page contentType="text/html;charset=UTF-8" %>
<form id="editColorForm" action="${pageContext.request.contextPath}/dashboard/products/${productColor.productId}/productColors/${productColor.id}" method="POST">
  <!-- Thêm hidden input để chỉ định PUT method -->
  <!-- Trình duyệt không hỗ trợ phương thức HTTP PUT trong form, nên sử dụng POST và giả lập PUT qua _method  -->
  <input type="hidden" name="_method" value="PUT">

  <!-- Thêm token CSRF -->
  <input type="hidden" name="csrf_token" value="${sessionScope.csrfToken}">
  <input type="hidden" id="productId" name="id" value="${productColor.id}">

  <div class="mb-3">
    <label for="colorCode" class="form-label">Mã màu:</label>
    <input type="text" class="form-control" id="colorCode" name="colorCode" value="${productColor.colorCode}" required>
  </div>

  <div class="mb-3">
    <label for="colorName" class="form-label">Tên màu</label>
    <input type="text" class="form-control" id="colorName" name="colorName" value="${productColor.colorName}" required>
  </div>

  <div class="d-flex justify-content-end">
    <button type="submit" class="btn btn-primary">Lưu</button>
    <a href="${pageContext.request.contextPath}/products/${productColor.productId}/edit" class="btn btn-secondary ms-2">Hủy</a>
  </div>
</form>

