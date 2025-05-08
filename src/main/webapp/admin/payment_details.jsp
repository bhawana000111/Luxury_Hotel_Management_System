<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Payment Details</title>
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
                <h2>Payment Details</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/payments" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Payments</a>
                </div>
            </div>
            
            <!-- Payment Details -->
            <div class="payment-details-container">
                <div class="payment-header">
                    <h3>Payment #${payment.id}</h3>
                    <span class="payment-status ${payment.status.toLowerCase()}">${payment.status}</span>
                </div>
                
                <div class="payment-info">
                    <div class="payment-section">
                        <h4>Payment Information</h4>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="label">Payment ID:</span>
                                <span class="value">${payment.id}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Amount:</span>
                                <span class="value">$${payment.amount}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Payment Method:</span>
                                <span class="value">${payment.paymentMethod}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Transaction ID:</span>
                                <span class="value">${payment.transactionId != null ? payment.transactionId : 'N/A'}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Status:</span>
                                <span class="value payment-status ${payment.status.toLowerCase()}">${payment.status}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Payment Date:</span>
                                <span class="value">
                                    <c:choose>
                                        <c:when test="${not empty payment.paymentDate}">
                                            <fmt:formatDate value="${payment.paymentDate}" pattern="MMM dd, yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Not paid yet</span>
                                        </c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="info-item">
                                <span class="label">Created At:</span>
                                <span class="value"><fmt:formatDate value="${payment.createdAt}" pattern="MMM dd, yyyy HH:mm" /></span>
                            </div>
                            <div class="info-item">
                                <span class="label">Updated At:</span>
                                <span class="value"><fmt:formatDate value="${payment.updatedAt}" pattern="MMM dd, yyyy HH:mm" /></span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="payment-section">
                        <h4>Booking Information</h4>
                        <div class="info-grid">
                            <div class="info-item">
                                <span class="label">Booking ID:</span>
                                <span class="value">${booking.id}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Guest Name:</span>
                                <span class="value">${booking.userName}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Room Type:</span>
                                <span class="value">${room.type}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Room Number:</span>
                                <span class="value">${room.number}</span>
                            </div>
                            <div class="info-item">
                                <span class="label">Check-in Date:</span>
                                <span class="value"><fmt:formatDate value="${booking.dateFrom}" pattern="MMM dd, yyyy" /></span>
                            </div>
                            <div class="info-item">
                                <span class="label">Check-out Date:</span>
                                <span class="value"><fmt:formatDate value="${booking.dateTo}" pattern="MMM dd, yyyy" /></span>
                            </div>
                            <div class="info-item">
                                <span class="label">Booking Status:</span>
                                <span class="value booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Payment Actions -->
                <div class="payment-actions">
                    <h4>Payment Actions</h4>
                    <div class="action-buttons">
                        <c:if test="${payment.status eq 'PENDING'}">
                            <form action="${pageContext.request.contextPath}/admin/processPayment" method="post" style="display: inline;">
                                <input type="hidden" name="id" value="${payment.id}">
                                <button type="submit" class="btn btn-primary">Process Payment</button>
                            </form>
                        </c:if>
                        
                        <c:if test="${payment.status eq 'COMPLETED'}">
                            <form action="${pageContext.request.contextPath}/admin/refundPayment" method="post" style="display: inline;">
                                <input type="hidden" name="id" value="${payment.id}">
                                <button type="submit" class="btn btn-warning" onclick="return confirm('Are you sure you want to refund this payment?')">Refund Payment</button>
                            </form>
                        </c:if>
                        
                        <a href="${pageContext.request.contextPath}/admin/booking?id=${booking.id}" class="btn btn-secondary">View Booking</a>
                        
                        <c:if test="${payment.status ne 'COMPLETED' && payment.status ne 'REFUNDED'}">
                            <form action="${pageContext.request.contextPath}/admin/deletePayment" method="post" style="display: inline;">
                                <input type="hidden" name="id" value="${payment.id}">
                                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to delete this payment record?')">Delete Payment</button>
                            </form>
                        </c:if>
                    </div>
                </div>
                
                <!-- Payment Notes -->
                <div class="payment-notes">
                    <h4>Notes</h4>
                    <form action="${pageContext.request.contextPath}/admin/addPaymentNote" method="post">
                        <input type="hidden" name="id" value="${payment.id}">
                        <div class="form-group">
                            <textarea name="note" class="form-control" rows="3" placeholder="Add a note about this payment..."></textarea>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Add Note</button>
                        </div>
                    </form>
                    
                    <c:if test="${not empty paymentNotes}">
                        <div class="notes-list">
                            <c:forEach var="note" items="${paymentNotes}">
                                <div class="note-item">
                                    <div class="note-header">
                                        <span class="note-author">${note.authorName}</span>
                                        <span class="note-date"><fmt:formatDate value="${note.createdAt}" pattern="MMM dd, yyyy HH:mm" /></span>
                                    </div>
                                    <div class="note-content">${note.content}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:if>
                    
                    <c:if test="${empty paymentNotes}">
                        <p class="text-muted">No notes available for this payment.</p>
                    </c:if>
                </div>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
