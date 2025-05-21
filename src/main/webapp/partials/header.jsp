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

<!-- Header -->
<header class="header">
    <div class="container">
        <nav class="navbar">
            <div class="navbar-header">
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo">Luxury <span>Hotel</span></a>
                <button class="mobile-menu-toggle" id="mobileMenuToggle">
                    <i class="fas fa-bars"></i>
                </button>
            </div>
            <div class="nav-container">
                <ul class="nav-menu" id="navMenu">
                    <li><a href="${pageContext.request.contextPath}/index.jsp" class="${pageContext.request.servletPath eq '/index.jsp' ? 'active' : ''}">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/rooms.jsp" class="${pageContext.request.servletPath eq '/rooms.jsp' ? 'active' : ''}">Rooms</a></li>
                    <li><a href="${pageContext.request.contextPath}/events.jsp" class="${pageContext.request.servletPath eq '/events.jsp' ? 'active' : ''}">Events</a></li>
                    <li><a href="${pageContext.request.contextPath}/blog.jsp" class="${pageContext.request.servletPath eq '/blog.jsp' ? 'active' : ''}">Blog</a></li>
                    <li><a href="${pageContext.request.contextPath}/about.jsp" class="${pageContext.request.servletPath eq '/about.jsp' ? 'active' : ''}">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact.jsp" class="${pageContext.request.servletPath eq '/contact.jsp' ? 'active' : ''}">Contact</a></li>
                </ul>

                <div class="nav-auth">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userId}">
                            <div class="user-menu">
                                <div class="user-info">
                                    <div class="user-avatar">
                                        <c:if test="${not empty sessionScope.userProfileImage}">
                                            <img src="${pageContext.request.contextPath}/${sessionScope.userProfileImage}" alt="${sessionScope.userName}">
                                        </c:if>
                                        <c:if test="${empty sessionScope.userProfileImage}">
                                            <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="${sessionScope.userName}">
                                        </c:if>
                                        <span>${sessionScope.userName} <i class="fas fa-chevron-down"></i></span>
                                    </div>
                                    <div class="user-dropdown">
                                        <a href="${pageContext.request.contextPath}/profile"><i class="fas fa-user"></i> My Profile</a>
                                        <a href="${pageContext.request.contextPath}/bookings"><i class="fas fa-calendar-check"></i> My Bookings</a>
                                        <c:if test="${sessionScope.userRole eq 'ADMIN'}">
                                            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                                        </c:if>
                                        <a href="${pageContext.request.contextPath}/session_debug.jsp"><i class="fas fa-info-circle"></i> Session Info</a>
                                        <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="auth-buttons">
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Login</a>
                                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </nav>
    </div>
</header>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const mobileMenuToggle = document.getElementById('mobileMenuToggle');
        const navMenu = document.getElementById('navMenu');
        const navContainer = document.querySelector('.nav-container');
        const userInfo = document.querySelector('.user-info');
        const userDropdown = document.querySelector('.user-dropdown');

        if (mobileMenuToggle && navMenu) {
            mobileMenuToggle.addEventListener('click', function() {
                navMenu.classList.toggle('active');
                navContainer.style.display = navMenu.classList.contains('active') ? 'flex' : 'none';
                mobileMenuToggle.classList.toggle('active');
            });
        }

        if (userInfo && userDropdown) {
            userInfo.addEventListener('click', function() {
                if (window.innerWidth <= 991) {
                    userDropdown.classList.toggle('active');
                }
            });
        }

        // Close mobile menu when clicking outside
        document.addEventListener('click', function(event) {
            if (navMenu && navMenu.classList.contains('active') &&
                !event.target.closest('.navbar') &&
                !event.target.closest('.nav-container')) {
                navMenu.classList.remove('active');
                navContainer.style.display = 'none';
                mobileMenuToggle.classList.remove('active');
            }
        });

        // Handle window resize
        window.addEventListener('resize', function() {
            if (window.innerWidth > 991) {
                if (navContainer) {
                    navContainer.style.display = 'flex';
                }
            } else {
                if (navContainer && !navMenu.classList.contains('active')) {
                    navContainer.style.display = 'none';
                }
            }
        });
    });
</script>
