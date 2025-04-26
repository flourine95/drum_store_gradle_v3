<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<style>

    .login-container {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        overflow: hidden;
    }

    .form-section {
        padding: 6.6rem;
        display: flex;
        flex-direction: column;
        align-items: center;
        text-align: center;
    }

    .welcome-text {
        font-size: 2rem;
        font-weight: 700;
        color: #1B2832; /* --primary-color */
        margin-bottom: 1rem;
    }

    .welcome-subtext {
        color: #4A5568; /* --text-color */
        margin-bottom: 2rem;
        font-size: 1rem;
        line-height: 1.5;
    }

    .form-group {
        margin-bottom: 1.5rem;
        width: 100%;
        max-width: 400px;
    }

    .form-label {
        font-weight: 500;
        color: #1B2832; /* --primary-color */
        margin-bottom: 0.5rem;
        display: block;
        text-align: left;
    }

    .form-control {
        padding: 0.75rem 1rem;
        border: 1px solid #E2E8F0; /* --border-color */
        border-radius: 8px;
        background-color: #F8FAFC; /* --input-bg */
        color: #4A5568; /* --text-color */
        width: 100%;
        font-size: 1rem;
        transition: border-color 0.2s ease;
    }

    .form-control:focus {
        outline: none;
        border-color: #3182CE; /* --link-color */
        box-shadow: 0 0 0 3px rgba(49, 130, 206, 0.1);
    }

    .btn-register {
        width: 100%;
        max-width: 400px;
        padding: 0.75rem;
        background-color: #FFD700; /* --button-bg */
        border: none;
        border-radius: 8px;
        color: #000;
        font-weight: 600;
        font-size: 1rem;
        transition: all 0.2s ease;
    }

    .btn-register:hover {
        background-color: #FFC107; /* --button-hover-bg */
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    }

    .error-message {
        color: #E53E3E; /* --error-color */
        font-size: 0.875rem;
        margin-top: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .error-message i {
        font-size: 14px;
    }

    .alert-danger {
        background-color: #FEE2E2;
        border: 1px solid #FCA5A5;
        color: #DC2626;
        padding: 1rem;
        border-radius: 8px;
        margin-bottom: 1.5rem;
        font-size: 0.95rem;
        width: 100%;
        max-width: 400px;
        text-align: left;
    }

    .required-field::after {
        content: "*";
        color: #E53E3E; /* --error-color */
        margin-left: 4px;
    }
</style>

<div class="container-fluid">
    <div class="row login-container">
        <div class="col-md-12 form-section">
            <h1 class="welcome-text">Xác thực tài khoản</h1>
            <p class="welcome-subtext">
                Vui lòng nhập mã xác thực được gửi đến email của bạn.<br>
                Mã có hiệu lực trong vòng <strong>5:00 phút</strong></span>.
            </p>

            <c:if test="${not empty errors.general}">
                <div class="alert alert-danger" id="server-error">
                    <i class="fas fa-exclamation-circle"></i>
                        ${errors.general}
                </div>
            </c:if>

            <div id="attempts-message" class="error-message" style="display: none;">
                <i class="fas fa-exclamation-circle"></i>
                Bạn còn <span id="attempts-left">3</span> lần nhập.
            </div>

            <div id="ajax-error" class="error-message" style="display: none;"></div>

            <form id="verifyForm" method="POST">
                <div class="form-group">
                    <label class="form-label required-field" for="token">Mã xác thực</label>
                    <input type="text"
                           class="form-control"
                           id="token"
                           name="token"
                           placeholder="Nhập mã xác thực"
                           required>
                </div>

                <button type="submit" class="btn btn-register" id="submitBtn">Xác nhận</button>
                <button type="button" class="btn btn-secondary mt-3" id="resendOtpBtn">Gửi lại mã OTP</button>
            </form>
        </div>
    </div>

    <!-- Overlay loading toàn trang -->
    <div id="loadingOverlay"
         class="d-none position-fixed top-0 start-0 w-100 h-100 bg-dark bg-opacity-50 d-flex justify-content-center align-items-center"
         style="z-index: 9999;">
        <div class="spinner-border text-light" role="status">
            <span class="visually-hidden">Đang tải...</span>
        </div>
    </div>
</div>
<script>
    let attempts = 3;

    document.getElementById('verifyForm').addEventListener('submit', function(e) {
        e.preventDefault();

        const tokenInput = document.getElementById('token').value;
        const submitBtn = document.getElementById('submitBtn');
        const ajaxError = document.getElementById('ajax-error');

        $.ajax({
            url: '${pageContext.request.contextPath}/verify-token',
            method: 'POST',
            data: {
                token: tokenInput
            },
            dataType: 'json',
            success: function(data) {
                if (data.success) {
                    window.location.href = '${pageContext.request.contextPath}/login';
                } else {
                    attempts--;
                    document.getElementById('attempts-message').style.display = 'block';
                    document.getElementById('attempts-left').textContent = attempts;
                    ajaxError.style.display = 'block';
                    ajaxError.textContent = data.error;

                    if (attempts <= 0) {
                        submitBtn.disabled = true;
                        document.getElementById('verifyForm').insertAdjacentHTML('beforeend',
                            '<p class="error-message">Bạn đã hết lượt nhập. Vui lòng nhấn nút gửi lại mã OTP.</p>');
                    }
                }
            },
            error: function(xhr, status, error) {
                console.error('Error:', error);
                ajaxError.style.display = 'block';
                ajaxError.textContent = 'Có lỗi xảy ra. Vui lòng thử lại.';
            }
        });
    });

    document.getElementById('resendOtpBtn').addEventListener('click', function () {
        const loadingOverlay = document.querySelector('#loadingOverlay');
        if (loadingOverlay) {
            loadingOverlay.classList.remove('d-none');
        }
        $.ajax({
            url: '${pageContext.request.contextPath}/verify-token',
            method: 'POST',
            data: { action: 'resend' },
            dataType: 'json',
            success: function (data) {
                Swal.fire({
                    title: "Mã OTP",
                    text: "Mã OTP đã gửi trong email của ban",
                    icon: "success"
                });
            },
            error: function () {
                Swal.fire({
                    title: "Mã OTP",
                    text: "Có lỗi xảy ra, gửi mã OTP thất bại",
                    icon: "error"
                });
            },
            complete: function () {
                // Ẩn overlay loading
                if (loadingOverlay) {
                    loadingOverlay.classList.add('d-none');
                }
            }
        });
    });
</script>