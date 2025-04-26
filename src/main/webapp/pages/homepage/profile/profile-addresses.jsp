<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    .form-control, .form-select {
        border-radius: 8px;
        padding: 10px 15px;
        border: 1px solid rgba(0, 0, 0, 0.1);
        width: 100%;
    }

    .form-control:focus, .form-select:focus {
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 0.2rem rgba(253, 0, 0, 0.25);
        outline: none;
    }

    .form-check {
        padding: 10px 0;
    }

    .form-check .form-check-input {
        width: 18px;
        height: 18px;
        margin-top: 0.2em;
        border: 2px solid var(--bs-primary);
        border-radius: 4px;
        cursor: pointer;
        margin-left: 0;
    }

    .form-check-input:checked {
        background-color: var(--bs-primary);
        border-color: var(--bs-primary);
    }

    .form-check-label {
        padding-left: 8px;
        cursor: pointer;
        color: var(--text-color);
    }

    .address-card {
        background: var(--text-white);
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        border-radius: 15px;
        overflow: hidden;
    }

    .address-item {
        background: var(--text-white);
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
        height: 100%;
    }

    .address-item:hover {
        transform: translateY(-3px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
    }

    .address-header {
        padding: 15px;
        border-bottom: 1px solid #eee;
    }

    .address-content {
        padding: 15px;
    }

    .default-badge {
        background-color: var(--bs-primary);
        color: var(--hover-color);
        padding: 4px 10px;
        border-radius: 20px;
        font-size: 0.8rem;
        font-weight: 500;
    }

    .btn-address {
        padding: 8px 20px;
        border-radius: 25px;
        font-weight: 500;
        transition: all 0.3s ease;
        border: none;
    }

    .btn-add {
        background-color: var(--bs-primary);
        color: var(--hover-color);
    }

    .btn-add:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        background-color: var(--hover-color);
        color: var(--bs-primary);
    }

    .btn-edit {
        background-color: var(--bs-primary);
        color: var(--hover-color);
        padding: 6px 12px;
    }

    .btn-delete {
        background-color: var(--bs-secondary);
        color: var(--text-white);
        padding: 6px 12px;
    }

    .address-form {
        background: #f8f9fa;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
    }
</style>

<div class="col-md-9">
    <div class="address-card animate__animated animate__fadeInRight">
        <div class="card-header p-4">
            <div class="d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="bi bi-geo-alt me-2"></i>
                    DANH SÁCH ĐỊA CHỈ
                </h5>
                <button class="btn btn-address btn-add" id="add-address-btn">
                    <i class="bi bi-plus-circle me-2"></i>Thêm địa chỉ mới
                </button>
            </div>
        </div>

        <div class="card-body p-4">

            <!-- Form thêm địa chỉ mới -->
            <div id="add-address-form" class="address-form" style="display: none;">
                <form id="addressForm">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" name="add_fullname" placeholder="Nhập họ và tên"
                                   required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" name="add_phone" placeholder="Nhập số điện thoại"
                                   required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Tỉnh/Thành phố</label>
                            <select class="form-select" id="add_provinceSelect" name="add_provinceId" required>
                                <option value="">Chọn Tỉnh/Thành phố</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Quận/Huyện</label>
                            <select class="form-select" id="add_districtSelect" name="add_districtId" required disabled>
                                <option value="">Chọn Quận/Huyện</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Phường/Xã</label>
                            <select class="form-select" id="add_wardSelect" name="add_wardId" required disabled>
                                <option value="">Chọn Phường/Xã</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Địa chỉ chi tiết</label>
                            <input type="text" class="form-control" name="add_addressDetail"
                                   placeholder="Số nhà, tên đường, khu vực" required>
                        </div>

                        <div class="col-12">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="add_defaultAddress"
                                       name="add_main">
                                <label class="form-check-label" for="add_defaultAddress">
                                    Đặt làm địa chỉ mặc định
                                </label>
                            </div>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-address btn-add">
                                <i class="bi bi-check-circle me-2"></i>Lưu địa chỉ
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Form chỉnh sửa địa chỉ -->
            <div id="edit-address-form" class="address-form" style="display: none;">
                <form id="editAddressForm">
                    <input type="hidden" name="edit_addressId" id="editAddressId">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" class="form-control" name="edit_fullname" id="editFullname" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Số điện thoại</label>
                            <input type="tel" class="form-control" name="edit_phone" id="editPhone" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Tỉnh/Thành phố</label>
                            <select class="form-select" id="edit_provinceSelect" name="edit_provinceId" required>
                                <option value="">Chọn Tỉnh/Thành phố</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Quận/Huyện</label>
                            <select class="form-select" id="edit_districtSelect" name="edit_districtId" required>
                                <option value="">Chọn Quận/Huyện</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label">Phường/Xã</label>
                            <select class="form-select" id="edit_wardSelect" name="edit_wardId" required>
                                <option value="">Chọn Phường/Xã</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Địa chỉ chi tiết</label>
                            <input type="text" class="form-control" name="edit_addressDetail" id="editAddressDetail"
                                   required>
                        </div>

                        <div class="col-12">
                            <div class="form-check">
                                <input type="checkbox" class="form-check-input" id="edit_defaultAddress"
                                       name="edit_main">
                                <label class="form-check-label" for="edit_defaultAddress">
                                    Đặt làm địa chỉ mặc định
                                </label>
                            </div>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-address btn-add">
                                <i class="bi bi-check-circle me-2"></i>Cập nhật địa chỉ
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="closeEditForm()">
                                <i class="bi bi-x-circle me-2"></i>Hủy
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Danh sách địa chỉ -->
            <div class="row g-4">
                <c:forEach var="address" items="${addresses}">
                    <div class="col-md-6">
                        <div class="address-item" data-address-id="${address.id}">
                            <div class="address-header d-flex justify-content-between align-items-center">
                                <div>
                                    <span class="fw-bold">${address.fullname}</span>
                                    <c:if test="${address.main}">
                                        <span class="default-badge ms-2">Mặc định</span>
                                    </c:if>
                                </div>
                                <div>
                                    <button class="btn btn-address btn-edit me-2" data-address-id="${address.id}">
                                        <i class="bi bi-pencil"></i>
                                    </button>
                                    <button class="btn btn-address btn-delete" data-address-id="${address.id}">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="address-content">
                                <p class="mb-2">
                                    <i class="bi bi-geo-alt me-2"></i>
                                        ${address.address}
                                </p>
                                <p class="mb-0">
                                    <i class="bi bi-telephone me-2"></i>
                                        ${address.phone}
                                </p>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        // Toggle form thêm địa chỉ
        $('#add-address-btn').click(function () {
            $('#add-address-form').slideToggle(300);
        });

        // Hiệu ứng hover cho address items
        $('.address-item').hover(
            function () {
                $(this).addClass('shadow-lg');
            },
            function () {
                $(this).removeClass('shadow-lg');
            }
        );

        // Animation khi xóa địa chỉ
        $('.btn-delete').click(function () {
            $(this).closest('.col-md-6').addClass('animate__animated animate__fadeOutRight');
        });
    });
</script>
<script>
    $(document).ready(function () {
        // Load provinces
        function loadProvinces(selector) {
            $.get('${pageContext.request.contextPath}/api/locations/provinces', function (data) {
                $(selector).empty().append('<option value="">Chọn Tỉnh/Thành phố</option>');
                data.forEach(function (province) {
                    $(selector).append(new Option(province.name, province.id));
                });
            });
        }

        // Load districts by province
        function loadDistricts(provinceId, selector) {
            if (!provinceId) {
                $(selector).empty()
                    .append('<option value="">Chọn Quận/Huyện</option>')
                    .prop('disabled', true);
                return;
            }

            $.get(`${pageContext.request.contextPath}/api/locations/provinces/\${provinceId}/districts`, function (data) {
                const $select = $(selector);
                $select.empty().append('<option value="">Chọn Quận/Huyện</option>');
                data.forEach(function (district) {
                    $select.append(new Option(district.name, district.id));
                });
                $select.prop('disabled', false);
            });
        }

        // Load wards by district
        function loadWards(districtId, selector) {
            if (!districtId) {
                $(selector).empty()
                    .append('<option value="">Chọn Phường/Xã</option>')
                    .prop('disabled', true);
                return;
            }

            $.get(`${pageContext.request.contextPath}/api/locations/districts/\${districtId}/wards`, function (data) {
                const $select = $(selector);
                $select.empty().append('<option value="">Chọn Phường/Xã</option>');
                data.forEach(function (ward) {
                    $select.append(new Option(ward.name, ward.id));
                });
                $select.prop('disabled', false);
            });
        }

        // Load initial provinces
        loadProvinces('#add_provinceSelect');
        loadProvinces('#edit_provinceSelect');

        // Event handlers for add form
        $('#add_provinceSelect').on('change', function () {
            loadDistricts($(this).val(), '#add_districtSelect');
            $('#add_wardSelect').empty()
                .append('<option value="">Chọn Phường/Xã</option>')
                .prop('disabled', true);
        });

        $('#add_districtSelect').on('change', function () {
            loadWards($(this).val(), '#add_wardSelect');
        });

        // Event handlers for edit form
        $('#edit_provinceSelect').on('change', function () {
            loadDistricts($(this).val(), '#edit_districtSelect');
            $('#edit_wardSelect').empty()
                .append('<option value="">Chọn Phường/Xã</option>')
                .prop('disabled', true);
        });

        $('#edit_districtSelect').on('change', function () {
            loadWards($(this).val(), '#edit_wardSelect');
        });

        // Sửa lại phần xử lý click edit button để load địa chỉ
        $('.btn-edit').click(function () {
            const addressId = $(this).closest('.address-item').data('address-id');

            $('#edit-address-form').slideDown(300);
            $('#add-address-form').slideUp(300);

            $.ajax({
                url: '${pageContext.request.contextPath}/profile',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'get-address',
                    data: {addressId: addressId}
                }),
                success: async function (data) {
                    console.log(data);
                    // Fill basic info
                    $('#editAddressId').val(data.id);
                    $('input[name="edit_fullname"]').val(data.fullname);
                    $('input[name="edit_phone"]').val(data.phone);
                    $('input[name="edit_addressDetail"]').val(data.address);
                    $('#edit_defaultAddress').prop('checked', data.main);

                    // Load provinces và đợi cho đến khi hoàn thành
                    await new Promise(resolve => {
                        $.get('${pageContext.request.contextPath}/api/locations/provinces', function (provinces) {
                            $('#edit_provinceSelect').empty().append('<option value="">Chọn Tỉnh/Thành phố</option>');
                            provinces.forEach(function (province) {
                                $('#edit_provinceSelect').append(new Option(province.name, province.id));
                            });
                            $('#edit_provinceSelect').val(data.provinceId);
                            resolve();
                        });
                    });

                    // Load districts và đợi cho đến khi hoàn thành
                    await new Promise(resolve => {
                        $.get(`${pageContext.request.contextPath}/api/locations/provinces/\${data.provinceId}/districts`, function (districts) {
                            $('#edit_districtSelect').empty().append('<option value="">Chọn Quận/Huyện</option>');
                            districts.forEach(function (district) {
                                $('#edit_districtSelect').append(new Option(district.name, district.id));
                            });
                            $('#edit_districtSelect').val(data.districtId);
                            $('#edit_districtSelect').prop('disabled', false);
                            resolve();
                        });
                    });

                    // Load wards và đợi cho đến khi hoàn thành
                    await new Promise(resolve => {
                        $.get(`${pageContext.request.contextPath}/api/locations/districts/\${data.districtId}/wards`, function (wards) {
                            $('#edit_wardSelect').empty().append('<option value="">Chọn Phường/Xã</option>');
                            wards.forEach(function (ward) {
                                $('#edit_wardSelect').append(new Option(ward.name, ward.id));
                            });
                            $('#edit_wardSelect').val(data.wardId);
                            $('#edit_wardSelect').prop('disabled', false);
                            resolve();
                        });
                    });
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                    alert('Không thể tải thông tin địa chỉ');
                }
            });
        });

        // Xử lý thêm địa chỉ mới
        $('#addressForm').submit(function (e) {
            e.preventDefault();

            const formData = {
                fullname: $('input[name="add_fullname"]').val(),
                phone: $('input[name="add_phone"]').val(),
                provinceId: $('#add_provinceSelect').val(),
                districtId: $('#add_districtSelect').val(),
                wardId: $('#add_wardSelect').val(),
                addressDetail: $('input[name="add_addressDetail"]').val(),
                main: $('#add_defaultAddress').is(':checked')
            };
            console.log('Adding address:', formData);
            $.ajax({
                url: '${pageContext.request.contextPath}/profile',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'add-address',
                    data: formData
                }),
                success: function (response) {
                    if (response.success) {
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi thêm địa chỉ');
                }
            });
        });

        // Xử lý chỉnh sửa địa chỉ
        $('#editAddressForm').submit(function (e) {
            e.preventDefault();

            const formData = {
                id: $('#editAddressId').val(),
                fullname: $('input[name="edit_fullname"]').val(),
                phone: $('input[name="edit_phone"]').val(),
                provinceId: $('#edit_provinceSelect').val(),
                districtId: $('#edit_districtSelect').val(),
                wardId: $('#edit_wardSelect').val(),
                addressDetail: $('input[name="edit_addressDetail"]').val(),
                main: $('#edit_defaultAddress').is(':checked')
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/profile',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'update-address',
                    data: formData
                }),
                success: function (response) {
                    if (response.success) {
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi cập nhật địa chỉ');
                }
            });
        });

        // Xử lý xóa địa chỉ
        $('.btn-delete').click(function () {
            if (!confirm('Bạn có chắc chắn muốn xóa địa chỉ này?')) {
                return;
            }

            const addressItem = $(this).closest('.address-item');
            const addressId = addressItem.data('address-id');
            console.log('Deleting address:', addressId);

            $.ajax({
                url: '${pageContext.request.contextPath}/profile',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'delete-address',
                    addressId: addressId
                }),
                success: function (response) {
                    if (response.success) {
                        addressItem.closest('.col-md-6').fadeOut(300, function () {
                            $(this).remove();
                        });
                    } else {
                        alert(response.message);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi xóa địa chỉ');
                }
            });
        });
    });

    function closeEditForm() {
        $('#edit-address-form').slideUp(300);
    }
</script>