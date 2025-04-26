<%@ page contentType="text/html;charset=UTF-8" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${title}</title>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/logos/logo.png" type="image/png">
    <script src="${pageContext.request.contextPath}/assets/lib/jquery-3.7.1/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/lib/bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/lib/sweetalert2-11.17.2/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/bootstrap-5.3.3-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/bootstrap-icons-1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/fontawesome-free-5.15.4-web/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/animate.css-4.1.1/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/sweetalert2-11.17.2/sweetalert2.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css">
    <style>
        .dropdown-menu a {
            cursor: pointer;
        }

        .navbar-nav .nav-link {
            position: relative;
            padding: 0.5rem 1rem;
            margin: 0 0.2rem;
            transition: all 0.3s ease;
            color: black;
        }

        .navbar-nav .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background-color: var(--hover-color);
            transition: width 0.3s ease;
        }

        .navbar-nav .nav-link:hover::after {
            width: 100%;
        }

        .navbar-nav .nav-link:hover {
            color: whitesmoke;
        }

        .custom-box {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            text-decoration: none;
            background: linear-gradient(145deg, var(--bs-primary), #f1dc4f);
            border-radius: 8px;
            border: none;
            padding: 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .custom-box:hover {
            transform: translateY(-5px) scale(1.02);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }


        .card {
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .card-title {
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .card-body {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
        }

        .card-body .btn {
            margin-top: auto;
        }

        @media (max-width: 991.98px) {

            :root {
                --header-height: 60px;
                --bottom-nav-height: 60px;
                --primary-color: #0d6efd;
                --secondary-color: #f8f9fa;
            }

            /* Mobile Header */
            .mobile-header {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1030;
                background: #fff;
            }

            .mobile-banner {
                background: linear-gradient(90deg, var(--primary-color), #ffea6f);
                padding: 6px;
                text-align: center;
                font-size: 0.85rem;
                font-weight: 500;
                color: #fff;
            }

            .mobile-main-header {
                padding: 10px 15px;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
            }

            /* Improved Search Bar */
            .mobile-search {
                position: relative;
                margin: 12px 0 8px;
            }

            .mobile-search input {
                width: 100%;
                padding: 12px 45px 12px 20px;
                border: none;
                border-radius: 25px;
                background: var(--secondary-color);
                font-size: 0.95rem;
            }

            .mobile-search button {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                border: none;
                background: none;
                color: #666;
            }

            /* Side Menu Improvements */
            .mobile-side-menu {
                position: fixed;
                top: 0;
                left: -300px;
                width: 300px;
                height: 100vh;
                background: #fff;
                z-index: 1040;
                transition: 0.3s ease-out;
                overflow-y: auto;
            }

            .mobile-side-menu.active {
                left: 0;
                box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            }

            .menu-header {
                padding: 20px;
                background: var(--secondary-color);
                border-bottom: 1px solid #eee;
            }

            .menu-items {
                padding: 15px 0;
            }

            .menu-item {
                display: flex;
                align-items: center;
                padding: 12px 20px;
                color: #333;
                text-decoration: none;
                transition: 0.2s;
            }

            .menu-item:hover {
                background: var(--secondary-color);
            }

            .menu-item i {
                margin-right: 15px;
                font-size: 1.2rem;
                color: var(--primary-color);
            }

            /* Bottom Navigation */
            .mobile-bottom-nav {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background: #fff;
                box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
                z-index: 1030;
                padding: 8px 0 5px;
            }

            .mobile-nav-items {
                display: flex;
                justify-content: space-around;
            }

            .mobile-nav-item {
                display: flex;
                flex-direction: column;
                align-items: center;
                color: #666;
                text-decoration: none;
                font-size: 0.8rem;
                padding: 5px;
            }

            .mobile-nav-item i {
                font-size: 1.4rem;
                margin-bottom: 4px;
            }

            .mobile-nav-item.active {
                color: var(--primary-color);
            }

            /* Overlay */
            .menu-overlay {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: rgba(0, 0, 0, 0.5);
                z-index: 1035;
                opacity: 0;
                visibility: hidden;
                transition: 0.3s;
            }

            .menu-overlay.active {
                opacity: 1;
                visibility: visible;
            }

            /* Main Content Adjustment */
            main {
                padding-top: calc(var(--header-height) + 10px);
                padding-bottom: calc(var(--bottom-nav-height) + 10px);
            }

            /* Cart Badge */
            .cart-badge {
                position: absolute;
                top: -5px;
                right: -8px;
                background: #dc3545;
                color: white;
                border-radius: 50%;
                padding: 3px 6px;
                font-size: 0.7rem;
            }

        }
    </style>

</head>

<body>
<jsp:include page="header.jsp"/>
<main>
    <jsp:include page="${content}"/>
</main>
<jsp:include page="footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/ajax-utils.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/auth.js"></script>
<script>
    const adjustDesktopPadding = () => {
        if (window.innerWidth >= 992) {
            const header = document.querySelector('.fixed-top');
            const main = document.querySelector('main');
            if (header && main) {
                const headerHeight = header.offsetHeight - 85;
                main.style.paddingTop = headerHeight + 'px';
            }
        }
    };

    const adjustMobilePadding = () => {
        if (window.innerWidth < 992) {
            const mobileHeader = document.querySelector('.mobile-header');
            const main = document.querySelector('main');
            if (mobileHeader && main) {
                const headerHeight = mobileHeader.offsetHeight;
                document.documentElement.style.setProperty('--header-height', `${headerHeight}px`);
                main.style.paddingTop = `${headerHeight}px`;
            }
        }
    };

    const adjustLayoutPadding = () => {
        const main = document.querySelector('main');
        if (main) {
            main.style.paddingTop = '0';
        }

        if (window.innerWidth >= 992) {
            adjustDesktopPadding();
        } else {
            adjustMobilePadding();
        }
    };

    const initMobileMenu = () => {
        const menuToggle = document.getElementById('menuToggle');
        const sideMenu = document.getElementById('sideMenu');
        const menuOverlay = document.getElementById('menuOverlay');

        if (menuToggle && sideMenu && menuOverlay) {
            menuToggle.addEventListener('click', () => {
                sideMenu.classList.add('active');
                menuOverlay.classList.add('active');
                document.body.style.overflow = 'hidden';
            });

            menuOverlay.addEventListener('click', () => {
                sideMenu.classList.remove('active');
                menuOverlay.classList.remove('active');
                document.body.style.overflow = '';
            });
        }
    };

    window.addEventListener('load', () => {
        adjustLayoutPadding();
        initMobileMenu();

        const headerImages = document.querySelectorAll('header img');
        headerImages.forEach(img => {
            img.addEventListener('load', adjustLayoutPadding);
        });
    });

    window.addEventListener('resize', () => {
        adjustLayoutPadding();
    });
</script>

</body>
</html>