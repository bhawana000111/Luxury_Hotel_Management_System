<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- Admin Sidebar -->
<div class="admin-sidebar">
    <div class="admin-sidebar-header">
        <h3>Admin Panel</h3>
    </div>
    <ul class="admin-menu">
        <li class="${param.active == 'dashboard' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp">
                <i class="fas fa-tachometer-alt"></i>
                <span>Dashboard</span>
            </a>
        </li>
        <li class="${param.active == 'users' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/users">
                <i class="fas fa-users"></i>
                <span>Users</span>
            </a>
        </li>
        <li class="${param.active == 'rooms' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/rooms">
                <i class="fas fa-bed"></i>
                <span>Rooms</span>
            </a>
        </li>
        <li class="${param.active == 'bookings' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/bookings">
                <i class="fas fa-calendar-check"></i>
                <span>Bookings</span>
            </a>
        </li>
        <li class="${param.active == 'payments' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/payments">
                <i class="fas fa-credit-card"></i>
                <span>Payments</span>
            </a>
        </li>
        <li class="${param.active == 'staff' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/staff">
                <i class="fas fa-user-tie"></i>
                <span>Staff</span>
            </a>
        </li>
        <li class="${param.active == 'events' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/events">
                <i class="fas fa-calendar-day"></i>
                <span>Events</span>
            </a>
        </li>
        <li class="${param.active == 'blog' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/blog">
                <i class="fas fa-blog"></i>
                <span>Blog</span>
            </a>
        </li>
        <li class="${param.active == 'feedback' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/feedback">
                <i class="fas fa-comment"></i>
                <span>Feedback</span>
            </a>
        </li>
        <li class="${param.active == 'settings' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/admin/settings.jsp">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </a>
        </li>
    </ul>
</div>
