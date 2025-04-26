<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<section id="saleForm">
    <input type="hidden" name="id" value="${sale.id}">
    <section class="row mb-3">
        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Tên:</label>
                    <input type="text" value="${sale.name}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Mô tả:</label>
                    <input type="text" value="${sale.discription}" class="form-control" readonly>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Phần trăm giảm giá:</label>
                    <textarea class="form-control" readonly>${sale.discountPercentagen}</textarea>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Ngày bắt đầu:</label>
                    <textarea class="form-control" readonly>${sale.startDate}</textarea>
                </div>

                <div class="col-md-6 mb-2">
                    <label class="form-label fw-bold">Ngày kết thúc:</label>
                    <textarea class="form-control" readonly>${sale.endDate}</textarea>
                </div>

            </div>
        </div>
    </section>

    <div class="form-actions">
        <a href="${pageContext.request.contextPath}/dashboard/sales" class="btn btn-secondary">Quay lại</a>
    </div>
</section>

<style>
    .form-actions {
        margin-top: 20px;
    }
</style>
