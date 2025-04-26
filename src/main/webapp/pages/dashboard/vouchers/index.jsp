<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>


<div class="card">
    <div class="card-body">
        <table id="vouchers" class="table table-striped table-hover table-bordered" style="width:100%">
            <thead>
            <tr>
                <th>Mã Voucher</th>
                <th>Mô tả</th>
                <th>Giá trị giảm giá</th>
                <th>Loại giảm giá</th>
                <th>Trạng thái</th>
                <th>Ngày bắt đầu</th>
                <th>Ngày kết thúc</th>
                <th>Thao tác</th>
            </tr>
            </thead>
        </table>
    </div>
</div>



<script>
    $(document).ready(function () {
        $('#vouchers').DataTable({
            processing: true,
            ajax: {
                url: '${pageContext.request.contextPath}/api/vouchers',
                dataSrc: function (json) {
                    if (json.success !== undefined && !json.success) {
                        toastr.error(json.message || 'Có lỗi xảy ra khi lấy dữ liệu voucher');
                        return [];
                    }
                    return json;
                },
                error: function (xhr, error, thrown) {
                    toastr.error('Không thể lấy dữ liệu voucher. Vui lòng thử lại sau.');
                    console.error('AJAX Error:', xhr, error, thrown);
                }
            },
            columns: [
                { data: 'code' },
                { data: 'description' },
                {
                    data: 'discountValue',
                    render: function (data, type, row) {
                        if (row.discountType === 'PERCENTAGE') {
                            return data + '%';
                        }
                        return new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(data);
                    }
                },
                {
                    data: 'discountType',
                    render: function (data) {
                        let badgeClass = '';
                        let typeText = '';
                        switch (parseInt(data)) {
                            case 2: // PERCENTAGE
                                badgeClass = 'primary';
                                typeText = 'PERCENTAGE';
                                break;
                            case 1: // FIXED
                                badgeClass = 'info';
                                typeText = 'FIXED';
                                break;
                            default:
                                badgeClass = 'secondary';
                                typeText = 'UNKNOWN';
                        }
                        return `<span class="badge bg-\${badgeClass}">\${typeText}</span>`;
                    }
                },
                {
                    data: 'status',
                    render: function (data) {
                        let badgeClass = '';
                        let statusText = '';
                        switch (parseInt(data)) {
                            case 1: // ACTIVE
                                badgeClass = 'success';
                                statusText = 'ACTIVE';
                                break;
                            case 0: // INACTIVE
                                badgeClass = 'warning';
                                statusText = 'INACTIVE';
                                break;
                            case 2: // EXPIRED
                                badgeClass = 'danger';
                                statusText = 'EXPIRED';
                                break;
                            default:
                                badgeClass = 'secondary';
                                statusText = 'UNKNOWN';
                        }
                        return `<span class="badge bg-\${badgeClass}">\${statusText}</span>`;
                    }
                },
                {
                    data: 'startDate',
                    render: function (data) {
                        return new Date(data).toLocaleString('vi-VN', {
                            day: '2-digit',
                            month: '2-digit',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                        });
                    }
                },
                {
                    data: 'endDate',
                    render: function (data) {
                        return new Date(data).toLocaleString('vi-VN', {
                            day: '2-digit',
                            month: '2-digit',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit'
                        });
                    }
                },
                {
                    data: 'id',
                    orderable: false,
                    className: 'text-center',
                    render: function (data,type, row) {
                        return `
                        <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/dashboard/vouchers?action=show&voucherId=\${data}"
                               class="btn btn-info btn-sm" title="Xem chi tiết">
                                <i class="bi bi-eye"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/dashboard/vouchers?action=edit&voucherId=\${data}"
                               class="btn btn-primary btn-sm" title="Chỉnh sửa">
                                <i class="bi bi-pencil"></i>
                            </a>

                            <button type="button"
                                    class="btn btn-danger btn-sm"
                                    onclick="deleteVoucher(\${data},\${row.status})"
                                    title="Xóa">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                        `;
                    }
                }
            ],
            order: [[5, 'desc']], // Sắp xếp theo ngày bắt đầu
            pageLength: 25,
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/vi.json'
            },
            dom: '<"row mb-3"<"col-sm-12 col-md-6"B><"col-sm-12 col-md-6"f>>' +
                '<"row"<"col-sm-12"tr>>' +
                '<"row mt-3"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
            buttons: [
                {
                    text: '<i class="bi bi-plus-circle me-2"></i>Thêm Voucher',
                    className: 'btn btn-success me-2',
                    action: function() {
                        window.location.href = '${pageContext.request.contextPath}/dashboard/vouchers?action=create';
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

    function deleteVoucher(voucherId, status) {
        if (status === 1) {
            Swal.fire({
                icon: 'warning',
                title: 'Không thể xóa',
                text: 'Voucher này không thể xóa vì nó đã được kích hoạt hoặc đã hết hạn.'
            });
        }
        Swal.fire({
            title: 'Bạn có chắc?',
            text: "Bạn có chắc muốn xóa voucher này không?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/dashboard/vouchers',
                    method: 'POST',
                    data: {
                        action:"delete",
                        voucherId: voucherId
                    },
                    success: function (data) {
                        if (data.status === 'success') {
                            $('#vouchers').DataTable().ajax.reload();
                            Swal.fire({
                                icon: 'success',
                                title: 'Đã xóa',
                                text: 'Xóa voucher thành công.'
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Lỗi',
                                text: data.message || 'Có lỗi xảy ra khi xóa voucher.'
                            });
                        }
                    },
                    error: function () {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi',
                            text: 'Có lỗi xảy ra khi xóa voucher.'
                        });
                    }
                });
            }
        });
    }
</script>