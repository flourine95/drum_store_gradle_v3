<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<table id="categories" class="table table-striped table-hover table-bordered" style="width:100%">
    <thead>
    <tr>
        <th>#</th>
        <th>Tên</th>
        <th>Ảnh</th>
        <th>Mô tả</th>
        <th>Ngày tạo</th>
        <th>Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="category" items="${categories}">
        <tr>
            <td>${category.id}</td>
            <td>${category.name}</td>
            <td><img class="category-image" src="/assets/images/data/${category.image}" alt="${category.image}"></td>
            <td>${category.description}</td>
            <td>${category.createdAt}</td>
            <td>
                <form action="${pageContext.request.contextPath}/dashboard/categories/${category.id}" method="GET"
                      style="display:inline;">
                    <button type="submit" class="btn btn-info btn-sm">Xem</button>
                </form>
                <form action="${pageContext.request.contextPath}/dashboard/categories/${category.id}/edit" method="GET"
                      style="display:inline;">
                    <button type="submit" class="btn btn-primary btn-sm">Sửa</button>
                </form>

                <form action="${pageContext.request.contextPath}/dashboard/categories/${category.id}" method="POST" style="display:inline;"
                      onsubmit="return confirm('Bạn có chắc muốn xóa danh mục này không?');">
                    <input type="hidden" name="csrf_token" value="${csrfToken}">
                    <input type="hidden" name="_method" value="DELETE">
                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
    <tfoot>
    <tr>
        <th>#</th>
        <th>Tên</th>
        <th>Ảnh</th>
        <th>Mô tả</th>
        <th>Ngày tạo</th>
        <th>Thao tác</th>
    </tr>
    </tfoot>
</table>

<style>
    .category-image {
        width: 150px;
        height: 150px;
        object-fit: contain;
    }
</style>

<script
        src="https://cdn.datatables.net/v/bs5/jq-3.7.0/jszip-3.10.1/dt-2.1.8/b-3.2.0/b-colvis-3.2.0/b-html5-3.2.0/b-print-3.2.0/fh-4.0.1/cr-2.0.4/fc-5.0.4/kt-2.12.1/r-3.0.3/sb-1.8.1/sp-2.3.3/sl-2.1.0/sr-1.4.1/datatables.min.js"></script>
<script>
    $(document).ready(function () {
        $('#categories').DataTable({
            pageLength: 25,
            layout: {
                topStart: {
                    buttons: [
                        {
                            text: '<i class="bi bi-person-add me-2"></i>Thêm danh mục',
                            className: 'btn btn-secondary me-2',
                            action: function () {
                                window.location.href = '/dashboard/categories/create'; // Thay đổi URL đến trang tạo mới
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
                                        columns: ':visible'
                                    }
                                },
                                {
                                    extend: 'pdf',
                                    text: '<i class="bi bi-file-earmark-pdf me-2"></i>PDF',
                                    className: 'dropdown-item',
                                    exportOptions: {
                                        columns: ':visible'
                                    }
                                },
                                {
                                    extend: 'csv',
                                    text: '<i class="bi bi-file-earmark-text me-2"></i>CSV',
                                    className: 'dropdown-item',
                                    exportOptions: {
                                        columns: ':visible'
                                    }
                                },
                                {
                                    extend: 'print',
                                    text: '<i class="bi bi-printer me-2"></i>In',
                                    className: 'dropdown-item',
                                    exportOptions: {
                                        columns: ':visible'
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
                }

            },
        });
    });
</script>
