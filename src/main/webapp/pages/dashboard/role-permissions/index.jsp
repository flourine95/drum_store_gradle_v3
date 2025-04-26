<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<style>
    .table thead th {
        position: sticky;
        top: 0;
        background-color: #343a40;
        color: white;
        z-index: 1;
        vertical-align: middle;
    }

    tbody tr:hover {
        background-color: #f8f9fa;
    }

    td, th {
        vertical-align: middle;
        text-align: center;
    }

    .text-start {
        text-align: left !important;
    }

    .clickable-col {
        cursor: pointer;
        user-select: none;
    }

    .clickable-col:hover {
        background-color: #495057 !important;
    }

    input[type="checkbox"] {
        transform: scale(1.2);
        cursor: pointer;
    }
</style>

<div class="container mt-5">
    <h2 class="mb-4">Quản lý Vai trò & Quyền</h2>
    <form id="rolePermissionForm" method="post" action="${pageContext.request.contextPath}/dashboard/role-permissions">
        <div class="table-responsive">
            <table class="table table-bordered align-middle text-center">
                <thead class="table-dark">
                <tr>
                    <th class="text-start">Quyền</th>
                    <c:forEach var="role" items="${roles}">
                        <th class="clickable-col" data-role-id="${role.id}">${role.name}</th>
                    </c:forEach>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="row" items="${matrixList}">
                    <tr>
                        <td class="text-start">${row.permissionName}(${row.permissionDescription})</td>
                        <c:forEach var="role" items="${roles}">
                            <td>
                                <input type="checkbox"
                                       name="permissions[${row.permissionId}][]"
                                       value="${role.id}"
                                       class="role-${role.id}"
                                       <c:if test="${row.roleCheckboxMap[role.id]}">checked</c:if> />
                            </td>
                        </c:forEach>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
        <button type="submit" class="btn btn-primary mt-3">Lưu thay đổi</button>
    </form>
</div>

<script>
    $(document).ready(function () {
        $("tbody tr").on("click", function (e) {
            if (!$(e.target).is("input[type='checkbox']")) {
                const $checkboxes = $(this).find("input[type='checkbox']");
                const allChecked = $checkboxes.filter(":checked").length === $checkboxes.length;
                $checkboxes.prop("checked", !allChecked);
            }
        });

        $("thead th.clickable-col").each(function (index) {
            $(this).on("click", function () {
                const colIndex = index + 2;
                const $checkboxes = $(`tbody td:nth-child(\${colIndex}) input[type='checkbox']`);
                const allChecked = $checkboxes.toArray().every(cb => cb.checked);
                $checkboxes.prop("checked", !allChecked);
            });
        });
    });
</script>
