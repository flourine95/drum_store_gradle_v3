<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card">
    <div class="card-body">
        <table id="products" class="table table-striped table-hover table-bordered" style="width:100%">
            <thead>
            <tr>
                <th>#</th>
                <th>Sản phẩm</th>
                <th>Giá cơ bản</th>
                <th>Danh mục</th>
                <th>Thương hiệu</th>
                <th>Biến thể</th>
                <th>Tồn kho</th>
                <th>Lượt xem</th>
                <th>Đánh giá</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<script>
$(document).ready(function() {
    $('#products').DataTable({
        processing: true,
        ajax: {
            url: '${pageContext.request.contextPath}/api/products',
            dataSrc: ''
        },
        columns: [
            { data: 'id' },
            { 
                data: null,
                render: function(data) {
                    let image = data.mainImage ? 
                        `<img src="${pageContext.request.contextPath}/assets/images/products/\${data.mainImage}"
                              class="rounded me-2" style="width: 40px; height: 40px; object-fit: cover;">` : '';
                    let featuredBadge = data.featured ? 
                        '<span class="badge bg-warning ms-1">Nổi bật</span>' : '';
                    
                    return `
                        <div class="d-flex align-items-center">
                            \${image}
                            <div>
                                <div class="fw-bold">\${data.name}</div>
                                \${featuredBadge}
                            </div>
                        </div>
                    `;
                }
            },
            { 
                data: 'basePrice',
                render: function(data) {
                    return new Intl.NumberFormat('vi-VN', { 
                        style: 'currency', 
                        currency: 'VND' 
                    }).format(data);
                }
            },
            { data: 'categoryName' },
            { data: 'brandName' },
            {
                data: null,
                render: function(data) {
                    return `
                        <div>Màu: <span class="badge bg-primary">\${data.totalColors}</span></div>
                        <div>Addon: <span class="badge bg-info">\${data.totalAddons}</span></div>
                        <div>Biến thể: <span class="badge bg-secondary">\${data.totalVariants}</span></div>
                    `;
                }
            },
            { 
                data: 'stock',
                render: function(data) {
                    let badgeClass = data > 0 ? 'success' : 'danger';
                    let status = data > 0 ? 'Còn hàng' : 'Hết hàng';
                    return `
                        <div class="text-center">
                            <div class="badge bg-\${badgeClass}">\${status}</div>
                            <div class="mt-1">\${data}</div>
                        </div>
                    `;
                }
            },
            { 
                data: 'totalViews',
                render: function(data) {
                    return `<span class="badge bg-info">\${data}</span>`;
                }
            },
            { 
                data: null,
                render: function(data) {
                    const stars = '⭐'.repeat(Math.round(data.avgRating));
                    return `
                        <div class="text-center">
                            <div>\${stars || '☆☆☆☆☆'}</div>
                            <small class="text-muted">\${data.totalReviews} đánh giá</small>
                        </div>
                    `;
                }
            },
            { 
                data: 'status',
                render: function(data) {
                    let badge = '';
                    switch(data) {
                        case 1:
                            badge = '<span class="badge bg-success">Hoạt động</span>';
                            break;
                        case 0:
                            badge = '<span class="badge bg-danger">Không hoạt động</span>';
                            break;
                        default:
                            badge = '<span class="badge bg-secondary">Không xác định</span>';
                    }
                    return `<div class="text-center">\${badge}</div>`;
                }
            },
            {
                data: 'id',
                orderable: false,
                className: 'text-center',
                render: function(data) {
                    return `
                        <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/dashboard/products/\${data}"
                               class="btn btn-info btn-sm" title="Xem chi tiết">
                                <i class="bi bi-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/products/\${data}/edit"
                               class="btn btn-primary btn-sm" title="Chỉnh sửa">
                                <i class="bi bi-pencil"></i>
                            </a>
                            <button type="button" 
                                    class="btn btn-danger btn-sm" 
                                    onclick="deleteProduct(\${data})"
                                    title="Xóa">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    `;
                }
            }
        ],
        order: [[0, 'desc']], // Sắp xếp mặc định theo ID giảm dần
        pageLength: 25,
        language: {
            url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/vi.json'
        },
        dom: '<"row mb-3"<"col-sm-12 col-md-6"B><"col-sm-12 col-md-6"f>>' +
             '<"row"<"col-sm-12"tr>>' +
             '<"row mt-3"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
        buttons: [
            {
                text: '<i class="bi bi-plus-circle me-2"></i>Thêm sản phẩm',
                className: 'btn btn-success me-2',
                action: function() {
                    window.location.href = '${pageContext.request.contextPath}/dashboard/products?action=create';
                }
            },
            {
                extend: 'collection',
                text: '<i class="bi bi-download me-2"></i>Xuất dữ liệu',
                className: 'btn btn-primary dropdown-toggle me-2',
                buttons: [
                    {
                        extend: 'excel',
                        text: '<i class="bi bi-file-earmark-excel me-2"></i>Excel',
                        className: 'dropdown-item',
                        exportOptions: {
                            columns: ':not(:last-child)'
                        }
                    },
                    {
                        extend: 'pdf',
                        text: '<i class="bi bi-file-earmark-pdf me-2"></i>PDF',
                        className: 'dropdown-item',
                        exportOptions: {
                            columns: ':not(:last-child)'
                        }
                    },
                    {
                        extend: 'csv',
                        text: '<i class="bi bi-file-earmark-text me-2"></i>CSV',
                        className: 'dropdown-item',
                        exportOptions: {
                            columns: ':not(:last-child)'
                        }
                    },
                    {
                        extend: 'print',
                        text: '<i class="bi bi-printer me-2"></i>In',
                        className: 'dropdown-item',
                        exportOptions: {
                            columns: ':not(:last-child)'
                        }
                    }
                ]
            },
            {
                extend: 'colvis',
                text: '<i class="bi bi-eye me-2"></i>Hiển thị cột',
                className: 'btn btn-secondary'
            }
        ]
    });
});

function deleteProduct(productId) {
    if (confirm('Bạn có chắc muốn xóa sản phẩm này không?')) {
        fetch('${pageContext.request.contextPath}/api/products/' + productId, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                $('#products').DataTable().ajax.reload();
                toastr.success('Xóa sản phẩm thành công');
            } else {
                toastr.error(data.message || 'Có lỗi xảy ra khi xóa sản phẩm');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            toastr.error('Có lỗi xảy ra khi xóa sản phẩm');
        });
    }
}
</script>
