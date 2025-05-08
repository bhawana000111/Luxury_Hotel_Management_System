<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Payment Management</title>
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
                <li class="active"><a href="${pageContext.request.contextPath}/admin/payments"><i class="fas fa-credit-card"></i> Payments</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="fas fa-user-tie"></i> Staff</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/events"><i class="fas fa-calendar-day"></i> Events</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Payment Management</h2>
            </div>
            
            <!-- Revenue Summary -->
            <div class="revenue-summary">
                <div class="revenue-card">
                    <h3>Total Revenue</h3>
                    <div class="amount">$${totalRevenue}</div>
                </div>
                <div class="revenue-card">
                    <h3>This Month</h3>
                    <div class="amount">$${monthlyRevenue != null ? monthlyRevenue : '0.00'}</div>
                </div>
                <div class="revenue-card">
                    <h3>Today</h3>
                    <div class="amount">$${dailyRevenue != null ? dailyRevenue : '0.00'}</div>
                </div>
                <div class="revenue-card">
                    <h3>Pending Payments</h3>
                    <div class="amount">${pendingPayments != null ? pendingPayments : '0'}</div>
                </div>
            </div>
            
            <!-- Payment Status Filter -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/payments" method="get">
                    <div class="filter-group">
                        <label for="status">Filter by Status:</label>
                        <select id="status" name="status" class="form-control" onchange="this.form.submit()">
                            <option value="">All Statuses</option>
                            <option value="PENDING" ${selectedStatus eq 'PENDING' ? 'selected' : ''}>Pending</option>
                            <option value="COMPLETED" ${selectedStatus eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            <option value="FAILED" ${selectedStatus eq 'FAILED' ? 'selected' : ''}>Failed</option>
                            <option value="REFUNDED" ${selectedStatus eq 'REFUNDED' ? 'selected' : ''}>Refunded</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Payments Table -->
            <div class="dashboard-table-container">
                <table class="dashboard-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Booking ID</th>
                            <th>Guest</th>
                            <th>Amount</th>
                            <th>Payment Method</th>
                            <th>Status</th>
                            <th>Payment Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="payment" items="${payments}">
                            <tr>
                                <td>${payment.id}</td>
                                <td>${payment.bookingId}</td>
                                <td>${payment.userName}</td>
                                <td>$${payment.amount}</td>
                                <td>${payment.paymentMethod}</td>
                                <td>
                                    <span class="payment-status ${payment.status.toLowerCase()}">${payment.status}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty payment.paymentDate}">
                                            <fmt:formatDate value="${payment.paymentDate}" pattern="MMM dd, yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Not paid yet</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="actions">
                                        <a href="${pageContext.request.contextPath}/admin/payment?id=${payment.id}" class="btn btn-primary btn-sm"><i class="fas fa-eye"></i> View</a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        
                        <c:if test="${empty payments}">
                            <tr>
                                <td colspan="8" class="text-center">No payments found</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
