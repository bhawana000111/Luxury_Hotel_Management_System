<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Rooms</title>
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
                <li class="active"><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fas fa-bed"></i> Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-check"></i> Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="fas fa-user-tie"></i> Staff</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/events"><i class="fas fa-calendar-day"></i> Events</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Manage Rooms</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/addRoom" class="btn btn-primary"><i class="fas fa-plus"></i> Add Room</a>
                </div>
            </div>
            
            <!-- Room Type Filter -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/rooms" method="get">
                    <div class="filter-group">
                        <label for="type">Filter by Type:</label>
                        <select id="type" name="type" class="form-control" onchange="this.form.submit()">
                            <option value="">All Types</option>
                            <option value="Standard" ${selectedType eq 'Standard' ? 'selected' : ''}>Standard</option>
                            <option value="Deluxe" ${selectedType eq 'Deluxe' ? 'selected' : ''}>Deluxe</option>
                            <option value="Suite" ${selectedType eq 'Suite' ? 'selected' : ''}>Suite</option>
                            <option value="Executive" ${selectedType eq 'Executive' ? 'selected' : ''}>Executive</option>
                            <option value="Presidential" ${selectedType eq 'Presidential' ? 'selected' : ''}>Presidential</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Rooms Table -->
            <div class="dashboard-table-container">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Type</th>
                            <th>Number</th>
                            <th>Price</th>
                            <th>Availability</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="room" items="${rooms}">
                            <tr>
                                <td>${room.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty room.imagePath}">
                                            <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="${room.type}" width="80" height="60" style="object-fit: cover; border-radius: 5px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/${room.type.toLowerCase()}_room.jpg" alt="${room.type}" width="80" height="60" style="object-fit: cover; border-radius: 5px;">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${room.type}</td>
                                <td>${room.number}</td>
                                <td>$${room.price}</td>
                                <td>
                                    <span class="badge ${room.availability ? 'badge-success' : 'badge-danger'}">
                                        ${room.availability ? 'Available' : 'Not Available'}
                                    </span>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/editRoom?id=${room.id}" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i> Edit</a>
                                        <a href="${pageContext.request.contextPath}/admin/deleteRoom?id=${room.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this room?')"><i class="fas fa-trash"></i> Delete</a>
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
