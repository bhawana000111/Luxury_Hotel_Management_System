<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Bookings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../partials/header.jsp" />
    
    <!-- Dashboard Section -->
    <section class="dashboard">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fas fa-bed"></i> Rooms</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-check"></i> Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="fas fa-user-tie"></i> Staff</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/events"><i class="fas fa-calendar-day"></i> Events</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Manage Bookings</h2>
            </div>
            
            <!-- Booking Status Filter -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/bookings" method="get">
                    <div class="filter-group">
                        <label for="status">Filter by Status:</label>
                        <select id="status" name="status" class="form-control" onchange="this.form.submit()">
                            <option value="">All Statuses</option>
                            <option value="PENDING" ${selectedStatus eq 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="CONFIRMED" ${selectedStatus eq 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                            <option value="CANCELLED" ${selectedStatus eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                            <option value="COMPLETED" ${selectedStatus eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Bookings Table -->
            <div class="dashboard-table-container">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Status</th>
                            <th>Booking Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="booking" items="${bookings}">
                            <tr>
                                <td>${booking.id}</td>
                                <td>${booking.userName}</td>
                                <td>${booking.roomType} (${booking.roomNumber})</td>
                                <td>${booking.dateFrom}</td>
                                <td>${booking.dateTo}</td>
                                <td>
                                    <span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                                </td>
                                <td>${booking.createdAt}</td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/booking?id=${booking.id}" class="btn btn-primary btn-sm"><i class="fas fa-eye"></i> View</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
