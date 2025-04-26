<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container-fluid">
    <div class="row">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h4 class="card-title">Tạo sản phẩm mới</h4>
                </div>
                <div class="card-body">
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger" role="alert">
                                ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/dashboard/products" method="post" id="productForm">
                        <input type="hidden" name="action" value="store">

                        <!-- Thông tin cơ bản -->
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">Thông tin cơ bản</h5>
                            </div>
                            <div class="card-body">
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="productName">Tên sản phẩm <span
                                                    class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="productName" name="name"
                                                   required>
                                            <div class="invalid-feedback">Vui lòng nhập tên sản phẩm</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="basePrice">Giá cơ bản <span class="text-danger">*</span></label>
                                            <div class="input-group">
                                                <input type="number" class="form-control" id="basePrice"
                                                       name="basePrice" step="1000" min="0" required>
                                                <div class="input-group-append">
                                                    <span class="input-group-text">VNĐ</span>
                                                </div>
                                                <div class="invalid-feedback">Vui lòng nhập giá hợp lệ</div>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="categoryId">Danh mục <span class="text-danger">*</span></label>
                                            <select class="form-control" id="categoryId" name="categoryId" required>
                                                <option value="">Chọn danh mục</option>
                                                <c:forEach items="${categories}" var="category">
                                                    <option value="${category.id}">${category.name}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="invalid-feedback">Vui lòng chọn danh mục</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label for="brandId">Thương hiệu <span class="text-danger">*</span></label>
                                            <select class="form-control" id="brandId" name="brandId" required>
                                                <option value="">Chọn thương hiệu</option>
                                                <c:forEach items="${brands}" var="brand">
                                                    <option value="${brand.id}">${brand.name}</option>
                                                </c:forEach>
                                            </select>
                                            <div class="invalid-feedback">Vui lòng chọn thương hiệu</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group mb-3">
                                    <label for="editor">Mô tả</label>
                                    <textarea id="editor" name="description"></textarea>
                                </div>

                                <div class="form-check mb-3">
                                    <input type="checkbox" class="form-check-input" id="isFeatured" name="isFeatured">
                                    <label class="form-check-label" for="isFeatured">Sản phẩm nổi bật</label>
                                </div>
                            </div>
                        </div>

                        <!-- Quản lý tồn kho -->
                        <div class="card mb-3">
                            <div class="card-header bg-light">
                                <h5 class="mb-0">Quản lý tồn kho</h5>
                            </div>
                            <div class="card-body">
                                <div class="form-group mb-3">
                                    <label for="stockManagementType">Kiểu quản lý tồn kho <span
                                            class="text-danger">*</span></label>
                                    <select class="form-control" id="stockManagementType" name="stockManagementType"
                                            required>
                                        <c:forEach items="${stockManagementTypes}" var="type">
                                            <option value="${type.value}">
                                                <c:choose>
                                                    <c:when test="${type.value == 0}">Đơn giản (không có biến thể)</c:when>
                                                    <c:when test="${type.value == 1}">Chỉ màu sắc</c:when>
                                                    <c:when test="${type.value == 2}">Chỉ phụ kiện</c:when>
                                                    <c:when test="${type.value == 3}">Màu sắc và phụ kiện</c:when>
                                                </c:choose>
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="form-text text-muted">Bạn sẽ có thể thêm biến thể sau khi tạo sản phẩm</small>
                                </div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/dashboard/products" class="btn btn-secondary">Hủy</a>
                            <button type="submit" class="btn btn-primary">Tạo sản phẩm</button>
                        </div>
                    </form>
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
    const {
        ClassicEditor,
        Autoformat,
        BlockQuote,
        Bold,
        CloudServices,
        Essentials,
        Heading,
        Image,
        ImageCaption,
        ImageResize,
        ImageStyle,
        ImageToolbar,
        ImageUpload,
        Base64UploadAdapter,
        Indent,
        IndentBlock,
        Italic,
        Link,
        List,
        MediaEmbed,
        Mention,
        Paragraph,
        PasteFromOffice,
        PictureEditing,
        Table,
        TableColumnResize,
        TableToolbar,
        TextTransformation,
        Underline,
        CKBox,
        CKBoxImageEdit,
        ImageInsertUI,
        FontColor,
        FontBackgroundColor,
        FontSize,
        FontFamily
    } = CKEDITOR;

    async function initEditor() {
        try {
            const [licenseKey, ckboxToken] = await Promise.all([
                fetch('/api/keys?service=ckeditor').then(res => res.text()),
                fetch('/api/keys?service=ckbox-dev').then(res => res.text())
            ]);

            await ClassicEditor.create(document.querySelector('#editor'), {
                licenseKey: licenseKey.trim(),

                plugins: [
                    Autoformat, BlockQuote, Bold, CloudServices, Essentials, Heading,
                    Image, ImageCaption, ImageResize, ImageStyle, ImageToolbar, ImageUpload,
                    Base64UploadAdapter, Indent, IndentBlock, Italic, Link, List, MediaEmbed,
                    Mention, Paragraph, PasteFromOffice, PictureEditing, Table, TableColumnResize,
                    TableToolbar, TextTransformation, Underline, CKBox, CKBoxImageEdit,
                    ImageInsertUI, FontColor, FontBackgroundColor, FontSize, FontFamily
                ],

                toolbar: [
                    'undo', 'redo', '|',
                    'heading', '|',
                    'bold', 'italic', 'underline', '|',
                    'fontColor', 'fontBackgroundColor', 'fontSize', 'fontFamily', '|',
                    'link', 'uploadImage', 'ckbox', '|',
                    'insertTable', 'blockQuote', 'mediaEmbed', '|',
                    'bulletedList', 'numberedList', '|',
                    'outdent', 'indent'
                ],

                ckbox: {
                    tokenUrl: ckboxToken.trim(),
                    theme: 'lark'
                },

                image: {
                    resizeOptions: [
                        {
                            name: 'resizeImage:original',
                            label: 'Default image width',
                            value: null
                        },
                        {
                            name: 'resizeImage:50',
                            label: '50% page width',
                            value: '50'
                        },
                        {
                            name: 'resizeImage:75',
                            label: '75% page width',
                            value: '75'
                        }
                    ],
                    toolbar: [
                        'imageTextAlternative',
                        'toggleImageCaption',
                        '|',
                        'imageStyle:inline',
                        'imageStyle:wrapText',
                        'imageStyle:breakText',
                        '|',
                        'resizeImage'
                    ]
                },

                link: {
                    addTargetToExternalLinks: true,
                    defaultProtocol: 'https://'
                },

                table: {
                    contentToolbar: ['tableColumn', 'tableRow', 'mergeTableCells']
                },

                heading: {
                    options: [
                        {model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph'},
                        {model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1'},
                        {model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2'},
                        {model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3'},
                        {model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4'}
                    ]
                }
            });

        } catch (error) {
            console.error('Error initializing editor:', error);
        }
    }

    initEditor();
</script>



