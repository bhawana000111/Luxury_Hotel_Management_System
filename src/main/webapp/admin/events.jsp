<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Events</title>
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
                <h2>Manage Events</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/addEvent" class="btn btn-primary"><i class="fas fa-plus"></i> Add Event</a>
                </div>
            </div>
            
            <!-- Event Location Filter -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/events" method="get">
                    <div class="filter-group">
                        <label for="location">Filter by Location:</label>
                        <select id="location" name="location" class="form-control" onchange="this.form.submit()">
                            <option value="">All Locations</option>
                            <option value="Grand Ballroom" ${selectedLocation eq 'Grand Ballroom' ? 'selected' : ''}>Grand Ballroom</option>
                            <option value="Garden Terrace" ${selectedLocation eq 'Garden Terrace' ? 'selected' : ''}>Garden Terrace</option>
                            <option value="Wine Cellar" ${selectedLocation eq 'Wine Cellar' ? 'selected' : ''}>Wine Cellar</option>
                            <option value="Conference Room" ${selectedLocation eq 'Conference Room' ? 'selected' : ''}>Conference Room</option>
                            <option value="Lounge Bar" ${selectedLocation eq 'Lounge Bar' ? 'selected' : ''}>Lounge Bar</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Events Table -->
            <div class="dashboard-table-container">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Event Name</th>
                            <th>Date</th>
                            <th>Location</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="event" items="${events}">
                            <tr>
                                <td>${event.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty event.imagePath}">
                                            <img src="${pageContext.request.contextPath}/${event.imagePath}" alt="${event.eventName}" width="80" height="60" style="object-fit: cover; border-radius: 5px;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/event_default.jpg" alt="${event.eventName}" width="80" height="60" style="object-fit: cover; border-radius: 5px;">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${event.eventName}</td>
                                <td>${event.date}</td>
                                <td>${event.location}</td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/event?id=${event.id}" class="btn btn-secondary btn-sm" target="_blank"><i class="fas fa-eye"></i> View</a>
                                        <a href="${pageContext.request.contextPath}/admin/editEvent?id=${event.id}" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i> Edit</a>
                                        <a href="${pageContext.request.contextPath}/admin/deleteEvent?id=${event.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this event?')"><i class="fas fa-trash"></i> Delete</a>
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
