<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Staff</title>
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
                <h2>Manage Staff</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/addStaff" class="btn btn-primary"><i class="fas fa-plus"></i> Add Staff</a>
                </div>
            </div>
            
            <!-- Staff Role Filter -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/staff" method="get">
                    <div class="filter-group">
                        <label for="role">Filter by Role:</label>
                        <select id="role" name="role" class="form-control" onchange="this.form.submit()">
                            <option value="">All Roles</option>
                            <option value="Management" ${selectedRole eq 'Management' ? 'selected' : ''}>Management</option>
                            <option value="Front Desk" ${selectedRole eq 'Front Desk' ? 'selected' : ''}>Front Desk</option>
                            <option value="Housekeeping" ${selectedRole eq 'Housekeeping' ? 'selected' : ''}>Housekeeping</option>
                            <option value="Restaurant" ${selectedRole eq 'Restaurant' ? 'selected' : ''}>Restaurant</option>
                            <option value="Spa" ${selectedRole eq 'Spa' ? 'selected' : ''}>Spa</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Staff Table -->
            <div class="dashboard-table-container">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Image</th>
                            <th>Name</th>
                            <th>Role</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="staff" items="${staffList}">
                            <tr>
                                <td>${staff.id}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty staff.imagePath}">
                                            <img src="${pageContext.request.contextPath}/${staff.imagePath}" alt="${staff.name}" width="50" height="50" style="object-fit: cover; border-radius: 50%;">
                                        </c:when>
                                        <c:otherwise>
                                            <img src="${pageContext.request.contextPath}/assets/images/staff_default.jpg" alt="${staff.name}" width="50" height="50" style="object-fit: cover; border-radius: 50%;">
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${staff.name}</td>
                                <td>${staff.role}</td>
                                <td>${staff.email}</td>
                                <td>${staff.phone}</td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/editStaff?id=${staff.id}" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i> Edit</a>
                                        <a href="${pageContext.request.contextPath}/admin/deleteStaff?id=${staff.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this staff member?')"><i class="fas fa-trash"></i> Delete</a>
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
