<%@ page contentType="text/html;charset=UTF-8" %>
<main class="p-5" style=" min-height: 1000px; background-color: #f8f9fa;">
    <div class="container">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="profile-sidebar.jsp" />

            <!-- Main Content -->
            <jsp:include page="${profileContent}" />
        </div>
    </div>
</main>
