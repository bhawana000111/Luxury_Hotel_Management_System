<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Edit Room</title>
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
                <h2>Edit Room</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Rooms</a>
                </div>
            </div>
            
            <!-- Edit Room Form -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/editRoom" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${room.id}">
                    
                    <div class="form-group">
                        <label for="type">Room Type</label>
                        <select id="type" name="type" class="form-control" required>
                            <option value="">Select Room Type</option>
                            <option value="Standard" ${room.type eq 'Standard' ? 'selected' : ''}>Standard</option>
                            <option value="Deluxe" ${room.type eq 'Deluxe' ? 'selected' : ''}>Deluxe</option>
                            <option value="Suite" ${room.type eq 'Suite' ? 'selected' : ''}>Suite</option>
                            <option value="Executive" ${room.type eq 'Executive' ? 'selected' : ''}>Executive</option>
                            <option value="Presidential" ${room.type eq 'Presidential' ? 'selected' : ''}>Presidential</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="number">Room Number</label>
                        <input type="text" id="number" name="number" class="form-control" value="${room.number}" required>
                    </div>
                    <div class="form-group">
                        <label for="price">Price per Night ($)</label>
                        <input type="number" id="price" name="price" class="form-control" min="0" step="0.01" value="${room.price}" required>
                    </div>
                    <div class="form-group">
                        <label for="availability">Availability</label>
                        <select id="availability" name="availability" class="form-control" required>
                            <option value="true" ${room.availability ? 'selected' : ''}>Available</option>
                            <option value="false" ${!room.availability ? 'selected' : ''}>Not Available</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="5">${room.description}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="roomImage">Room Image</label>
                        <c:if test="${not empty room.imagePath}">
                            <div class="current-image">
                                <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="${room.type}" width="200">
                                <p>Current image</p>
                            </div>
                        </c:if>
                        <input type="file" id="roomImage" name="roomImage" class="form-control" accept="image/*">
                        <small>Leave empty to keep current image</small>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Update Room</button>
                        <a href="${pageContext.request.contextPath}/admin/rooms" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
