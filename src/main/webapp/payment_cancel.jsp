<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Payment Cancelled</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Payment Cancel Section -->
    <section class="section">
        <div class="container">
            <div class="payment-cancel">
                <div class="cancel-icon">
                    <i class="fas fa-times-circle"></i>
                </div>
                <h2>Payment Cancelled</h2>
                <p>Your payment was not completed. Your booking is still pending.</p>
                
                <div class="cancel-details">
                    <h3>What Happened?</h3>
                    <p>Your payment was not processed due to one of the following reasons:</p>
                    <ul>
                        <li>You cancelled the payment process</li>
                        <li>There was an issue with your payment method</li>
                        <li>The payment gateway encountered an error</li>
                    </ul>
                    <p>Don't worry, your booking is still saved in our system as pending. You can try again later.</p>
                </div>
                
                <div class="cancel-actions">
                    <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.id}" class="btn btn-primary">Try Again</a>
                    <a href="${pageContext.request.contextPath}/booking?id=${booking.id}" class="btn btn-secondary">View Booking</a>
                    <a href="${pageContext.request.contextPath}/bookings" class="btn btn-secondary">My Bookings</a>
                </div>
                
                <div class="help-section">
                    <h3>Need Help?</h3>
                    <p>If you continue to experience issues with payment, please contact our customer support:</p>
                    <p><i class="fas fa-phone"></i> +1 234 567 8900</p>
                    <p><i class="fas fa-envelope"></i> support@luxuryhotel.com</p>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
