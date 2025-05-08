<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css">
</head>
<body>
    <!-- Include Admin Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Admin Layout -->
    <div class="admin-layout">
        <!-- Include Admin Sidebar -->
        <jsp:include page="partials/sidebar.jsp">
            <jsp:param name="active" value="dashboard" />
        </jsp:include>

        <!-- Admin Content -->
        <div class="admin-content">
            <div class="admin-content-header">
                <h2>Dashboard</h2>
                <div class="admin-content-actions">
                    <span>Welcome, ${sessionScope.userName}</span>
                </div>
            </div>

            <!-- Stats Cards -->
            <div class="admin-cards">
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3 class="admin-card-title">Total Rooms</h3>
                        <div class="admin-card-icon blue">
                            <i class="fas fa-bed"></i>
                        </div>
                    </div>
                    <div class="admin-card-value">25</div>
                    <div class="admin-card-label">Available for booking</div>
                </div>
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3 class="admin-card-title">Bookings</h3>
                        <div class="admin-card-icon green">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                    </div>
                    <div class="admin-card-value">150</div>
                    <div class="admin-card-label">Total reservations</div>
                </div>
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3 class="admin-card-title">Users</h3>
                        <div class="admin-card-icon orange">
                            <i class="fas fa-users"></i>
                        </div>
                    </div>
                    <div class="admin-card-value">300</div>
                    <div class="admin-card-label">Registered accounts</div>
                </div>
                <div class="admin-card">
                    <div class="admin-card-header">
                        <h3 class="admin-card-title">Revenue</h3>
                        <div class="admin-card-icon green">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                    </div>
                    <div class="admin-card-value">$25,000</div>
                    <div class="admin-card-label">Total earnings</div>
                </div>
            </div>

            <!-- Recent Bookings -->
            <div class="admin-table-container">
                <div class="admin-table-header">
                    <h3 class="admin-table-title">Recent Bookings</h3>
                    <div class="admin-table-actions">
                        <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-primary">View All</a>
                    </div>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>User</th>
                            <th>Room</th>
                            <th>Check-in</th>
                            <th>Check-out</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>John Doe</td>
                            <td>Deluxe Room</td>
                            <td>2023-06-15</td>
                            <td>2023-06-20</td>
                            <td><span class="status active">Confirmed</span></td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/booking?id=1" class="view" title="View"><i class="fas fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/editBooking?id=1" class="edit" title="Edit"><i class="fas fa-edit"></i></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>Jane Smith</td>
                            <td>Suite Room</td>
                            <td>2023-06-18</td>
                            <td>2023-06-25</td>
                            <td><span class="status pending">Pending</span></td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/booking?id=2" class="view" title="View"><i class="fas fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/editBooking?id=2" class="edit" title="Edit"><i class="fas fa-edit"></i></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td>Robert Johnson</td>
                            <td>Standard Room</td>
                            <td>2023-06-20</td>
                            <td>2023-06-22</td>
                            <td><span class="status active">Confirmed</span></td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/booking?id=3" class="view" title="View"><i class="fas fa-eye"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/editBooking?id=3" class="edit" title="Edit"><i class="fas fa-edit"></i></a>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Recent Users -->
            <div class="admin-table-container">
                <div class="admin-table-header">
                    <h3 class="admin-table-title">Recent Users</h3>
                    <div class="admin-table-actions">
                        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-primary">View All</a>
                    </div>
                </div>
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Joined</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>1</td>
                            <td>John Doe</td>
                            <td>john@example.com</td>
                            <td>User</td>
                            <td>2023-05-15</td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/editUser?id=1" class="edit" title="Edit"><i class="fas fa-edit"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/deleteUser?id=1" class="delete" title="Delete" onclick="return confirm('Are you sure you want to delete this user?')"><i class="fas fa-trash-alt"></i></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>2</td>
                            <td>Jane Smith</td>
                            <td>jane@example.com</td>
                            <td>User</td>
                            <td>2023-05-18</td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/editUser?id=2" class="edit" title="Edit"><i class="fas fa-edit"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/deleteUser?id=2" class="delete" title="Delete" onclick="return confirm('Are you sure you want to delete this user?')"><i class="fas fa-trash-alt"></i></a>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>3</td>
                            <td>Robert Johnson</td>
                            <td>robert@example.com</td>
                            <td>User</td>
                            <td>2023-05-20</td>
                            <td>
                                <div class="actions">
                                    <a href="${pageContext.request.contextPath}/admin/editUser?id=3" class="edit" title="Edit"><i class="fas fa-edit"></i></a>
                                    <a href="${pageContext.request.contextPath}/admin/deleteUser?id=3" class="delete" title="Delete" onclick="return confirm('Are you sure you want to delete this user?')"><i class="fas fa-trash-alt"></i></a>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
