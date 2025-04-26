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
        margin-bottom: 2rem;
        font-size: 1.1rem;
    }

    .form-group {
        margin-bottom: 1.25rem;
    }

    .form-label {
        font-weight: 500;
        color: var(--primary-color);
        margin-bottom: 0.5rem;
    }

    .register-form .form-control {
        padding: 0.75rem 1rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background-color: var(--input-bg);
        color: var(--text-color);
    }

    .register-form .form-control:focus {
        box-shadow: none;
        border-color: var(--link-color);
    }

    .register-form .form-control.is-invalid {
        border-color: var(--error-color);
        background-image: none;
    }

    .btn-register {
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

    .btn-register:hover {
        background-color: #fcc419;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 221, 0, 0.3);
    }

    .terms-text {
        font-size: 0.875rem;
        color: var(--text-color);
        margin: 1rem 0;
    }

    .terms-text a {
        color: var(--link-color);
        text-decoration: none;
    }

    .login-link {
        text-align: center;
        color: var(--text-color);
        margin-top: 1.5rem;
    }

    .login-link a {
        color: var(--link-color);
        text-decoration: none;
        font-weight: 500;
    }

    .required-field::after {
        content: "*";
        color: var(--error-color);
        margin-left: 4px;
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
</style>
<div class="container-fluid">
    <div class="row login-container">
        <div class="col-md-5 form-section">
            <h1 class="welcome-text">Tạo tài khoản mới 🎵</h1>
            <p class="welcome-subtext">
                Khám phá âm nhạc truyền thống Việt Nam.<br>
                Bắt đầu hành trình của bạn với chúng tôi.
            </p>

            <c:if test="${not empty errors.general}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${errors.general}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="POST" class="register-form">
                <div class="form-group">
                    <label class="form-label required-field" for="fullName">Họ và tên</label>
                    <input type="text" 
                           class="form-control ${not empty errors.fullname ? 'is-invalid' : ''}" 
                           id="fullName" 
                           name="fullname"
                           placeholder="Nhập họ và tên đầy đủ" 
                           value="${oldInput.fullname}"
                           required>
                    <c:if test="${not empty errors.fullname}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.fullname}
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label required-field" for="email">Email</label>
                    <input type="email" 
                           class="form-control ${not empty errors.email ? 'is-invalid' : ''}" 
                           id="email" 
                           name="email"
                           placeholder="vidu@email.com" 
                           value="${oldInput.email}"
                           required>
                    <c:if test="${not empty errors.email}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.email}
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label required-field" for="phone">Số điện thoại</label>
                    <input type="tel" 
                           class="form-control ${not empty errors.phone ? 'is-invalid' : ''}" 
                           id="phone" 
                           name="phone"
                           placeholder="0xxxxxxxxx" 
                           value="${oldInput.phone}"
                           required>
                    <c:if test="${not empty errors.phone}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.phone}
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label required-field" for="password">Mật khẩu</label>
                    <input type="password" 
                           class="form-control ${not empty errors.password ? 'is-invalid' : ''}" 
                           id="password" 
                           name="password"
                           placeholder="Tối thiểu 8 ký tự" 
                           required>
                    <c:if test="${not empty errors.password}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.password}
                        </div>
                    </c:if>
                </div>

                <div class="form-group">
                    <label class="form-label required-field" for="confirmPassword">Xác nhận mật khẩu</label>
                    <input type="password" 
                           class="form-control ${not empty errors.confirmPassword ? 'is-invalid' : ''}" 
                           id="confirmPassword" 
                           name="confirmPassword"
                           placeholder="Nhập lại mật khẩu"
                           required>
                    <c:if test="${not empty errors.confirmPassword}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.confirmPassword}
                        </div>
                    </c:if>
                </div>

                <div class="terms-text">
                    <input type="checkbox" 
                           id="terms" 
                           name="terms"
                           class="${not empty errors.terms ? 'is-invalid' : ''}"
                           required>
                    <label for="terms">
                        Tôi đồng ý với <a href="#">Điều khoản sử dụng</a> và <a href="#">Chính sách bảo mật</a>
                    </label>
                    <c:if test="${not empty errors.terms}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                            ${errors.terms}
                        </div>
                    </c:if>
                </div>

                <button type="submit" class="btn btn-register">Đăng ký</button>

                <div class="login-link">
                    Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập ngay</a>
                </div>
            </form>
        </div>

        <div class="col-md-7 image-section">
            <img src="${pageContext.request.contextPath}/assets/images/register.webp"
                 alt="Hình ảnh trống truyền thống Việt Nam">
        </div>
    </div>
</div>
