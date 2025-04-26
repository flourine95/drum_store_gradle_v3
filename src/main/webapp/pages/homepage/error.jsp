<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle}</title>
    <link href="${pageContext.request.contextPath}/assets/lib/bootstrap-5.3.3-dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/lib/bootstrap-icons-1.11.3/font/bootstrap-icons.min.css"
          rel="stylesheet">
</head>
<body class="bg-light">
<div class="container min-vh-100 d-flex align-items-center justify-content-center">
    <div class="text-center">
        <h1 class="display-1 fw-bold text-danger">${errorCode}</h1>
        <p class="fs-3 text-secondary">${errorMessage}</p>
        <p class="lead">
            ${errorDescription}
        </p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
            <i class="bi bi-house-door"></i> Về trang chủ
        </a>
        <c:if test="${not empty backUrl}">
            <a href="${backUrl}" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </c:if>
    </div>
</div>
<script src="${pageContext.request.contextPath}/assets/lib/bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>