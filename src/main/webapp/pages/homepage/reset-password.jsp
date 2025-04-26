<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    :root {
        --primary-color: #1B2832;
        --text-color: #4A5568;
        --link-color: #3182CE;
        --border-color: #E2E8F0;
        --input-bg: #F8FAFC;
        --error-color: #E53E3E;
    }

    .login-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 2rem;
    }

    .form-section {
        padding: 2rem;
    }

    .image-section {
        padding: 0;
        background-color: #000;
        border-radius: 32px;
        overflow: hidden;
    }

    .image-section img {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 32px;
    }

    .welcome-text {
        font-size: 2.5rem;
        font-weight: 600;
        color: var(--primary-color);
        margin-bottom: 1rem;
    }

    .welcome-subtext {
        color: var(--text-color);
        margin-bottom: 2.5rem;
        font-size: 1.1rem;
    }

    .form-group {
        margin-bottom: 1.25rem;
        position: relative;
    }

    .form-label {
        font-weight: 500;
        color: var(--primary-color);
        margin-bottom: 0.5rem;
    }

    .form-control {
        padding: 0.75rem 1rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background-color: var(--input-bg);
        color: var(--text-color);
    }

    .form-control:focus {
        box-shadow: none;
        border-color: var(--link-color);
    }

    .btn-reset {
        width: 100%;
        padding: 0.75rem;
        background-color: var(--bs-primary);
        border: none;
        border-radius: 0.5rem;
        color: var(--text-color);
        font-weight: 600;
        margin: 1.5rem 0;
        transition: all 0.2s ease;
    }

    .btn-reset:hover {
        background-color: #fcc419;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 221, 0, 0.3);
    }

    .password-requirements {
        font-size: 0.875rem;
        color: var(--text-color);
        margin: 1rem 0;
        padding: 1rem;
        background-color: #f8f9fa;
        border-radius: 0.5rem;
    }

    .requirement-item {
        display: flex;
        align-items: center;
        gap: 0.5rem;
        margin-bottom: 0.5rem;
    }

    .requirement-item i {
        color: var(--text-color);
        font-size: 12px;
    }

    .back-to-login {
        text-align: center;
        color: var(--text-color);
        margin-top: 1.5rem;
    }

    .back-to-login a {
        color: var(--link-color);
        text-decoration: none;
        font-weight: 500;
    }

    @media (max-width: 768px) {
        .image-section {
            display: none;
        }
    }

    .error-message {
        color: var(--error-color);
        font-size: 0.875rem;
        margin-top: 0.5rem;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .error-message i {
        font-size: 14px;
    }

    .form-control.is-invalid {
        border-color: var(--error-color);
        background-image: none;
    }

    .alert {
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1.5rem;
        font-size: 0.95rem;
    }

    .alert-danger {
        background-color: #FEE2E2;
        border: 1px solid #FCA5A5;
        color: #DC2626;
    }

    .alert-success {
        background-color: #DCFCE7;
        border: 1px solid #86EFAC;
        color: #16A34A;
    }
</style>

<div class="container-fluid">
    <div class="row login-container">
        <div class="col-md-5 form-section">
            <h1 class="welcome-text">Đặt lại mật khẩu 🔒</h1>
            <p class="welcome-subtext">
                Tạo mật khẩu mới cho tài khoản của bạn.<br>
                Hãy chọn một mật khẩu mạnh để bảo vệ tài khoản.
            </p>

            <!-- Hiển thị thông báo lỗi chung -->
            <c:if test="${not empty errors.general}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${errors.general}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <input type="hidden" name="action" value="reset">
                <input type="hidden" name="token" value="${token}">

                <div class="form-group">
                    <label class="form-label" for="password">Mật khẩu mới</label>
                    <input type="password" 
                           class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                           id="password" 
                           name="password"
                           placeholder="Nhập mật khẩu mới" 
                           required>
                    <c:if test="${not empty errors.password}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.password}
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Xác nhận mật khẩu mới</label>
                    <input type="password" 
                           class="form-control ${not empty errors.confirmPassword ? 'is-invalid' : ''}" 
                           id="confirmPassword" 
                           name="confirmPassword"
                           placeholder="Nhập lại mật khẩu mới" 
                           required>
                    <c:if test="${not empty errors.confirmPassword}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.confirmPassword}
                        </div>
                    </c:if>
                </div>

                <div class="password-requirements">
                    <h6 class="mb-2">Yêu cầu mật khẩu:</h6>
                    <div class="requirement-item">
                        <i class="fas fa-circle"></i>
                        Tối thiểu 8 ký tự
                    </div>
                    <div class="requirement-item">
                        <i class="fas fa-circle"></i>
                        Ít nhất 1 chữ hoa và 1 chữ thường
                    </div>
                    <div class="requirement-item">
                        <i class="fas fa-circle"></i>
                        Ít nhất 1 số
                    </div>
                    <div class="requirement-item">
                        <i class="fas fa-circle"></i>
                        Ít nhất 1 ký tự đặc biệt (!@#$%^&*)
                    </div>
                </div>

                <button type="submit" class="btn btn-reset">Đặt lại mật khẩu</button>

                <div class="back-to-login">
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-arrow-left"></i> Quay lại trang đăng nhập
                    </a>
                </div>
            </form>
        </div>

        <div class="col-md-7 image-section">
            <img src="${pageContext.request.contextPath}/assets/images/register.webp"
                 alt="Hình ảnh trống truyền thống Việt Nam">
        </div>
    </div>
</div>

<script>
document.querySelector('form').addEventListener('submit', function(e) {
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    
    if (password.value !== confirmPassword.value) {
        e.preventDefault();
        alert('Mật khẩu xác nhận không khớp!');
    }
});
</script>
