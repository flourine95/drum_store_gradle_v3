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
        line-height: 1.6;
    }

    .form-group {
        margin-bottom: 1.25rem;
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

    .info-text {
        font-size: 0.875rem;
        color: var(--text-color);
        margin: 1rem 0;
        padding: 1rem;
        background-color: #f8f9fa;
        border-radius: 0.5rem;
        border-left: 4px solid var(--bs-primary);
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
            <h1 class="welcome-text">Quên mật khẩu? 🔑</h1>
            <p class="welcome-subtext">
                Đừng lo lắng! Chúng tôi sẽ giúp bạn khôi phục mật khẩu.<br>
                Hãy nhập email đã đăng ký, chúng tôi sẽ gửi hướng dẫn đến bạn.
            </p>

            <c:if test="${not empty errors.general}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${errors.general}
                </div>
            </c:if>

            <c:if test="${not empty successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${successMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/forgot-password" method="post">
                <input type="hidden" name="action" value="request">
                <div class="form-group">
                    <label class="form-label" for="email">Email</label>
                    <input type="email" 
                           class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                           id="email" 
                           name="email"
                           placeholder="Nhập email đã đăng ký" 
                           value="${oldInput.email}"
                           required>
                    <c:if test="${not empty errors.email}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.email}
                        </div>
                    </c:if>
                </div>

                <div class="info-text">
                    <i class="fas fa-info-circle"></i>
                    Sau khi nhập email, bạn sẽ nhận được một liên kết để đặt lại mật khẩu.
                    Liên kết này chỉ có hiệu lực trong vòng 30 phút.
                </div>

                <button type="submit" class="btn btn-reset">Gửi yêu cầu đặt lại mật khẩu</button>

                <div class="back-to-login">
                    <a href="${pageContext.request.contextPath}/login">
                        <i class="fas fa-arrow-left"></i> Quay lại trang đăng nhập
                    </a>
                </div>
            </form>
        </div>

        <div class="col-md-7 image-section">
            <img src="${pageContext.request.contextPath}/assets/images/login.webp"
                 alt="Hình ảnh trống truyền thống Việt Nam">
        </div>
    </div>
</div>
