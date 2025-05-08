<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Display success or error messages if available -->
<c:if test="${not empty param.message}">
    <div class="alert alert-success">
        ${param.message}
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="alert alert-danger">
        ${param.error}
    </div>
</c:if>
<c:if test="${not empty message}">
    <div class="alert alert-success">
        ${message}
    </div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">
        ${error}
    </div>
</c:if>

<!-- Admin Header -->
<header class="admin-header">
    <div class="container">
        <div class="admin-navbar">
            <div class="admin-logo">
                <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                    <i class="fas fa-hotel"></i> Luxury Hotel <span>Admin</span>
                </a>
            </div>
            <div class="admin-nav-right">
                <div class="admin-search">
                    <form action="${pageContext.request.contextPath}/admin/search" method="get">
                        <input type="text" name="query" placeholder="Search...">
                        <button type="submit"><i class="fas fa-search"></i></button>
                    </form>
                </div>
                <div class="admin-user-menu">
                    <div class="admin-user-info">
                        <c:if test="${not empty sessionScope.userProfileImage}">
                            <img src="${pageContext.request.contextPath}/${sessionScope.userProfileImage}" alt="${sessionScope.userName}">
                        </c:if>
                        <c:if test="${empty sessionScope.userProfileImage}">
                            <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="${sessionScope.userName}">
                        </c:if>
                        <span>${sessionScope.userName}</span>
                        <i class="fas fa-chevron-down"></i>
                    </div>
                    <div class="admin-dropdown-menu">
                        <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a>
                        <a href="${pageContext.request.contextPath}/index.jsp"><i class="fas fa-home"></i> View Site</a>
                        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const adminUserInfo = document.querySelector('.admin-user-info');
        const adminDropdownMenu = document.querySelector('.admin-dropdown-menu');
        
        if (adminUserInfo && adminDropdownMenu) {
            adminUserInfo.addEventListener('click', function() {
                adminDropdownMenu.classList.toggle('active');
            });
            
            // Close dropdown when clicking outside
            document.addEventListener('click', function(event) {
                if (!adminUserInfo.contains(event.target) && !adminDropdownMenu.contains(event.target)) {
                    adminDropdownMenu.classList.remove('active');
                }
            });
        }
    });
</script>
