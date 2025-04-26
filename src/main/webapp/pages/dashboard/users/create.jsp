<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<form id="createUserForm" action="${pageContext.request.contextPath}/dashboard/users" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="csrf_token" value="${sessionScope.csrfToken}">
    <section class="row mb-3">
        <div class="col-md-4">
            <div class="text-center">
                <img id="avatarPreview" 
                     src="${pageContext.request.contextPath}/assets/images/data/${user.avatar != null ? user.avatar : 'default-avatar.jpg'}"
                     alt="Avatar Preview"
                     class="img-fluid rounded-circle user-avatar mb-2">
                <div class="mb-3">
                    <label for="avatarInput" class="form-label fw-bold">Ảnh đại diện:</label>
                    <input type="file" class="form-control" id="avatarInput" name="avatar"
                           accept="image/*" onchange="previewImage(this)">
                    <small class="text-muted">Tối đa 10MB. Chỉ chấp nhận file ảnh.</small>
                </div>
            </div>
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Họ tên:</label>
                    <input type="text" name="fullname" class="form-control" required>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Email:</label>
                    <input type="email" name="email" class="form-control" required>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Mật khẩu:</label>
                    <input type="password" name="password" class="form-control" required>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Xác nhận mật khẩu:</label>
                    <input type="password" name="confirmPassword" class="form-control" required>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Quyền:</label>
                    <select name="role" id="role" class="form-select" required>
                        <option value="0">User</option>
                        <option value="1">Admin</option>
                    </select>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Trạng thái:</label>
                    <select name="status" id="status" class="form-select" required>
                        <option value="1">Hoạt động</option>
                        <option value="0">Khóa</option>
                    </select>
                </div>
            </div>
        </div>
    </section>

    <section class="row mb-4">
        <div class="col-12">
            <h5>Quản lý địa chỉ</h5>

            <!-- Form nhập địa chỉ mới -->
            <div class="address-input-form border p-3 mb-3">
                <div class="row">
                    <div class="col-md-5 mb-2">
                        <label class="form-label">Địa chỉ:</label>
                        <input type="text" id="newAddress" class="form-control">
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">Số điện thoại:</label>
                        <input type="tel" id="newPhone" class="form-control">
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">Tỉnh/Thành phố:</label>
                        <select class="form-select" id="newProvinceId">
                            <option value="">Chọn tỉnh/thành phố</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">Quận/Huyện:</label>
                        <select class="form-select" id="newDistrictId">
                            <option value="">Chọn quận/huyện</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label class="form-label">Phường/Xã:</label>
                        <select class="form-select" id="newWardId">
                            <option value="">Chọn phường/xã</option>
                        </select>
                    </div>
                    <div class="col-md-2 mb-2">
                        <label class="form-label">Mặc định:</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="newIsDefault">
                        </div>
                    </div>
                    <div class="col-md-1 mb-2 d-flex align-items-end">
                        <button type="button" class="btn btn-primary" onclick="addNewAddress()">
                            Thêm
                        </button>
                    </div>
                </div>
            </div>

            <!-- Danh sách địa chỉ đã thêm -->
            <div class="addresses-list mb-3">
                <h6>Danh sách địa chỉ đã thêm:</h6>
                <div id="addressesContainer" class="list-group">
                    <!-- Địa chỉ sẽ được thêm vào đây động -->
                </div>
            </div>

            <!-- Hidden input để lưu danh sách địa chỉ dạng JSON -->
            <input type="hidden" name="addressesJson" id="addressesJson">
        </div>
    </section>

    <div class="form-actions">
        <button type="submit" class="btn btn-primary">Tạo mới</button>
        <a href="${pageContext.request.contextPath}/dashboard/users" class="btn btn-secondary">Hủy</a>
    </div>
</form>

<style>
    .user-avatar {
        width: 150px;
        height: 150px;
        object-fit: cover;
        border-radius: 50%;
    }

    .form-actions {
        margin-top: 20px;
    }

    .address-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 10px 15px;
        margin-bottom: 5px;
    }

    .address-info {
        flex-grow: 1;
    }

    .address-actions {
        display: flex;
        gap: 5px;
    }

    .default-badge {
        background-color: #198754;
        color: white;
        padding: 2px 8px;
        border-radius: 4px;
        font-size: 0.8em;
        margin-left: 10px;
    }
</style>

<script src="${pageContext.request.contextPath}/assets/js/user-manager.js"></script>