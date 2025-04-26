<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    :root {
        --primary-color: #1B2832;
        --text-color: #4A5568;
        --link-color: #3182CE;
        --border-color: #E2E8F0;
        --input-bg: #F8FAFC;
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

    .form-label {
        font-weight: 500;
        color: var(--primary-color);
        margin-bottom: 0.5rem;
    }

    .login-form .form-control {
        padding: 0.75rem 1rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background-color: var(--input-bg);
    }

    .login-form .form-control:focus {
        box-shadow: none;
        border-color: var(--link-color);
    }

    .forgot-password {
        text-align: right;
        margin-bottom: 1.5rem;
    }

    .forgot-password a {
        color: var(--link-color);
        text-decoration: none;
    }

    .btn-signin {
        width: 100%;
        padding: 0.75rem;
        background-color: var(--bs-primary);
        border: none;
        border-radius: 0.5rem;
        color: var(--text-color);
        font-weight: 600;
        margin-bottom: 1.5rem;
        transition: all 0.2s ease;
    }

    .btn-signin:hover {
        background-color: #fcc419;
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(255, 221, 0, 0.3);
    }

    .divider {
        text-align: center;
        margin: 1.5rem 0;
        color: var(--text-color);
    }

    .social-signin {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 1rem;
        margin: 0 auto;
    }

    .social-signin .btn {
        width: 100%;
        padding: 0.75rem 1rem;
        border: 1px solid var(--border-color);
        border-radius: 0.5rem;
        background-color: white;
        font-weight: 500;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 0.75rem;
        transition: all 0.2s ease;
    }

    .social-signin .btn:hover {
        background-color: var(--input-bg);
        border-color: var(--primary-color);
    }

    .social-signin svg {
        width: 24px;
        height: 24px;
    }

    .signup-text {
        text-align: center;
        color: var(--text-color);
        margin-top: 2rem;
    }

    .signup-text a {
        color: var(--link-color);
        text-decoration: none;
        font-weight: 500;
    }

    @media (max-width: 768px) {
        .image-section {
            display: none;
        }
    }

    @media (max-width: 576px) {
        .social-signin {
            grid-template-columns: 1fr;
        }
    }

    .alert {
        padding: 1rem;
        border-radius: 0.5rem;
        margin-bottom: 1.5rem;
        font-size: 0.95rem;
    }

    .alert-success {
        background-color: #DCFCE7;
        border: 1px solid #86EFAC;
        color: #16A34A;
        display: flex;
        align-items: center;
        gap: 0.5rem;
    }

    .alert i {
        font-size: 1.1rem;
    }
</style>
<div class="container-fluid">
    <div class="row login-container">
        <div class="col-md-5 form-section">
            <h1 class="welcome-text">Chào mừng trở lại 👋</h1>
            <p class="welcome-subtext">
                Drum Store – Nơi nhịp trống hòa quyện giữa truyền thống và hiện đại, kết nối đam mê âm nhạc.
            </p>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                        ${sessionScope.successMessage}
                </div>
                <%
                    request.getSession().removeAttribute("successMessage");
                %>
            </c:if>
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <c:if test="${not empty errors.general}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>${errors.general}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/login" method="POST" class="login-form">
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
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

                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input type="password"
                           class="form-control ${not empty errors.password ? 'is-invalid' : ''}"
                           id="password"
                           name="password"
                           placeholder="Nhập mật khẩu"
                           required>
                    <c:if test="${not empty errors.password}">
                        <div class="error-message">
                            <i class="fas fa-exclamation-circle"></i>
                                ${errors.password}
                        </div>
                    </c:if>
                </div>

                <div class="forgot-password">
                    <a href="${pageContext.request.contextPath}/forgot-password">Quên mật khẩu?</a>
                </div>

                <button type="submit" class="btn btn-signin">Đăng nhập</button>


                <div class="divider">Hoặc</div>

                <div class="social-signin">
                    <button type="button"
                            onclick="window.location.href='${pageContext.request.contextPath}/login/google'"
                            class="btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 48 48">
                            <path fill="#FFC107"
                                  d="M43.611,20.083H42V20H24v8h11.303c-1.649,4.657-6.08,8-11.303,8c-6.627,0-12-5.373-12-12 c0-6.627,5.373-12,12-12c3.059,0,5.842,1.154,7.961,3.039l5.657-5.657C34.046,6.053,29.268,4,24,4 C12.955,4,4,12.955,4,24c0,11.045,8.955,20,20,20c11.045,0,20-8.955,20-20C44,22.659,43.862,21.35,43.611,20.083z"></path>
                            <path fill="#FF3D00"
                                  d="M6.306,14.691l6.571,4.819C14.655,15.108,18.961,12,24,12c3.059,0,5.842,1.154,7.961,3.039 l5.657-5.657C34.046,6.053,29.268,4,24,4C16.318,4,9.656,8.337,6.306,14.691z"></path>
                            <path fill="#4CAF50"
                                  d="M24,44c5.166,0,9.86-1.977,13.409-5.192l-6.19-5.238C29.211,35.091,26.715,36,24,36 c-5.202,0-9.619-3.317-11.283-7.946l-6.522,5.025C9.505,39.556,16.227,44,24,44z"></path>
                            <path fill="#1976D2"
                                  d="M43.611,20.083H42V20H24v8h11.303c-0.792,2.237-2.231,4.166-4.087,5.571c0.001-0.001,0.002-0.001,0.003-0.002l6.19,5.238C36.971,39.205,44,34,44,24 C44,22.659,43.862,21.35,43.611,20.083z"></path>
                        </svg>
                        Google
                    </button>

                    <button type="button" class="btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 48 48">
                            <path fill="#039be5" d="M24 5A19 19 0 1 0 24 43A19 19 0 1 0 24 5Z"></path>
                            <path fill="#fff"
                                  d="M26.572,29.036h4.917l0.772-4.995h-5.69v-2.73c0-2.075,0.678-3.915,2.619-3.915h3.119v-4.359c-0.548-0.074-1.707-0.236-3.897-0.236c-4.573,0-7.254,2.415-7.254,7.917v3.323h-4.701v4.995h4.701v13.729C22.089,42.905,23.032,43,24,43c0.875,0,1.729-0.08,2.572-0.194V29.036z"></path>
                        </svg>
                        Facebook
                    </button>
                </div>

                <div class="signup-text">
                    Bạn chưa có tài khoản? <a href="${pageContext.request.contextPath}/register">Đăng ký ngay</a>
                </div>

            </form>
        </div>

        <div class="col-md-7 image-section">
            <img src="${pageContext.request.contextPath}/assets/images/login.webp"
                 alt="Hình ảnh trống truyền thống Việt Nam">
        </div>
    </div>
</div>

<%--hiển thị thonong báo xác thực --%>
<div class="modal fade" id="verifyModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Xác thực tài khoản</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <p>Tài khoản của bạn chưa được xác thực. Vui lòng kiểm tra email để xác thực.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                <a href="${pageContext.request.contextPath}/verify-token" class="btn btn-primary">Xác
                    thực ngay</a>
            </div>
        </div>
    </div>
</div>

<%-- Kiểm tra nếu `notVerify` là `true` thì hiển thị modal --%>
<script>
    <% if (request.getAttribute("not-verify") != null) { %>
    var myModal = new bootstrap.Modal(document.getElementById('verifyModal'));
    myModal.show();
    <% } %>
</script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const alert = document.querySelector('.alert-success');
        if (alert) {
            setTimeout(function () {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(function () {
                    alert.style.display = 'none';
                }, 500);
            }, 5000);
        }
    });
</script>
