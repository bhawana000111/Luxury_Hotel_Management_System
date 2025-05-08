<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Edit Event</title>
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
                <li><a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-check"></i> Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="fas fa-user-tie"></i> Staff</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/events"><i class="fas fa-calendar-day"></i> Events</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Edit Event</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Events</a>
                </div>
            </div>
            
            <!-- Edit Event Form -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/editEvent" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${event.id}">
                    
                    <div class="form-group">
                        <label for="eventName">Event Name</label>
                        <input type="text" id="eventName" name="eventName" class="form-control" value="${event.eventName}" required>
                    </div>
                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" class="form-control" rows="5" required>${event.description}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="date" id="date" name="date" class="form-control" value="${event.date}" required>
                    </div>
                    <div class="form-group">
                        <label for="location">Location</label>
                        <select id="location" name="location" class="form-control" required>
                            <option value="">Select Location</option>
                            <option value="Grand Ballroom" ${event.location eq 'Grand Ballroom' ? 'selected' : ''}>Grand Ballroom</option>
                            <option value="Garden Terrace" ${event.location eq 'Garden Terrace' ? 'selected' : ''}>Garden Terrace</option>
                            <option value="Wine Cellar" ${event.location eq 'Wine Cellar' ? 'selected' : ''}>Wine Cellar</option>
                            <option value="Conference Room" ${event.location eq 'Conference Room' ? 'selected' : ''}>Conference Room</option>
                            <option value="Lounge Bar" ${event.location eq 'Lounge Bar' ? 'selected' : ''}>Lounge Bar</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="eventImage">Event Image</label>
                        <c:if test="${not empty event.imagePath}">
                            <div class="current-image">
                                <img src="${pageContext.request.contextPath}/${event.imagePath}" alt="${event.eventName}" width="200">
                                <p>Current image</p>
                            </div>
                        </c:if>
                        <input type="file" id="eventImage" name="eventImage" class="form-control" accept="image/*">
                        <small>Leave empty to keep current image</small>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Update Event</button>
                        <a href="${pageContext.request.contextPath}/admin/events" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
