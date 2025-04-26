<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="card">
    <div class="card-body">
        <table id="orders" class="table table-striped table-hover table-bordered" style="width:100%">
            <thead>
            <tr>
                <%--                <th>#</th>--%>
                <th>Mã đơn hàng</th>
                <th>Ngày đặt hàng</th>
                <th>Tổng tiền</th>
                <th>Phương thức thanh toán</th>
                <th>Trạng thái thanh toán</th>
                <th>Trạng thái đơn hàng</th>
                <th>Địa chỉ giao hàng</th>
                <th>Số lượng sản phẩm</th>
                <th>Thao tác</th>
            </tr>
            </thead>
        </table>
    </div>
</div>

<script>
    $(document).ready(function () {
        $('#orders').DataTable({
            processing: true,
            ajax: {
                url: '${pageContext.request.contextPath}/api/orders',
                dataSrc: function (json) {
                    if (json.success !== undefined && !json.success) {
                        toastr.error(json.message || 'Có lỗi xảy ra khi lấy dữ liệu đơn hàng');
                        return [];
                    }
                    return json;
                },
                error: function (xhr, error, thrown) {
                    toastr.error('Không thể lấy dữ liệu đơn hàng. Vui lòng thử lại sau.');
                    console.error('AJAX Error:', xhr, error, thrown);
                }
            },
            columns: [
                // { data: 'orderId' },
                {data: 'orderId'},
                {
                    data: 'orderDate',
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
                    data: 'totalAmount',
                    render: function (data) {
                        return new Intl.NumberFormat('vi-VN', {
                            style: 'currency',
                            currency: 'VND'
                        }).format(data);
                    }
                },
                {
                    data: 'paymentMethodText',
                    render: function (data) {
                        let badgeClass = '';
                        switch (data) {
                            case 'COD':
                                badgeClass = 'warning';
                                break;
                            case 'BANK_TRANSFER':
                                badgeClass = 'primary';
                                break;

                            default:
                                badgeClass = 'secondary';
                        }
                        return `<span class="badge bg-\${badgeClass}">\${data}</span>`;
                    }
                },
                {
                    data: 'paymentStatusText',
                    render: function (data) {
                        let badgeClass = '';
                        switch (data) {
                            case 'PENDING':
                                badgeClass = 'warning';
                                break;
                            case 'COMPLETED':
                                badgeClass = 'success';
                                break;
                            case 'FAILED':
                                badgeClass = 'danger';
                                break;
                            default:
                                badgeClass = 'secondary';
                        }
                        return `<span class="badge bg-\${badgeClass}">\${data}</span>`;
                    }
                },
                {
                    data: 'orderStatus',
                    render: function (data, type, row) {
                        return `
                       <select class="form-select order-status" data-order-id="\${row.orderId}" style="width: 150px;">
                            <option value="0" \${data == 0 ? 'selected' : ''}>PENDING</option>
                            <option value="1" \${data == 1 ? 'selected' : ''}>CONFIRMED</option>
                            <option value="2" \${data == 2 ? 'selected' : ''}>SHIPPING</option>
                            <option value="3" \${data == 3 ? 'selected' : ''}>DELIVERED</option>
                            <option value="4" \${data == 4 ? 'selected' : ''}>CANCELLED</option>
                        </select>
                    `;
                    }
                },
                {
                    data: 'shippingAddress',
                    render: function (data) {
                        return `
                        <div>\${data.fullname}</div>
                        <div>SDT: \${data.phone}</div>
                    `;
                    }
                },
                {
                    data: 'items',
                    render: function (data) {
                        return `<span class="badge bg-info">\${data.length}</span>`;
                    }
                },
                {
                    data: 'orderId',
                    orderable: false,
                    className: 'text-center',
                    render: function (data) {
                        return `
                        <div class="btn-group" role="group">
                            <a href="${pageContext.request.contextPath}/dashboard/orders?action=show&orderId=\${data}"
                               class="btn btn-info btn-sm" title="Xem chi tiết">
                                <i class="bi bi-eye"></i>
                            </a>
                            <%--<a href="${pageContext.request.contextPath}/dashboard/orders/\${data}/edit"--%>
                            <%--   class="btn btn-primary btn-sm" title="Chỉnh sửa">--%>
                            <%--    <i class="bi bi-pencil"></i>--%>
                            <%--</a>--%>
                            <button type="button"
                                    class="btn btn-danger btn-sm"
                                    onclick="deleteOrder(\${data})"
                                    title="Xóa">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    `;
                    }
                }
            ],
            order: [[0, 'desc']],
            pageLength: 25,
            language: {
                url: '//cdn.datatables.net/plug-ins/1.13.7/i18n/vi.json'
            },
            dom: '<"row mb-3"<"col-sm-12 col-md-6"B><"col-sm-12 col-md-6"f>>' +
                '<"row"<"col-sm-12"tr>>' +
                '<"row mt-3"<"col-sm-12 col-md-5"i><"col-sm-12 col-md-7"p>>',
            buttons: [
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

        // Handle order status change
        $('#orders').on('change', '.order-status', function () {
            let orderId = $(this).data('order-id');
            let newStatus = $(this).val();

            if (orderStatus === 4) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Không thể thay đổi',
                    text: 'Đơn hàng này đã được hủy, không được thay đổi trạng thái đơn hàng.',
                });
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/dashboard/orders',
                type: 'POST',
                data: {
                    action: "modify-orderStatus",
                    orderId: orderId,
                    statusId: newStatus
                },
                success: function (response) {
                    if (response.status === 'success') {
                        Swal.fire({
                            icon: 'success',
                            title: 'Thành công',
                            text: 'Cập nhật trạng thái đơn hàng thành công!',
                            timer: 1500,
                            showConfirmButton: false
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi',
                            text: response.message || 'Có lỗi xảy ra khi cập nhật trạng thái!'
                        });
                        $('#orders').DataTable().ajax.reload();
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error:', error);
                    Swal.fire({
                        icon: 'error',
                        title: 'Lỗi kết nối',
                        text: 'Không thể cập nhật trạng thái đơn hàng!'
                    });
                    $('#orders').DataTable().ajax.reload(); //
                }
            });
        });
    });

    function deleteOrder(orderId) {
        const row = $('tr[data-order-id="' + orderId + '"]');
        const orderStatus = parseInt(row.find('.order-status option:selected').val());

        if ([1, 2, 3].includes(orderStatus)) {
            Swal.fire({
                icon: 'warning',
                title: 'Không thể xóa',
                text: 'Đơn hàng đã được xử lý và không thể bị xóa.',
            });
            return;
        }

        Swal.fire({
            title: 'Bạn có chắc?',
            text: "Bạn có chắc muốn xóa đơn hàng này không?",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Xóa',
            cancelButtonText: 'Hủy'
        }).then((result) => {
            if (result.isConfirmed) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/dashboard/orders',
                    method: 'POST',
                    data: {
                        action:'remove-order',
                        orderId: orderId
                    },
                    success: function (data) {
                        if (data.status === 'success') {
                            $('#orders').DataTable().ajax.reload();
                            Swal.fire({
                                icon: 'success',
                                title: 'Đã xóa',
                                text: 'Xóa đơn hàng thành công.'
                            });
                        } else {
                            Swal.fire({
                                icon: 'error',
                                title: 'Lỗi',
                                text: data.message || 'Có lỗi xảy ra khi xóa đơn hàng.'
                            });
                        }
                    },
                    error: function () {
                        Swal.fire({
                            icon: 'error',
                            title: 'Lỗi',
                            text: 'Có lỗi xảy ra khi xóa đơn hàng.'
                        });
                    }
                });
            }
        });
    }

</script>