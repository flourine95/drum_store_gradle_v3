<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>${pageTitle}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/bootstrap-5.3.3-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/bootstrap-icons-1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/fontawesome-free-5.15.4-web/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/animate.css-4.1.1/animate.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/sweetalert2-11.17.2/sweetalert2.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/lib/DataTables/datatables.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/custom.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/dashboard.css">
    <script src="${pageContext.request.contextPath}/assets/lib/jquery-3.7.1/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/lib/bootstrap-5.3.3-dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/lib/sweetalert2-11.17.2/sweetalert2.all.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Sortable/1.15.6/Sortable.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/lib/DataTables/datatables.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/lib/chart.js-4.4.8/package/dist/chart.umd.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/dashboard.js"></script>
</head>
<body>
<div class="wrapper ">
    <jsp:include page="header.jsp"/>
    <div class="main">
        <main class="content px-3 py-4">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
                        <div class="row">
                            <div class="col-12 d-flex justify-content-between align-items-center mb-3">
                                <h4 class="page-title">${pageTitle}</h4>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-12">
                        <jsp:include page="${content}"/>
                    </div>
                </div>

            </div>
        </main>
        <jsp:include page="footer.jsp"/>
    </div>
</div>
</body>
</html>
