<%@ page contentType="text/html;charset=UTF-8" %>

    <style>
        /* Thêm CSS cho trang contact */
        .contact-info i {
            font-size: 2rem;
            color: var(--bs-primary);
            margin-bottom: 1rem;
        }

        .contact-form {
            background: #f8f9fa;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }

        .map-container {
            height: 400px;
            width: 100%;
            border-radius: 10px;
            overflow: hidden;
        }
    </style>


<main>
    <!-- Banner -->
    <div class="container-fluid  py-5 mb-5" style="margin-top: 100px;">
        <div class="container">
            <h1 class="text-center">LIÊN HỆ VỚI CHÚNG TÔI</h1>
        </div>
    </div>

    <!-- Contact Section -->
    <div class="container my-5">
        <div class="row">
            <div class="contact-info">
                <div class="mb-4 text-center">
                    <i class="bi bi-geo-alt"></i>
                    <h4>Địa Chỉ</h4>
                    <p>123 Đường ABC, Quận 1, TP.HCM</p>
                </div>
                <div class="mb-4 text-center">
                    <i class="bi bi-telephone"></i>
                    <h4>Điện Thoại</h4>
                    <p>Hotline: 123-456-7890</p>
                    <p>Bảo hành: 098-765-4321</p>
                </div>
                <div class="mb-4 text-center">
                    <i class="bi bi-envelope"></i>
                    <h4>Email</h4>
                    <p>info@drumstore.com</p>
                    <p>support@drumstore.com</p>
                </div>
                <div class="mb-4 text-center">
                    <i class="bi bi-clock"></i>
                    <h4>Giờ Làm Việc</h4>
                    <p>Thứ 2 - Chủ nhật: 8:00 - 22:00</p>
                </div>
            </div>

        </div>

        <!-- Bản đồ -->
        <div class="row mt-5">
            <div class="col-12">
                <h3 class="text-center mb-4">BẢN ĐỒ CỬA HÀNG</h3>
                <div class="map-container">
                    <iframe
                            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3919.325247592686!2d106.66372161533417!3d10.786840792314456!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31752ed2392c44df%3A0xd2ecb62e0d050fe9!2sFPT-Aptech%20Computer%20Education%20HCM!5e0!3m2!1sen!2s!4v1642728362543!5m2!1sen!2s"
                            width="100%"
                            height="100%"
                            style="border:0;"
                            allowfullscreen=""
                            loading="lazy">
                    </iframe>
                </div>
            </div>
        </div>
    </div>
</main>
