<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .sidebar {
        background: var(--text-white);
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
    }

    .sidebar .list-group-item {
        border: none;
        padding: 15px 20px;
        transition: all 0.3s ease;
        border-radius: 5px;
        margin: 2px 0;
        color: var(--text-color);
    }

    .sidebar .list-group-item:hover {
        background-color: #f8f9fa;
        color: var(--hover-color);
        transform: translateX(5px);
    }

    .sidebar .list-group-item.active {
        background-color: var(--bs-primary);
        color: var(--hover-color);
    }

    .avatar-wrapper {
        position: relative;
        width: 120px;
        height: 120px;
        margin: 0 auto;
    }

    .avatar {
        width: 120px;
        height: 120px;
        background-color: var(--bs-primary);
        color: var(--hover-color);
        font-size: 2.5rem;
        font-weight: 500;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 50%;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
    }

    .avatar:hover {
        transform: scale(1.05);
    }
</style>
<div class="col-md-3">
    <div class="sidebar animate__animated animate__fadeInLeft">
        <div class="card-body text-center py-4">
            <div class="avatar-wrapper mb-4">
                <div class="avatar">
                    NN
                </div>
            </div>
            <h5 class="fw-bold mb-0" style="color: var(--text-color)"> ${user.fullname}</h5>
            <p class="text-muted small">Thành viên</p>
        </div>
        <div class="px-3 pb-4">
            <div class="list-group">
                <a href="${pageContext.request.contextPath}/profile" class="list-group-item ${activePage == 'profile' ? 'active' : ''}">
                    <i class="bi bi-person-circle me-2"></i>
                    Thông tin tài khoản
                </a>
                <a href="${pageContext.request.contextPath}/profile?action=wishlist" class="list-group-item ${activePage == 'wishlist' ? 'active' : ''}">
                    <i class="bi bi-heart me-2"></i>
                    Sản phẩm yêu thích
                </a>
                <a href="${pageContext.request.contextPath}/profile?action=orders" class="list-group-item ${activePage == 'orders' ? 'active' : ''}">
                    <i class="bi bi-bag-check me-2"></i>
                    Quản lý đơn hàng
                </a>
                <a href="${pageContext.request.contextPath}/profile?action=addresses" class="list-group-item ${activePage == 'addresses' ? 'active' : ''}">
                    <i class="bi bi-geo-alt me-2"></i>
                    Danh sách địa chỉ
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="list-group-item text-danger">
                    <i class="bi bi-box-arrow-right me-2"></i>
                    Đăng xuất
                </a>
            </div>
        </div>
    </div>
</div>
