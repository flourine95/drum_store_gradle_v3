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
        cursor: pointer;
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

    .form-control {
        border-radius: 10px;
    }
</style>

<div class="col-md-9">
    <div class="info-card animate__animated animate__fadeInRight">
        <div class="card-header p-4">
            <h5 class="mb-0">
                <i class="bi bi-person-badge me-2"></i>
                CHỈNH SỬA THÔNG TIN TÀI KHOẢN
            </h5>
        </div>
        <div class="card-body p-4">
            <div class="info-item">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <strong>Họ và tên</strong>
                    </div>

                    <div class="col-md-8">
                        <input type="text" name="fullname" value="${user.fullname}" class="form-control" required>
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <strong>Email</strong>
                    </div>
                    <div class="col-md-8">
                        <input type="email" name="email" value="${user.email}" class="form-control" readonly>
                    </div>
                </div>
            </div>
            <div class="info-item">
                <div class="row align-items-center">
                    <div class="col-md-4">
                        <strong>Số điện thoại</strong>
                    </div>
                    <div class="col-md-8">
                        <input type="text" name="phone" value="${user.phone}" class="form-control" required>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-footer bg-light p-4 text-center">
            <button type="button" class="btn btn-update" id="updateButton">
                <i class="bi bi-pencil-square me-2"></i>
                Lưu thay đổi
            </button>
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

        // Sự kiện click cho nút cập nhật
        $('#updateButton').click(function (e) {
            e.preventDefault();

            // Lấy giá trị từ các trường input
            var fullName = $('input[name="fullname"]').val();
            var phone = $('input[name="phone"]').val();

            var data = {
                fullName: fullName,
                phone: phone
            };

            $.ajax({
                url: '${pageContext.request.contextPath}/profile',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    action: 'update-account',
                    data: data
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
                    alert('Có lỗi xảy ra khi cập nhật tài khoản');
                }
            });
        });
    });
</script>