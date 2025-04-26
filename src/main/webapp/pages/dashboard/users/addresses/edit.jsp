<%@ page contentType="text/html;charset=UTF-8" %>
<form id="editAddressForm" action="${pageContext.request.contextPath}/dashboard/users/${address.userId}/addresses/${address.id}" method="POST">
  <!-- Thêm hidden input để chỉ định PUT method -->
  <!-- Trình duyệt không hỗ trợ phương thức HTTP PUT trong form, nên sử dụng POST và giả lập PUT qua _method  -->
  <input type="hidden" name="_method" value="PUT">

  <!-- Thêm token CSRF -->
  <input type="hidden" name="csrf_token" value="${sessionScope.csrfToken}">
  <input type="hidden" id="addressId" name="id" value="${address.id}">


  <div class="mb-3">
    <label for="address" class="form-label">Địa chỉ chi tiết</label>
    <input type="text" class="form-control" id="address" name="address" value="${address.address}" required>
  </div>

  <div class="mb-3">
    <label for="phone" class="form-label">Số điện thoại</label>
    <input type="text" class="form-control" id="phone" name="phone" value="${address.phone}" required>
  </div>

  <div class="mb-3">
    <label for="provinceId" class="form-label">Tỉnh/Thành phố</label>
    <select class="form-select" id="provinceId" name="provinceId" required>
      <option value="">Chọn tỉnh</option>
      <!-- Option sẽ được load từ backend -->
    </select>
  </div>

  <div class="mb-3">
    <label for="districtId" class="form-label">Quận/Huyện</label>
    <select class="form-select" id="districtId" name="districtId" required>
      <option value="">Chọn huyện</option>
      <!-- Option sẽ được load từ backend -->
    </select>
  </div>

  <div class="mb-3">
    <label for="wardId" class="form-label">Phường/Xã</label>
    <select class="form-select" id="wardId" name="wardId" required>
      <option value="">Chọn xã</option>
      <!-- Option sẽ được load từ backend -->
    </select>
  </div>

  <div class="mb-3">
    <label class="fw-bold">Mặc định</label>
    <div class="form-check form-switch d-flex align-items-center">
      <input type="hidden" name="isDefault" value="false"> <!-- Trường ẩn để gửi false -->
      <input class="form-check-input" type="checkbox" id="isDefault" name="isDefault" value="true" ${address.isDefault ? 'checked' : ''}>
      <label class="form-check-label ms-2" for="isDefault" id="isDefaultLabel">Không</label>
    </div>
  </div>


  <div class="d-flex justify-content-end">
    <button type="submit" class="btn btn-primary">Lưu</button>
    <a href="${pageContext.request.contextPath}/dashboard/users" class="btn btn-secondary ms-2">Hủy</a>
  </div>
</form>

<script>
  $(document).ready(function () {
    $("#editAddressForm").on("submit", function() {
      const isDefaultChecked = $("#isDefault").is(":checked");
      $("input[name='isDefault']").val(isDefaultChecked ? "true" : "false");
    });
    let isDefault = ${address.isDefault} || false;

    const $isDefaultButton = $("#isDefault");
    const $isDefaultLabel = $("#isDefaultLabel");

    $isDefaultButton.prop("checked", isDefault);
    $isDefaultLabel.text(isDefault ? "Có" : "Không");

    $isDefaultButton.change(function () {
      $isDefaultLabel.text(this.checked ? "Có" : "Không");
    });

    let provinceId = "${address.provinceId}";
    let districtId = "${address.districtId}";
    let wardId = "${address.wardId}";

    // Load danh sách tỉnh/thành phố
    $.get("${pageContext.request.contextPath}/location?action=provinces", function (data) {
      data.forEach(item => {
        $("#provinceId").append(`<option value="\${item.id}" \${item.id == provinceId ? 'selected' : ''}>\${item.name}</option>`);
      });

      // Nếu có tỉnh/thành phố đã chọn, load quận/huyện
      if (provinceId) {
        loadDistricts(provinceId, districtId, wardId);
      }
    });

    // Sự kiện thay đổi tỉnh/thành phố
    $("#provinceId").change(function () {
      let selectedProvinceId = $(this).val();
      loadDistricts(selectedProvinceId, null, null); // Load mới quận/huyện
    });

    // Hàm load quận/huyện
    function loadDistricts(provinceId, selectedDistrictId, selectedWardId) {
      $.get("${pageContext.request.contextPath}/location?action=districts&provinceId=" + provinceId, function (data) {
        $("#districtId").empty().append('<option value="">Chọn huyện</option>');
        data.forEach(item => {
          $("#districtId").append(`<option value="\${item.id}" \${item.id == selectedDistrictId ? 'selected' : ''}>\${item.name}</option>`);
        });

        // Nếu có quận/huyện đã chọn, load phường/xã
        if (selectedDistrictId) {
          loadWards(selectedDistrictId, selectedWardId);
        }
      });
    }

    // Sự kiện thay đổi quận/huyện
    $("#districtId").change(function () {
      let selectedDistrictId = $(this).val();
      loadWards(selectedDistrictId, null); // Load mới phường/xã
    });

    // Hàm load phường/xã
    function loadWards(districtId, selectedWardId) {
      $.get("${pageContext.request.contextPath}/location?action=wards&districtId=" + districtId, function (data) {
        $("#wardId").empty().append('<option value="">Chọn xã</option>');
        data.forEach(item => {
          $("#wardId").append(`<option value="\${item.id}" \${item.id == selectedWardId ? 'selected' : ''}>\${item.name}</option>`);
        });
      });
    }


  });

</script>
