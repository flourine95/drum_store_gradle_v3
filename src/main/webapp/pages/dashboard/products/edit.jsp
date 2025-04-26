<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    #sortableImageGrid {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
    }

    .image-item {
        width: 200px;
        position: relative;
        cursor: grab;
    }

    .image-item .card {
        width: 100%;
        overflow: hidden;
        border: 1px solid #ccc;
        border-radius: 6px;
    }

    .image-item img.image-preview {
        width: 100%;
        height: 150px;
        object-fit: cover;
    }
    
    .image-item .card-body {
        background-color: #f8f9fa;
    }
</style>
<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4 class="card-title">Quản lý sản phẩm: ${product.name}</h4>
                    <a href="${pageContext.request.contextPath}/dashboard/products" class="btn btn-secondary">Quay lại
                        danh sách</a>
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                                ${error}
                        </div>
                    </c:if>
                    <c:if test="${not empty success}">
                        <div class="alert alert-success" role="alert">
                                ${success}
                        </div>
                    </c:if>

                    <!-- Nav tabs -->
                    <ul class="nav nav-tabs" id="productTabs" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="info-tab" data-bs-toggle="tab" data-bs-target="#info"
                                    type="button" role="tab" aria-controls="info" aria-selected="true">Thông tin cơ bản
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="images-tab" data-bs-toggle="tab" data-bs-target="#images"
                                    type="button" role="tab" aria-controls="images" aria-selected="false">Hình ảnh
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="colors-tab" data-bs-toggle="tab" data-bs-target="#colors"
                                    type="button" role="tab" aria-controls="colors" aria-selected="false">Màu sắc
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="addons-tab" data-bs-toggle="tab" data-bs-target="#addons"
                                    type="button" role="tab" aria-controls="addons" aria-selected="false">Phụ kiện
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="variants-tab" data-bs-toggle="tab" data-bs-target="#variants"
                                    type="button" role="tab" aria-controls="variants" aria-selected="false">Biến thể
                            </button>
                        </li>
                    </ul>

                    <!-- Tab content -->
                    <div class="tab-content p-3 border border-top-0 rounded-bottom" id="productTabContent">
                        <!-- Basic Info Tab -->
                        <div class="tab-pane fade show active" id="info" role="tabpanel" aria-labelledby="info-tab">
                            <form id="basicInfoForm" class="needs-validation" novalidate method="post"
                                  action="${pageContext.request.contextPath}/dashboard/products">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${product.id}">
                                <input type="hidden" name="updateType" value="basic-info">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="name" class="form-label">Tên sản phẩm</label>
                                        <input type="text" class="form-control" id="name" name="name"
                                               value="${product.name}" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="basePrice" class="form-label">Giá cơ bản</label>
                                        <input type="number" class="form-control" id="basePrice" name="basePrice"
                                               value="${product.basePrice}" required>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="categoryId" class="form-label">Danh mục</label>
                                        <select class="form-select" id="categoryId" name="categoryId" required>
                                            <c:forEach items="${categories}" var="category">
                                                <option value="${category.id}" ${category.id == product.categoryId ? 'selected' : ''}>${category.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="brandId" class="form-label">Thương hiệu</label>
                                        <select class="form-select" id="brandId" name="brandId" required>
                                            <c:forEach items="${brands}" var="brand">
                                                <option value="${brand.id}" ${brand.id == product.brandId ? 'selected' : ''}>${brand.name}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="stockManagementType" class="form-label">Kiểu quản lý tồn kho</label>

                                        <select class="form-select" id="stockManagementType" name="stockManagementType"
                                                required>
                                            <c:forEach items="${stockManagementTypes}" var="type">
                                                <option value="${type.value}" ${type.value == product.stockManagementType ? 'selected' : ''}>
                                                    <c:choose>
                                                        <c:when test="${type.value == 0}">Đơn giản (không có biến thể)</c:when>
                                                        <c:when test="${type.value == 1}">Chỉ màu sắc</c:when>
                                                        <c:when test="${type.value == 2}">Chỉ phụ kiện</c:when>
                                                        <c:when test="${type.value == 3}">Màu sắc và phụ kiện</c:when>
                                                    </c:choose>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-check mt-4">
                                            <input class="form-check-input" type="checkbox" id="isFeatured"
                                                   name="isFeatured" ${product.featured ? 'checked' : ''}>
                                            <label class="form-check-label" for="isFeatured">Sản phẩm nổi bật</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label for="description" class="form-label">Mô tả</label>
                                    <textarea class="form-control editor" id="description" name="description"
                                              rows="5">${product.description}</textarea>
                                </div>
                                <button type="submit" class="btn btn-primary">Lưu thông tin cơ bản</button>
                            </form>
                        </div>

                        <!-- Images Tab -->
                        <div class="tab-pane fade" id="images" role="tabpanel" aria-labelledby="images-tab">
                            <div id="imagesContainer">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${product.id}">
                                <input type="hidden" name="updateType" value="images">
                                <input type="hidden" name="imageOrder" id="imageOrder" value="">

                                <!-- Images List Section -->
                                <div class="mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h5>Danh sách hình ảnh</h5>
                                        <button type="button" class="btn btn-primary" id="addImageBtn">Thêm
                                            ảnh mới
                                        </button>
                                    </div>

                                    <p class="text-muted mb-2"><i class="fas fa-info-circle"></i> Kéo và thả để sắp xếp
                                        thứ tự hình ảnh.</p>

                                    <div class="image-grid mb-4" id="sortableImageGrid">
                                        <c:forEach items="${product.images}" var="image" varStatus="status">
                                            <div class="image-item" data-id="${image.id}">
                                                <div class="card">
                                                    <img src="${image.image}" class="card-img-top image-preview"
                                                         alt="Product image" onError="this.onerror=null; this.src='https://via.placeholder.com/150';">
                                                    <div class="card-body p-2">
                                                        <div class="form-check mb-2">
                                                            <input class="form-check-input main-image-radio"
                                                                   type="radio"
                                                                   name="mainImageId" value="${image.id}"
                                                                   id="mainImage_${image.id}"
                                                                ${image.main ? 'checked' : ''}>
                                                            <label class="form-check-label" for="mainImage_${image.id}">Ảnh chính</label>
                                                        </div>
                                                        <div class="d-grid">
                                                            <button type="button"
                                                                    class="btn btn-sm btn-danger remove-image-btn">
                                                                <i class="fas fa-trash"></i> Xóa ảnh
                                                            </button>
                                                        </div>
                                                        <input type="hidden" name="imageIds[]" value="${image.id}">
                                                        <input type="hidden" name="imageUrls[]" value="${image.image}">
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <button type="button" id="saveImagesBtn" class="btn btn-primary">Lưu thay đổi</button>
                                <div id="imagesUpdateStatus" class="mt-3"></div>
                            </div>
                        </div>

                        <!-- Colors Tab -->
                        <div class="tab-pane fade" id="colors" role="tabpanel" aria-labelledby="colors-tab">
                            <form id="colorsForm" class="needs-validation" novalidate method="post"
                                  action="${pageContext.request.contextPath}/dashboard/products">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${product.id}">
                                <input type="hidden" name="updateType" value="colors">
                                <div id="colorsList">
                                    <c:forEach items="${product.colors}" var="color" varStatus="status">
                                        <div class="row mb-3 color-item">
                                            <input type="hidden" name="colorIds[]" value="${color.id}">
                                            <div class="col-md-5">
                                                <input type="text" class="form-control" name="colorNames[]"
                                                       value="${color.name}" placeholder="Tên màu" required>
                                            </div>
                                            <div class="col-md-5">
                                                <input type="number" class="form-control" name="colorPrices[]"
                                                       value="${color.additionalPrice}" placeholder="Giá thêm" required>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="button" class="btn btn-danger remove-color-btn">Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <button type="button" class="btn btn-secondary mb-3" id="addColorBtn">Thêm màu mới
                                </button>
                                <button type="submit" class="btn btn-primary">Lưu màu sắc</button>
                            </form>
                        </div>

                        <!-- Addons Tab -->
                        <div class="tab-pane fade" id="addons" role="tabpanel" aria-labelledby="addons-tab">
                            <form id="addonsForm" class="needs-validation" novalidate method="post"
                                  action="${pageContext.request.contextPath}/dashboard/products">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${product.id}">
                                <input type="hidden" name="updateType" value="addons">
                                <div id="addonsList">
                                    <c:forEach items="${product.addons}" var="addon" varStatus="status">
                                        <div class="row mb-3 addon-item">
                                            <input type="hidden" name="addonIds[]" value="${addon.id}">
                                            <div class="col-md-5">
                                                <input type="text" class="form-control" name="addonNames[]"
                                                       value="${addon.name}" placeholder="Tên phụ kiện" required>
                                            </div>
                                            <div class="col-md-5">
                                                <input type="number" class="form-control" name="addonPrices[]"
                                                       value="${addon.additionalPrice}" placeholder="Giá thêm" required>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="button" class="btn btn-danger remove-addon-btn">Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <button type="button" class="btn btn-secondary mb-3" id="addAddonBtn">Thêm phụ kiện
                                    mới
                                </button>
                                <button type="submit" class="btn btn-primary">Lưu phụ kiện</button>
                            </form>
                        </div>

                        <!-- Variants Tab -->
                        <div class="tab-pane fade" id="variants" role="tabpanel" aria-labelledby="variants-tab">
                            <form id="variantsForm" class="needs-validation" novalidate method="post"
                                  action="${pageContext.request.contextPath}/dashboard/products">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${product.id}">
                                <input type="hidden" name="updateType" value="variants">
                                <div id="variantsList">
                                    <c:forEach items="${product.variants}" var="variant" varStatus="status">
                                        <div class="row mb-3 variant-item">
                                            <input type="hidden" name="variantIds[]" value="${variant.id}">
                                            <div class="col-md-3">
                                                <select class="form-select" name="variantColorIds[]">
                                                    <option value="">Không có màu</option>
                                                    <c:forEach items="${product.colors}" var="color">
                                                        <option value="${color.id}" ${color.id == variant.colorId ? 'selected' : ''}>${color.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-select" name="variantAddonIds[]">
                                                    <option value="">Không có phụ kiện</option>
                                                    <c:forEach items="${product.addons}" var="addon">
                                                        <option value="${addon.id}" ${addon.id == variant.addonId ? 'selected' : ''}>${addon.name}</option>
                                                    </c:forEach>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <input type="number" class="form-control" name="variantStocks[]"
                                                       value="${variant.stock}" placeholder="Tồn kho" required>
                                            </div>
                                            <div class="col-md-2">
                                                <select class="form-select" name="variantStatuses[]">
                                                    <option value="1" ${variant.status == 1 ? 'selected' : ''}>Hoạt
                                                        động
                                                    </option>
                                                    <option value="0" ${variant.status == 0 ? 'selected' : ''}>Tạm ẩn
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-md-2">
                                                <button type="button" class="btn btn-danger remove-variant-btn">Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                                <button type="button" class="btn btn-secondary mb-3" id="addVariantBtn">Thêm biến
                                    thể mới
                                </button>
                                <button type="submit" class="btn btn-primary">Lưu biến thể</button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.ckeditor.com/ckeditor5/43.1.0/ckeditor5.umd.js"></script>
<script src="https://cdn.ckbox.io/ckbox/2.6.1/ckbox.js"></script>
<link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/43.1.0/ckeditor5.css"/>
<link rel="stylesheet" href="https://cdn.ckbox.io/ckbox/2.6.1/styles/themes/lark.css">
<script>
    $(document).ready(() => {
        Sortable.create($('#sortableImageGrid')[0], {
            animation: 150,
            onEnd: function () {
                updateImageOrder();
            }
        });

        // Thêm ảnh mới
        $("#addImageBtn").on("click", () => {
            $("<input>", {
                type: "file",
                accept: "image/*",
                multiple: true
            }).on("change", e => {
                const files = e.target.files;
                if (files && files.length > 0) {
                    handleMultipleImageUpload(files);
                }
            }).trigger("click");
        });

        // Cập nhật thứ tự ảnh
        const updateImageOrder = () => {
            const orderArray = $('#sortableImageGrid .image-item').map(function () {
                return $(this).data('id');
            }).get();
            $('#imageOrder').val(orderArray.join(','));
        };

        // Thêm ảnh vào danh sách
        const addImageToList = (imageUrl) => {
            const tempId = 'new_' + new Date().getTime();

            const template = `
            <div class="image-item" data-id="\${tempId}">
                <div class="card">
                    <img src="\${imageUrl}" class="card-img-top image-preview" alt="Product image" onError="this.onerror=null; this.src='https://via.placeholder.com/150';">
                    <div class="card-body p-2">
                        <div class="form-check mb-2">
                            <input class="form-check-input main-image-radio" type="radio"
                                   name="mainImageId" value="\${tempId}" id="mainImage_\${tempId}">
                            <label class="form-check-label" for="mainImage_\${tempId}">
                                Ảnh chính
                            </label>
                        </div>
                        <div class="d-grid">
                            <button type="button" class="btn btn-sm btn-danger remove-image-btn">
                                <i class="fas fa-trash"></i> Xóa ảnh
                            </button>
                        </div>
                        <input type="hidden" name="imageIds[]" value="\${tempId}">
                        <input type="hidden" name="imageUrls[]" value="\${imageUrl}">
                    </div>
                </div>
            </div>
        `;

            $('#sortableImageGrid').append(template);
            updateImageOrder();
        };

        // Xử lý upload ảnh
        async function handleMultipleImageUpload(files) {
            const totalFiles = files.length;
            
            Swal.fire({
                title: `Đang tải \${totalFiles} ảnh lên...`,
                html: `Đã xử lý: <b>0</b>/\${totalFiles}`,
                allowOutsideClick: false,
                showConfirmButton: false,
                didOpen: () => {
                    Swal.showLoading();
                }
            });
            
            let successCount = 0;
            let errorCount = 0;
            let authHeader = null;
            
            try {
                // Lấy token mật để upload ảnh
                const tokenRes = await fetch('/api/keys?service=ckbox-dev');
                if (!tokenRes.ok) throw new Error('Không thể lấy token');
                authHeader = await tokenRes.text();
                
                // Xử lý upload từng ảnh
                for (let i = 0; i < totalFiles; i++) {
                    const file = files[i];
                    
                    try {
                        // Cập nhật thông tin xử lý
                        Swal.update({
                            html: `Đã xử lý: <b>\${i}</b>/\${totalFiles}`
                        });
                        
                        // Tạo FormData cho từng ảnh
                        const formData = new FormData();
                        formData.append('file', file);
                        formData.append('categoryId', '9ab973c3-9976-405f-8982-25618fb862a7');
                        
                        // Gửi request
                        const uploadRes = await fetch('https://api.ckbox.io/assets', {
                            method: 'POST',
                            headers: {'Authorization': authHeader},
                            body: formData
                        });
                        
                        if (!uploadRes.ok) throw new Error(`Tải ảnh \${i+1} thất bại`);
                        
                        const data = await uploadRes.json();
                        
                        const imageUrl = [
                            data.imageUrls?.default, data.url, data.urls?.default,
                            data.url?.default, data.defaultUrl, data.image, data.imageUrl
                        ].find(Boolean) || 'https://via.placeholder.com/150';
                        
                        const finalUrl = imageUrl.endsWith('.webp') ? imageUrl.replace('.webp', '.jpeg') : imageUrl;
                        
                        // Thêm ảnh vào danh sách
                        addImageToList(finalUrl);
                        successCount++;
                        
                    } catch (uploadErr) {
                        console.error(`Lỗi khi tải ảnh \${i+1}:`, uploadErr);
                        errorCount++;
                    }
                }
                
                // Hiển thị thông báo kết quả
                let icon = 'success';
                let title = `Đã tải \${successCount}/\${totalFiles} ảnh thành công!`;
                let html = '';
                
                if (errorCount > 0) {
                    icon = successCount > 0 ? 'warning' : 'error';
                    title = `Đã tải \${successCount}/\${totalFiles} ảnh thành công!`;
                    html = `<p>\${errorCount} ảnh không thể tải lên (có thể do ảnh quá nặng).</p>`;
                }
                
                Swal.fire({
                    icon: icon,
                    title: title,
                    html: html,
                    timer: 3000,
                    showConfirmButton: false
                });
            } catch (err) {
                console.error('Lỗi chính:', err);
                
                // Xử lý lỗi tổng quan
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi khi tải ảnh!',
                    text: err.message || 'Không thể kết nối đến server',
                    showCancelButton: true,
                    confirmButtonText: 'Dùng URL tạm thởi',
                    cancelButtonText: 'Hủy'
                }).then(result => {
                    if (result.isConfirmed) {
                        // Tạo URL tạm thởi cho tất cả ảnh
                        for (let i = 0; i < totalFiles; i++) {
                            const fallbackUrl = URL.createObjectURL(files[i]);
                            addImageToList(fallbackUrl);
                        }
                        
                        Swal.fire({
                            icon: 'info',
                            title: `Đã dùng ảnh tạm thởi cho \${totalFiles} ảnh`,
                            timer: 2000,
                            showConfirmButton: false
                        });
                    }
                });
            }
        }

        $(document).on('click', '.remove-image-btn', function() {
            $(this).closest('.image-item').remove();
            updateImageOrder();
        });

        $(document).on('click', '.form-check-label, .main-image-radio', function(e) {
            const radio = $(this).is('.main-image-radio') ? $(this) : $(this).prev('.main-image-radio');
            radio.prop('checked', true);
            $('.main-image-radio').not(radio).prop('checked', false);
        });

        // Save images button click handler
        $('#saveImagesBtn').on('click', async function() {
            try {
                const images = [];
                let mainImageId = $('input[name="mainImageId"]:checked').val();
                $('#sortableImageGrid .image-item').each(function(index) {
                    const imageId = $(this).data('id');
                    const imageUrl = $(this).find('img.image-preview').attr('src');
                    images.push({
                        id: imageId,
                        image: imageUrl,
                        main: imageId == mainImageId,
                        sortOrder: index,
                    });
                });
                console.log('Images to save:', images);
                // Show loading state
                Swal.fire({
                    title: 'Đang lưu...',
                    html: 'Vui lòng đợi trong giây lát',
                    allowOutsideClick: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                });

                // Send AJAX request to save images
                const response = await fetch('${pageContext.request.contextPath}/dashboard/products?action=update&id=${product.id}&updateType=images', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        images: images
                    })
                });

                if (!response.ok) {
                    throw new Error('Failed to save images');
                }

                const result = await response.json();
                
                if (result.success) {
                    Swal.fire({
                        icon: 'success',
                        title: 'Lưu thành công!',
                        text: 'Các thay đổi đã được lưu',
                        showConfirmButton: false,
                        timer: 1500
                    });
                    
                    // Refresh the page after success
                    // setTimeout(() => {
                    //     window.location.reload();
                    // }, 1500);
                } else {
                    throw new Error(result.message || 'Failed to save images');
                }
                
            } catch (error) {
                console.error('Error saving images:', error);
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi!',
                    text: 'Không thể lưu thay đổi. Vui lòng thử lại.',
                });
            }
        });
    });

</script>