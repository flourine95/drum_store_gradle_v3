<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<div class="col-md-6">
    <div class="mb-3">
        <label for="orderId" class="form-label"><strong>ID đơn hàng:</strong></label>
        <input type="text" id="orderId" name="orderId" class="form-control" value="${order.id}" readonly>
    </div>
    <div class="mb-3">
        <label for="orderDate" class="form-label"><strong>Ngày đặt hàng:</strong></label>
        <input type="text" id="orderDate" name="orderDate" class="form-control" value="${order.orderDate}" readonly>
    </div>
    <div class="mb-3">
        <label for="status" class="form-label"><strong>Trạng thái:</strong></label>
        <select id="status" name="status" class="form-select">
            <option value="0" ${order.status == 0 ? 'selected' : ''}>Chờ xử lý</option>
            <option value="1" ${order.status == 1 ? 'selected' : ''}>Hoàn thành</option>
            <option value="2" ${order.status == 2 ? 'selected' : ''}>Đã hủy</option>
        </select>
    </div>

</div>
<table class="table table-bordered">
    <thead>
    <tr>
        <th>#</th>
        <th>Mã sản phẩm</th>
        <th>Số lượng</th>
        <th>Giá</th>
        <th>Thành tin</th>
        <th>Thao tác</th>

    </tr>
    </thead>
    <h4>Sản phẩm</h4>
    <tbody>
    <c:forEach var="item" items="${order.items}">
        <tr>
            <td>${item.id}</td>
            <td>${item.productId}</td>
            <td>${item.quantity}</td>
            <td>${item.price}</td>
            <td>${item.quantity * item.price}</td>
            <td>
                <form action="${pageContext.request.contextPath}/dashboard/orders/${order.id}/edit" method="GET"
                      style="display:inline;">
                    <button type="submit" class="btn btn-primary btn-sm">Sửa</button>
                </form>
                <form action="${pageContext.request.contextPath}/dashboard/orders/${order.id}" method="POST" style="display:inline;" onsubmit="return confirm('Bạn có chắc muốn xóa sản phẩm này không?');">
                    <input type="hidden" name="orderId" value="${order.id}">
                    <input type="hidden" name="productId" value="${item.productId}">
                    <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                </form>

            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
<div class="mt-3">
    <button type="submit" class="btn btn-success">Lưu thay đổi</button>
    <a href="${pageContext.request.contextPath}/dashboard/orders" class="btn btn-secondary">Hủy</a>
</div>
