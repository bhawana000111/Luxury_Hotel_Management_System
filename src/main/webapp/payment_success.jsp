<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Payment Success</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Payment Success Section -->
    <section class="section">
        <div class="container">
            <div class="payment-success">
                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div style="background-color: #4CAF50; color: white; padding: 10px 20px; border-radius: 30px; display: inline-block; margin: 15px 0; font-weight: bold; font-size: 24px; box-shadow: 0 4px 8px rgba(0,0,0,0.1);">
                    <i class="fas fa-check-circle"></i> PAID
                </div>
                <h2>Payment Successful!</h2>
                <p>Your booking has been confirmed. Thank you for choosing Luxury Hotel.</p>

                <div class="payment-details">
                    <h3>Payment Details</h3>
                    <div class="detail">
                        <span class="label">Transaction ID:</span>
                        <span class="value">${payment.transactionId}</span>
                    </div>
                    <div class="detail">
                        <span class="label">Amount Paid:</span>
                        <span class="value">$${payment.amount}</span>
                    </div>
                    <div class="detail">
                        <span class="label">Payment Method:</span>
                        <span class="value">${payment.paymentMethod}</span>
                    </div>
                    <div class="detail">
                        <span class="label">Payment Date:</span>
                        <span class="value"><fmt:formatDate value="${payment.paymentDate}" pattern="MMM dd, yyyy HH:mm" /></span>
                    </div>
                </div>

                <div class="booking-summary">
                    <h3>Booking Summary</h3>
                    <div class="detail">
                        <span class="label">Booking ID:</span>
                        <span class="value">${booking.id}</span>
                    </div>
                    <div class="detail">
                        <span class="label">Room Type:</span>
                        <span class="value">${room.type}</span>
                    </div>
                    <div class="detail">
                        <span class="label">Room Number:</span>
                        <span class="value">${room.number}</span>
                    </div>
                    <div class="detail">
                        <span class="label">Check-in Date:</span>
                        <span class="value"><fmt:formatDate value="${booking.dateFrom}" pattern="MMM dd, yyyy" /></span>
                    </div>
                    <div class="detail">
                        <span class="label">Check-out Date:</span>
                        <span class="value"><fmt:formatDate value="${booking.dateTo}" pattern="MMM dd, yyyy" /></span>
                    </div>
                </div>

                <div class="success-actions">
                    <a href="${pageContext.request.contextPath}/booking?id=${booking.id}" class="btn btn-primary">View Booking Details</a>
                    <a href="${pageContext.request.contextPath}/bookings" class="btn btn-secondary">My Bookings</a>
                </div>

                <div class="email-notification">
                    <p><i class="fas fa-envelope"></i> A confirmation email has been sent to your registered email address.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
