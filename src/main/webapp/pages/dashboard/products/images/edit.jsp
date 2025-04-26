<%@ page contentType="text/html;charset=UTF-8" %>
<form id="editAddressForm" action="${pageContext.request.contextPath}/dashboard/products/${productImage.productId}/productImages/${productImage.id}" method="POST">
  <!-- Thêm hidden input để chỉ định PUT method -->
  <!-- Trình duyệt không hỗ trợ phương thức HTTP PUT trong form, nên sử dụng POST và giả lập PUT qua _method  -->
  <input type="hidden" name="_method" value="PUT">

  <!-- Thêm token CSRF -->
  <input type="hidden" name="csrf_token" value="${sessionScope.csrfToken}">
  <input type="hidden" id="productImageId" name="id" value="${productImage.id}">

  <div class="row">
    <div class="my-2 col-4">
      <img class="product-image" src="/assets/images/data/${productImage.image}" alt="/assets/images/data/${productImage.image}">
    </div>

    <div class="my-2 col-8">
      <div class="mb-3">
        <label for="productImage" class="form-label">Đường dẫn của ảnh</label>
        <input type="text" class="form-control" id="productImage" name="productImage" value="${productImage.image}" required>
      </div>

      <div class="mb-3">
        <label class="fw-bold">Ảnh chính</label>
        <div class="form-check form-switch d-flex align-items-center">
          <input class="form-check-input" type="checkbox" id="isMain" name="isMain"
                 value="${productImage.isMain}" ${productImage.isMain ? 'checked' : ''}
                 onchange="updateToggle(this)">
          <label class="form-check-label ms-2" for="isMain" id="isDefaultLabel">Không</label>
        </div>
      </div>
    </div>
  </div>

  <div class="d-flex justify-content-end">
    <button type="submit" class="btn btn-primary">Lưu</button>
    <a href="${pageContext.request.contextPath}/users" class="btn btn-secondary ms-2">Hủy</a>
  </div>
</form>

<style>
  .product-image {
    width: 500px;
    height: 500px;
    object-fit: cover;
    justify-content: center;
  }
</style>

<script>
  function updateToggle(toggle) {
    const label = toggle.nextElementSibling;

    // Cập nhật giá trị của hidden input tùy theo trạng thái của checkbox
    toggle.value = toggle.checked ? 'true' : 'false';

    // Cập nhật nội dung label theo trạng thái của toggle
    if (label) {
      label.textContent = toggle.checked ? 'Có' : 'Không';
    }
  }
</script>
