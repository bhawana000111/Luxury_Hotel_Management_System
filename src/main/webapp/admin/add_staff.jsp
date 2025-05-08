<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Add Staff</title>
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
                <li class="active"><a href="${pageContext.request.contextPath}/admin/staff"><i class="fas fa-user-tie"></i> Staff</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/events"><i class="fas fa-calendar-day"></i> Events</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Add New Staff</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/staff" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Staff</a>
                </div>
            </div>
            
            <!-- Add Staff Form -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/addStaff" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="role">Role</label>
                        <select id="role" name="role" class="form-control" required>
                            <option value="">Select Role</option>
                            <option value="General Manager">General Manager</option>
                            <option value="Front Desk Manager">Front Desk Manager</option>
                            <option value="Housekeeping Manager">Housekeeping Manager</option>
                            <option value="Executive Chef">Executive Chef</option>
                            <option value="Concierge">Concierge</option>
                            <option value="Spa Manager">Spa Manager</option>
                            <option value="Receptionist">Receptionist</option>
                            <option value="Bellboy">Bellboy</option>
                            <option value="Housekeeper">Housekeeper</option>
                            <option value="Chef">Chef</option>
                            <option value="Waiter">Waiter</option>
                            <option value="Bartender">Bartender</option>
                            <option value="Spa Therapist">Spa Therapist</option>
                            <option value="Maintenance">Maintenance</option>
                            <option value="Security">Security</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="text" id="phone" name="phone" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="staffImage">Staff Image</label>
                        <input type="file" id="staffImage" name="staffImage" class="form-control" accept="image/*">
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Add Staff</button>
                        <a href="${pageContext.request.contextPath}/admin/staff" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
