<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Booking Details</title>
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
                <h2>Booking Details</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/bookings" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Bookings</a>
                </div>
            </div>
            
            <!-- Booking Details -->
            <div class="booking-details-container">
                <div class="booking-header">
                    <h3>Booking #${booking.id}</h3>
                    <span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                </div>
                
                <div class="booking-info">
                    <div class="booking-section">
                        <h4>Guest Information</h4>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="label">Name:</span>
                                <span class="value">${booking.userName}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Email:</span>
                                <span class="value">${booking.userEmail}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">User ID:</span>
                                <span class="value">${booking.userId}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="booking-section">
                        <h4>Room Information</h4>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="label">Room Type:</span>
                                <span class="value">${booking.roomType}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Room Number:</span>
                                <span class="value">${booking.roomNumber}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Room ID:</span>
                                <span class="value">${booking.roomId}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="booking-section">
                        <h4>Booking Information</h4>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="label">Check-in Date:</span>
                                <span class="value">${booking.dateFrom}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Check-out Date:</span>
                                <span class="value">${booking.dateTo}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Booking Date:</span>
                                <span class="value">${booking.createdAt}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Last Updated:</span>
                                <span class="value">${booking.updatedAt}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Status:</span>
                                <span class="value booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="booking-section">
                        <h4>Billing Information</h4>
                        <div class="info-grid">
                            <c:choose>
                                <c:when test="${not empty billing}">
                                    <div class="info-item">
                                        <span class="label">Amount:</span>
                                        <span class="value">$${billing.amount}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">Status:</span>
                                        <span class="value">${billing.status}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">Payment Date:</span>
                                        <span class="value">${billing.paidOn != null ? billing.paidOn : 'Not paid yet'}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">Payment Method:</span>
                                        <span class="value">${billing.paymentMethod != null ? billing.paymentMethod : 'N/A'}</span>
                                    </div>
                                    <div class="info-item">
                                        <span class="label">Transaction ID:</span>
                                        <span class="value">${billing.transactionId != null ? billing.transactionId : 'N/A'}</span>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="info-item">
                                        <span class="value">No billing information available</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
                
                <!-- Update Booking Status -->
                <div class="booking-actions">
                    <h4>Update Booking Status</h4>
                    <form action="${pageContext.request.contextPath}/admin/updateBooking" method="post">
                        <input type="hidden" name="id" value="${booking.id}">
                        <div class="form-group">
                            <label for="status">New Status:</label>
                            <select id="status" name="status" class="form-control" required>
                                <option value="PENDING" ${booking.status eq 'PENDING' ? 'selected' : ''}>Pending</option>
                                <option value="CONFIRMED" ${booking.status eq 'CONFIRMED' ? 'selected' : ''}>Confirmed</option>
                                <option value="CANCELLED" ${booking.status eq 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                <option value="COMPLETED" ${booking.status eq 'COMPLETED' ? 'selected' : ''}>Completed</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Update Status</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
