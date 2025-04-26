<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<style>
    .voucher-container {
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: center;
    }
    .voucher-details-container {
        background-color: #fff;
        border-radius: 12px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        max-width: 700px;
        width: 100%;
        padding: 30px;
        margin: 20px;
        border: 1px solid #e9ecef;
    }

    .voucher-details-container h4 {
        color: #2c3e50;
        font-size: 1.8rem;
        font-weight: 700;
        margin-bottom: 25px;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 1px;
        border-bottom: 2px solid #1a73e8;
        padding-bottom: 10px;
    }

    .voucher-info {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 25px;
    }

    .voucher-info h5 {
        color: #2c3e50;
        font-size: 1.3rem;
        font-weight: 600;
        margin-bottom: 20px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .voucher-info p {
        margin: 12px 0;
        font-size: 1rem;
        color: #34495e;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 8px 0;
        border-bottom: 1px dashed #dee2e6;
        transition: background 0.3s ease;
    }

    .voucher-info p:last-child {
        border-bottom: none;
    }

    .voucher-info p:hover {
        background: #e9ecef;
        border-radius: 5px;
    }

    .voucher-info p strong {
        font-weight: 600;
        color: #2c3e50;
        width: 40%;
    }

    .voucher-info p span {
        width: 60%;
        text-align: right;
        font-weight: 500;
    }

    .status-inactive {
        color: #f39c12;
        font-weight: bold;
        background: #f39c121a;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.9rem;
    }

    .status-active {
        color: #28a745;
        font-weight: bold;
        background: #28a7451a;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.9rem;
    }

    .status-expired {
        color: #dc3545;
        font-weight: bold;
        background: #dc35451a;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.9rem;
    }

    .discount-fixed {
        color: #17a2b8;
        font-weight: bold;
        background: #17a2b81a;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.9rem;
    }

    .discount-percentage {
        color: #6610f2;
        font-weight: bold;
        background: #6610f21a;
        padding: 4px 12px;
        border-radius: 12px;
        font-size: 0.9rem;
    }

    @media (max-width: 576px) {
        .voucher-details-container {
            padding: 20px;
        }

        .voucher-info {
            padding: 15px;
        }

        .voucher-details-container h4 {
            font-size: 1.5rem;
        }

        .voucher-info h5 {
            font-size: 1.1rem;
        }

        .voucher-info p {
            font-size: 0.9rem;
            flex-direction: column;
            align-items: flex-start;
            gap: 5px;
        }

        .voucher-info p strong, .voucher-info p span {
            width: 100%;
            text-align: left;
        }
    }
</style>

<div class="voucher-container">
    <div class="voucher-details-container">
        <h4>Chi tiết Voucher #${voucher.id}</h4>

        <!-- Thông tin voucher -->
        <div class="voucher-info">
            <h5>Thông tin Voucher</h5>
            <p><strong>Mã voucher:</strong> <span>${voucher.code}</span></p>
            <p><strong>Mô tả:</strong> <span>${voucher.description}</span></p>
            <p><strong>Loại giảm giá:</strong>
                <span>
                <c:choose>
                    <c:when test="${voucher.discountType == 1}">
                        <span class="discount-fixed">FIXED</span>
                    </c:when>
                    <c:when test="${voucher.discountType == 2}">
                        <span class="discount-percentage">PERCENTAGE</span>
                    </c:when>
                    <c:otherwise>
                        <span>Không xác định</span>
                    </c:otherwise>
                </c:choose>
            </span>
            </p>
            <p><strong>Giá trị giảm:</strong>
                <span>
                <c:choose>
                    <c:when test="${voucher.discountType == 1}">
                        <fmt:formatNumber value="${voucher.discountValue}" type="currency" currencySymbol=" đ"/>
                    </c:when>
                    <c:otherwise>
                        ${voucher.discountValue}%
                    </c:otherwise>
                </c:choose>
            </span>
            </p>
            <p><strong>Giá trị đơn hàng tối thiểu:</strong>
                <span><fmt:formatNumber value="${voucher.minOrderValue}" type="currency" currencySymbol=" đ"/></span>
            </p>
            <p><strong>Giảm giá tối đa:</strong>
                <span>
                <c:if test="${not empty voucher.maxDiscountValue}">
                    <fmt:formatNumber value="${voucher.maxDiscountValue}" type="currency" currencySymbol=" đ"/>
                </c:if>
                <c:if test="${empty voucher.maxDiscountValue}">
                    Không giới hạn
                </c:if>
            </span>
            </p>
            <p><strong>Ngày bắt đầu:</strong> <span>${voucher.startDate}</span></p>
            <p><strong>Ngày kết thúc:</strong> <span>${voucher.endDate}</span></p>
            <p><strong>Giới hạn sử dụng:</strong>
                <span>
                <c:if test="${not empty voucher.usageLimit}">
                    ${voucher.usageLimit} lần
                </c:if>
                <c:if test="${empty voucher.usageLimit}">
                    Không giới hạn
                </c:if>
            </span>
            </p>
            <p><strong>Giới hạn mỗi người dùng:</strong>
                <span>
                <c:if test="${not empty voucher.perUserLimit}">
                    ${voucher.perUserLimit} lần
                </c:if>
                <c:if test="${empty voucher.perUserLimit}">
                    Không giới hạn
                </c:if>
            </span>
            </p>
            <p><strong>Trạng thái:</strong>
                <span>
                <c:choose>
                    <c:when test="${voucher.status == 0}">
                        <span class="status-inactive">INACTIVE</span>
                    </c:when>
                    <c:when test="${voucher.status == 1}">
                        <span class="status-active">ACTIVE</span>
                    </c:when>
                    <c:when test="${voucher.status == 2}">
                        <span class="status-expired">EXPIRED</span>
                    </c:when>
                    <c:otherwise>
                        <span>Không xác định</span>
                    </c:otherwise>
                </c:choose>
            </span>
            </p>
        </div>
    </div>
</div>