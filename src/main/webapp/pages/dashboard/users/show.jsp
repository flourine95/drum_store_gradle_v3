<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section id="userForm">
    <input type="hidden" name="id" value="${user.id}">
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
                    <input type="text" value="${user.fullname}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Email:</label>
                    <input type="email" value="${user.email}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Trạng thái:</label>
                    <input type="text" value="${user.status == 1 ? 'Hoạt động' : 'Bị cấm'}" class="form-control" readonly>
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
                        <td>${address.isDefault ? 'Có' : 'Không'}</td>
                        <td>
                            <div class="btn-group">
                                <form action="${pageContext.request.contextPath}/dashboard/users/${user.id}/addresses/${address.id}" method="GET">
                                    <button type="submit" class="btn btn-info">Xem</button>
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
        <a href="${pageContext.request.contextPath}/dashboard/users" class="btn btn-secondary">Quay lại</a>
    </div>
</section>

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
</style>
<script>
    $(document).ready(function () {
        $('#addressTable').DataTable({
            responsive: true, // Bảng responsive
            paging: true,      // Bật phân trang
            searching: true,   // Bật tìm kiếm
            ordering: true,    // Cho phép sắp xếp
            lengthMenu: [5, 10, 20, 100] // Tùy chọn số hàng hiển thị
        });
    });
</script>
