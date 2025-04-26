<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<form id="userForm" action="${pageContext.request.contextPath}/dashboard/users/${user.id}" method="POST">
    <input type="hidden" name="_method" value="PUT">
    <input type="hidden" name="csrf_token" value="${csrfToken}">
    <section class="row mb-3">
        <div class="col-md-4">
            <img src="/assets/images/data/${empty user.avatar ? '/images/data/default-avatar.jpg' : user.avatar}"
                 alt="Avatar"
                 class="img-fluid rounded-circle user-avatar">
        </div>

        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Họ tên:</label>
                    <input type="text" name="fullname" value="${user.fullname}" class="form-control">
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Email:</label>
                    <input type="email" name="email" value="${user.email}" class="form-control">
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Trạng thái:</label>
                    <div class="form-check form-switch">
                        <input class="form-check-input" type="checkbox" id="statusToggle"
                               name="status" value="1" ${user.status == 1 ? 'checked' : ''}>
                        <label class="form-check-label" for="statusToggle">
                            ${user.status == 1 ? 'Hoạt động' : 'Bị cấm'}
                        </label>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="row mb-4">
        <div class="col-12">
            <h5>Danh sách địa chỉ</h5>
            <table id="addressTable" class="table table-bordered">
                <thead>
                <tr>
                    <th>#</th>
                    <th>Địa chỉ</th>
                    <th>Số điện thoại</th>
                    <th>Mặc định</th>
                    <th>Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="address" items="${user.userAddresses}">
                    <tr>
                        <td>${address.id}</td>
                        <td>${address.address}</td>
                        <td>${address.phone}</td>
                        <td>
                            <div class="form-check form-switch">
                                <input class="form-check-input isDefaultToggle"
                                       type="checkbox"
                                       id="defaultToggle${address.id}"
                                       name="addresses[${address.id}].isDefault"
                                       value="1" ${address.isDefault ? 'checked' : ''} disabled>
                                <label class="form-check-label" for="defaultToggle${address.id}">
                                        ${address.isDefault ? 'Có' : 'Không'}
                                </label>
                            </div>
                        </td>
                        <td>
                            <div class="btn-group">
                                <form action="${pageContext.request.contextPath}/dashboard/users/${user.id}/addresses/${address.id}"
                                      method="GET">
                                    <button type="submit" class="btn btn-info">Xem</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/dashboard/users/${user.id}/addresses/${address.id}/edit"
                                      method="GET">
                                    <button type="submit" class="btn btn-warning">Chỉnh sửa</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/dashboard/users/${user.id}/addresses/${address.id}"
                                      method="POST"
                                      onsubmit="return confirm('Bạn có chắc muốn xóa địa chỉ này không?');">
                                    <input type="hidden" name="_method" value="DELETE">
                                    <input type="hidden" name="csrf_token" value="${csrfToken}">
                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </section>

    <div class="form-actions">
        <button type="submit" class="btn btn-success">Lưu thay đổi</button>
        <a href="${pageContext.request.contextPath}/dashboard/users" class="btn btn-secondary">Quay lại</a>
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

    .btn-group {
        gap: 5px;
    }
</style>
<script>
    $(document).ready(function () {
        $('#addressTable').DataTable({
            responsive: true, // Bảng responsive
            paging: true,      // Bật phân trang
            searching: true,   // Bật tìm kiếm
            ordering: true,    // Cho phép sắp xếp
            lengthMenu: [5, 10, 20, 100], // Tùy chọn số hàng hiển thị
            columnDefs: [
                {orderable: false, targets: [4]} // Vô hiệu hóa sắp xếp cho cột Thao tác
            ]
        });
    });
</script>