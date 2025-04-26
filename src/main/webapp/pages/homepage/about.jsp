<%@ page contentType="text/html;charset=UTF-8" %>
<style>
    .card-body {
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        height: 100%;
    }


    body {
        background-color: #f8f9fa;
    }

    .section-title {
        color: #343a40;
        font-weight: bold;
        text-transform: uppercase;
        margin-bottom: 2rem;
        position: relative;
        padding-bottom: 1rem;
    }

    .section-title::after {
        content: '';
        position: absolute;
        bottom: 0;
        left: 50%;
        transform: translateX(-50%);
        width: 50px;
        height: 3px;
        background-color: var(--bs-primary);
    }

    .card {
        transition: transform 0.3s ease-in-out, box-shadow 0.3s ease-in-out;
    }

    .card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
    }

    .bg-gradient-primary {
        background: linear-gradient(45deg, var(--bs-primary), #007bff);
    }

    .text-primary {
        color: var(--bs-primary) !important;
    }

    .icon-box {
        background-color: #fff;
        border-radius: 10px;
        padding: 2rem;
        text-align: center;
        transition: all 0.3s ease;
    }

    .icon-box:hover {
        background-color: var(--bs-primary);
        color: #fff;
    }

    .icon-box:hover .icon {
        color: #fff;
    }

    .icon-box .icon {
        font-size: 3rem;
        margin-bottom: 1rem;
        color: var(--bs-primary);
    }
</style>
<section id="home" class="vh-100 d-flex align-items-center justify-content-center"
         style="background: linear-gradient(rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.7)), url('/assets/images/helpers/about.jpg') no-repeat center center; background-size: cover;">
    <div class="container text-center text-white">
        <h1 class="display-1 fw-bold mb-4">DRUM STORE</h1>
        <p class="lead mb-4">Tiên phong trong lĩnh vực nhạc cụ từ năm 1993</p>
        <h3 class="mb-5">Hotline: 123-456-7890</h3>
        <a href="${pageContext.request.contextPath}/about" class="btn btn-outline-light btn-lg px-5 py-3">Tìm hiểu thêm</a>
    </div>
</section>

<section id="about" class="py-5">
    <div class="container">
        <h2 class="section-title text-center mb-5">Giới thiệu về Drum Store</h2>
        <div class="row align-items-center">
            <div class="col-md-6 mb-4 mb-md-0">
                <img src="${pageContext.request.contextPath}/assets/images/helpers/pexels-saptashwa-mandal-656231969-17962296.jpg"
                     class="img-fluid rounded shadow-lg" alt="Drum Store">
            </div>
            <div class="col-md-6">
                <p class="lead mb-4">Drum Store được thành lập vào năm 1993 với sứ mệnh mang âm nhạc đến gần hơn với mọi
                    người, đặc biệt là trong lĩnh vực nhạc cụ gõ.</p>
                <p>Trải qua hơn ba thập kỷ hoạt động, Drum Store đã không ngừng phát triển và mở rộng, trở thành một
                    trong những cửa hàng nhạc cụ uy tín hàng đầu tại Việt Nam, chuyên cung cấp các loại trống và phụ
                    kiện chất lượng cao.</p>
                <p>Chúng tôi tự hào là đối tác chính thức của nhiều thương hiệu trống nổi tiếng thế giới như Pearl,
                    Tama, DW, Mapex, Zildjian, Sabian, và nhiều hãng khác, mang đến cho khách hàng những sản phẩm chất
                    lượng nhất.</p>
            </div>
        </div>
    </div>
</section>

<!-- Vision & Mission -->
<section class="py-5 bg-gradient-primary text-white">
    <div class="container">
        <h2 class="section-title text-center text-white mb-5">Tầm nhìn & Sứ mệnh</h2>
        <div class="row">
            <div class="col-lg-6 mb-4 mb-lg-0">
                <div class="card h-100 border-0 shadow-lg">
                    <div class="card-body p-5">
                        <h3 class="card-title text-primary mb-4">Tầm Nhìn</h3>
                        <p class="lead">"Trở thành điểm đến hàng đầu cho những người yêu âm nhạc, nơi họ có thể tìm thấy
                            niềm đam mê và sự sáng tạo không giới hạn."</p>
                        <ul class="list-unstyled mt-4">
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Dẫn đầu thị trường
                                nhạc cụ
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Truyền cảm hứng
                                cho thế hệ nghệ sĩ mới
                            </li>
                            <li><i class="bi bi-check-circle-fill text-success me-2"></i>Đổi mới không ngừng trong công
                                nghệ âm nhạc
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card h-100 border-0 shadow-lg">
                    <div class="card-body p-5">
                        <h3 class="card-title text-primary mb-4">Sứ Mệnh</h3>
                        <p class="lead mb-4">"Mang âm nhạc đến gần hơn với mọi người, tạo nên một xã hội hài hòa và đầy
                            màu sắc."</p>
                        <ul class="list-unstyled">
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Đánh thức và phát
                                triển tình yêu âm nhạc
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Kiến tạo xã hội
                                biết cảm thông và chia sẻ
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Mang lại niềm vui
                                thông qua âm nhạc
                            </li>
                            <li><i class="bi bi-check-circle-fill text-success me-2"></i>Cung cấp thiết bị âm nhạc, âm
                                thanh và giáo dục âm nhạc chất lượng cao
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="values" class="py-5 bg-light">
    <div class="container">
        <h2 class="section-title text-center mb-5">Giá trị cốt lõi</h2>
        <div class="row g-4 justify-content-center">
            <div class="col-md-3">
                <div class="icon-box">
                    <i class="bi bi-award icon"></i>
                    <h4>Chất Lượng</h4>
                    <p>Cam kết 100% sản phẩm chính hãng, đạt tiêu chuẩn quốc tế</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="icon-box">
                    <i class="bi bi-lightbulb icon"></i>
                    <h4>Sáng Tạo</h4>
                    <p>Không ngừng đổi mới, mang đến trải nghiệm âm nhạc độc đáo</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="icon-box">
                    <i class="bi bi-heart icon"></i>
                    <h4>Tận Tâm</h4>
                    <p>Đặt khách hàng làm trọng tâm, mang lại sự hài lòng tuyệt đối</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="icon-box">
                    <i class="bi bi-graph-up-arrow icon"></i>
                    <h4>Phát Triển</h4>
                    <p>Luôn hướng tới sự tiến bộ, nâng cao chất lượng dịch vụ</p>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Services -->
<section id="services" class="py-5">
    <div class="container">
        <h2 class="section-title text-center mb-5">Lĩnh vực hoạt động chính</h2>
        <div class="row g-4">
            <div class="col-lg-6 mb-4">
                <div class="card h-100 border-0 shadow-lg">
                    <div class="card-body p-5">
                        <div class="d-flex align-items-center mb-4">
                            <i class="bi bi-shop text-primary display-4 me-3"></i>
                            <h3 class="card-title mb-0">Thương Mại</h3>
                        </div>
                        <ul class="list-unstyled">
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Phân phối độc
                                quyền hơn 50 thương hiệu quốc tế
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Hệ thống showroom
                                hiện đại trên toàn quốc
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Đa dạng sản phẩm
                                nhạc cụ từ cơ bản đến chuyên nghiệp
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-6 mb-4">
                <div class="card h-100 border-0 shadow-lg">
                    <div class="card-body p-5">
                        <div class="d-flex align-items-center mb-4">
                            <i class="bi bi-music-note-beamed text-primary display-4 me-3"></i>
                            <h3 class="card-title mb-0">Dịch Vụ</h3>
                        </div>
                        <ul class="list-unstyled">
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Đào tạo âm nhạc
                                chuyên nghiệp với giảng viên hàng đầu
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Cho thuê nhạc cụ
                                chất lượng cao cho mọi sự kiện
                            </li>
                            <li class="mb-3"><i class="bi bi-check-circle-fill text-success me-2"></i>Dịch vụ bảo hành &
                                bảo trì chuyên nghiệp, nhanh chóng
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section id="why-choose-us" class="py-5 bg-gradient-primary text-white">
    <div class="container">
        <h2 class="section-title text-center text-white mb-5">Những lý do chọn Drum Store</h2>
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-4 g-4">
            <div class="col">
                <div class="card h-100 bg-transparent border-0">
                    <div class="card-body text-center">
                        <div class="rounded-circle bg-white text-primary d-inline-flex justify-content-center align-items-center mb-4"
                             style="width: 80px; height: 80px;">
                            <i class="bi bi-shield-check display-5"></i>
                        </div>
                        <h4 class="card-title mb-3">100% Hàng chính hãng</h4>
                        <p class="card-text">Cam kết chất lượng từ các thương hiệu uy tín hàng đầu thế giới</p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 bg-transparent border-0">
                    <div class="card-body text-center">
                        <div class="rounded-circle bg-white text-primary d-inline-flex justify-content-center align-items-center mb-4"
                             style="width: 80px; height: 80px;">
                            <i class="bi bi-grid-3x3-gap display-5"></i>
                        </div>
                        <h4 class="card-title mb-3">Đa dạng sản phẩm</h4>
                        <p class="card-text">Hơn 2.000 sản phẩm đa dạng để bạn thoả sức lựa chọn</p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 bg-transparent border-0">
                    <div class="card-body text-center">
                        <div class="rounded-circle bg-white text-primary d-inline-flex justify-content-center align-items-center mb-4"
                             style="width: 80px; height: 80px;">
                            <i class="bi bi-headset display-5"></i>
                        </div>
                        <h4 class="card-title mb-3">Tư vấn chuyên nghiệp</h4>
                        <p class="card-text">Đội ngũ nhân viên am hiểu sâu sắc về âm nhạc và nhạc cụ</p>
                    </div>
                </div>
            </div>
            <div class="col">
                <div class="card h-100 bg-transparent border-0">
                    <div class="card-body text-center">
                        <div class="rounded-circle bg-white text-primary d-inline-flex justify-content-center align-items-center mb-4"
                             style="width: 80px; height: 80px;">
                            <i class="bi bi-truck display-5"></i>
                        </div>
                        <h4 class="card-title mb-3">Giao hàng toàn quốc</h4>
                        <p class="card-text">Dịch vụ vận chuyển nhanh chóng, an toàn đến mọi miền đất nước</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const slides = [
            '/assets/images/helpers/about.jpg',
            '/assets/images/helpers/about2.jpg',
            '/assets/images/helpers/about3.jpg',
            '/assets/images/helpers/about4.jpg',
            '/assets/images/helpers/about5.jpg'
        ];

        const heroSlidesContainer = document.querySelector('.hero-slides');

        // Preload images
        slides.forEach((src, index) => {
            const slide = document.createElement('div');
            slide.className = `hero-slide \${index === 0 ? 'active' : ''}`;
            slide.style.backgroundImage = `linear-gradient(rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.5)), url(\${src})`;
            heroSlidesContainer.appendChild(slide);
        });

        let currentSlide = 0;
        const slideElements = document.querySelectorAll('.hero-slide');

        function nextSlide() {
            slideElements[currentSlide].classList.remove('active');
            currentSlide = (currentSlide + 1) % slides.length;
            slideElements[currentSlide].classList.add('active');
        }

        // Smooth scroll for the "Tìm hiểu thêm" button
        document.querySelector('a[href="/about"]').addEventListener('click', function (e) {
            e.preventDefault();
            document.querySelector('#about').scrollIntoView({
                behavior: 'smooth'
            });
        });

        // Start slideshow
        setInterval(nextSlide, 2000);
    });
</script>
