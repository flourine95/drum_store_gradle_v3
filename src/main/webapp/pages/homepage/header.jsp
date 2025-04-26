<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header>
    <div class="fixed-top d-none d-lg-block">
        <img src="${pageContext.request.contextPath}/assets/images/banners/banner_header.png"
             alt="Tháng Tri Ân Săn Sale"
             class="img-fluid w-100 banner-header">
        <nav class="navbar navbar-expand-lg navbar-light bg-primary">
            <div class="container">
                <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
                    <img src="${pageContext.request.contextPath}/assets/images/logos/logo.png" alt="Logo"
                         style="height: 60px;width: auto">
                </a>
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse"
                        data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false"
                        aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarNav">
                    <form class="search-form d-lg-none">
                        <input class="form-control" type="search" placeholder="Tìm kiếm" aria-label="Search">
                        <button class="btn btn-dark" type="submit">Tìm</button>
                    </form>
                    <div class="navbar-nav mx-auto fw-bold">
                        <a class="nav-link" href="${pageContext.request.contextPath}/home">TRANG CHỦ</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/about">GIỚI THIỆU</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/products">SẢN PHẨM</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/posts">TIN TỨC</a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/contact">LIÊN HỆ</a>
                    </div>
                    <div class="action-buttons d-lg-none">
                        <div class="account-button-container">
                            <div class="d-flex align-items-center">
                                <a href="${pageContext.request.contextPath}/cart"
                                   class="btn btn-light position-relative me-2">
                                    <i class="bi bi-cart3"></i>
                                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cartCount"
                                          style="display: ${sessionScope.cart.itemCount > 0 ? 'block' : 'none'}">
                                        ${sessionScope.cart.itemCount}
                                    </span>
                                </a>
                            </div>
                        </div>

<%--                        <div class="account-button-container dropdown">--%>
<%--                            <button class="btn btn-light w-100" type="button" data-bs-toggle="dropdown"--%>
<%--                                    aria-expanded="false">--%>
<%--                                <i class="bi bi-person-circle"></i>--%>
<%--                            </button>--%>
<%--                            <ul class="dropdown-menu mobile-dropdown-menu">--%>
<%--                                <c:choose>--%>
<%--                                    <c:when test="${empty sessionScope.user}">--%>
<%--                                        <li>--%>
<%--                                            <a id="loginLink" class="dropdown-item" href="${pageContext.request.contextPath}/login">Đăng nhập</a>--%>
<%--                                        </li>--%>
<%--                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/register">Đăng ký</a></li>--%>
<%--                                    </c:when>--%>
<%--                                    <c:otherwise>--%>
<%--                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Thông tin tài khoản</a></li>--%>
<%--                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile?action=wishlist">Sản phẩm yêu thích</a></li>--%>
<%--                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile?action=orders">Quản lý đơn hàng</a></li>--%>
<%--                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile?action=addresses">Danh sách địa chỉ</a></li>--%>
<%--                                        <li><hr class="dropdown-divider"></li>--%>
<%--                                        <li>--%>
<%--                                            <form id="logoutFormUser" action="${pageContext.request.contextPath}/logout" method="POST" class="dropdown-item p-0">--%>
<%--                                                <button type="button" onclick="return logout()"--%>
<%--                                                        class="btn btn-link text-danger text-decoration-none w-100 text-start px-3">--%>
<%--                                                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất--%>
<%--                                                </button>--%>
<%--                                            </form>--%>
<%--                                        </li>--%>
<%--                                    </c:otherwise>--%>
<%--                                </c:choose>--%>
<%--                            </ul>--%>
<%--                        </div>--%>
                    </div>
                    <!-- Desktop search form -->
                    <form class="d-none d-lg-flex mt-lg-0 me-3">
                        <input class="form-control me-2" type="search" placeholder="Tìm kiếm" aria-label="Search">
                        <button class="btn btn-dark" type="submit">Tìm</button>
                    </form>
                    <!-- Desktop action buttons -->
                    <div class="d-none d-lg-flex align-items-center">
                        <a href="${pageContext.request.contextPath}/cart" class="btn btn-light me-3 position-relative">
                            <i class="bi bi-cart-fill"></i>
                            <c:if test="${sessionScope.cart.itemCount > 0}">
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cartCount">
                                        ${sessionScope.cart.itemCount}
                                </span>
                            </c:if>
                        </a>
                        <!-- Account dropdown for desktop -->
                        <div class="dropdown">
                            <button class="btn btn-light dropdown-toggle" type="button" id="desktopAccountDropdown"
                                    data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="bi bi-person-circle"></i>
                            </button>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="desktopAccountDropdown">
                                <c:choose>
                                    <c:when test="${empty sessionScope.user}">
                                        <li>
                                            <a id="loginLink" class="dropdown-item" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                                        </li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/register">Đăng ký</a></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Thông tin tài khoản</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile?action=wishlist">Sản phẩm yêu thích</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile?action=orders">Quản lý đơn hàng</a></li>
                                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile?action=addresses">Danh sách địa chỉ</a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <form id="logoutFormUser" action="${pageContext.request.contextPath}/logout" method="POST" class="dropdown-item p-0">
                                                <button type="button" onclick="return logout()"
                                                        class="btn btn-link text-danger text-decoration-none w-100 text-start px-3">
                                                    <i class="bi bi-box-arrow-right me-2"></i>Đăng xuất
                                                </button>
                                            </form>
                                        </li>
                                    </c:otherwise>
                                </c:choose>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </nav>
    </div>
    <div class="mobile-header d-lg-none">
        <div class="mobile-banner">
            Thổi hồn vào âm nhạc của bạn 🎉
        </div>
        <div class="mobile-main-header">
            <div class="d-flex justify-content-between align-items-center">
                <button class="btn p-0" id="menuToggle">
                    <i class="bi bi-list fs-4"></i>
                </button>
                <a href="${pageContext.request.contextPath}/home" class="logo">
                    <img src="${pageContext.request.contextPath}/assets/images/logos/logo.png" alt="Logo" height="40">
                </a>
                <a href="${pageContext.request.contextPath}/cart" class="position-relative">
                    <i class="bi bi-cart fs-4"></i>
                    <c:if test="${sessionScope.cart.itemCount > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cartCount">
                                ${sessionScope.cart.itemCount}
                        </span>
                    </c:if>
                </a>
            </div>
            <div class="mobile-search">
                <label for="product-search" class="sr-only">Tìm kiếm sản phẩm</label>
                <input id="product-search" type="text" placeholder="Tìm kiếm sản phẩm..."/>
                <button><i class="bi bi-search"></i></button>
            </div>

        </div>
    </div>

    <div class="mobile-side-menu" id="sideMenu">
        <div class="menu-header">
            <div class="d-flex align-items-center">
                <i class="bi bi-person-circle fs-1 me-3"></i>
                <div>
                    <h6 class="mb-1">Xin chào!</h6>
                    <a href="${pageContext.request.contextPath}/login" class="text-primary">Đăng nhập</a>
                </div>
            </div>
        </div>
        <div class="menu-items">
            <a href="${pageContext.request.contextPath}/home" class="menu-item">
                <i class="bi bi-house"></i>
                Trang chủ
            </a>
            <a href="${pageContext.request.contextPath}/products" class="menu-item">
                <i class="bi bi-grid"></i>
                Danh mục sản phẩm
            </a>
            <a href="${pageContext.request.contextPath}/account/orders" class="menu-item">
                <i class="bi bi-bag"></i>
                Đơn hàng của tôi
            </a>
            <a href="${pageContext.request.contextPath}/account/wishlist" class="menu-item">
                <i class="bi bi-heart"></i>
                Sản phẩm yêu thích
            </a>

            <a href="${pageContext.request.contextPath}/account/my-account" class="menu-item">
                <i class="bi bi-person"></i>
                Tài khoản của tôi
            </a>
        </div>
    </div>

    <div class="menu-overlay" id="menuOverlay"></div>

    <nav class="mobile-bottom-nav d-lg-none">
        <div class="mobile-nav-items">
            <a href="${pageContext.request.contextPath}/home" class="mobile-nav-item active">
                <i class="bi bi-house"></i>
                <span>Trang chủ</span>
            </a>
            <a href="${pageContext.request.contextPath}/products" class="mobile-nav-item">
                <i class="bi bi-grid"></i>
                <span>Danh mục</span>
            </a>
            <a href="${pageContext.request.contextPath}/cart" class="mobile-nav-item">
                <i class="bi bi-cart"></i>
                <span>Giỏ hàng</span>
            </a>
            <a href="${pageContext.request.contextPath}/account/my-account" class="mobile-nav-item">
                <i class="bi bi-person"></i>
                <span>Tài khoản</span>
            </a>
        </div>
    </nav>
</header>

<%--<script>--%>
<%--    document.addEventListener("DOMContentLoaded", function() {--%>
<%--        const loginLink = document.getElementById("loginLink");--%>
<%--        loginLink.href = `${loginLink.href}?redirect=${encodeURIComponent(window.location.href)}`;--%>
<%--    });--%>
<%--</script>--%>