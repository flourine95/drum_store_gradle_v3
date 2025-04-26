<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .info-card {
        background: var(--text-white);
        box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        border-radius: 15px;
        overflow: hidden;
    }

    .info-item {
        padding: 15px;
        border-bottom: 1px solid #eee;
    }

    .info-item:last-child {
        border-bottom: none;
    }

    .info-item strong {
        color: var(--text-color);
    }

    .btn-update {
        padding: 10px 30px;
        border-radius: 25px;
        font-weight: 500;
        transition: all 0.3s ease;
        background-color: var(--bs-primary);
        color: var(--hover-color);
        border: none;
    }

    .btn-update:hover {
        transform: translateY(-2px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        background-color: var(--hover-color);
        color: var(--bs-primary);
    }

    .card-header {
        background-color: var(--bs-primary) !important;
        color: var(--hover-color) !important;
    }
</style>

<div class="col-md-9">
    <div class="info-card animate__animated animate__fadeInRight">
        <div class="card-header p-4" >
            <h5 class="mb-0">
                <i class="bi bi-person-badge me-2"></i>
                THÔNG TIN TÀI KHOẢN
            </h5>
        </div>
        <div class="card-body p-4">
            <div class="info-item">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <strong>Họ và tên</strong>
                    </div>
                    <div class="col-md-8">
                        ${user.fullname}
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <strong>Email</strong>
                    </div>
                    <div class="col-md-8">
                        ${user.email}
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer bg-light p-4 text-center">
            <a href="${pageContext.request.contextPath}/profile?action=edit-account" class="btn btn-update">
                <i class="bi bi-pencil-square me-2"></i>
                Cập nhật thông tin
            </a>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('.info-card').hover(
            function () {
                $(this).addClass('shadow-lg');
            },
            function () {
                $(this).removeClass('shadow-lg');
            }
        );
    });
</script>
