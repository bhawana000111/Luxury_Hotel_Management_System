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
    <style>
        .booking-container {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .booking-header {
            background-color: var(--primary-color);
            color: #fff;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .booking-header h2 {
            margin: 0;
        }

        .booking-body {
            padding: 30px;
        }

        .booking-section {
            margin-bottom: 30px;
        }

        .booking-section h3 {
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .booking-details {
            display: flex;
            flex-wrap: wrap;
        }

        .booking-detail {
            width: 33.33%;
            margin-bottom: 15px;
        }

        .booking-detail-label {
            font-weight: bold;
            margin-bottom: 5px;
            color: #777;
        }

        .room-info {
            display: flex;
            margin-bottom: 20px;
        }

        .room-image {
            width: 200px;
            margin-right: 20px;
        }

        .room-image img {
            width: 100%;
            height: auto;
            border-radius: 5px;
        }

        .room-details {
            flex: 1;
        }

        .billing-details {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
        }

        .billing-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .billing-total {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #ddd;
            font-weight: bold;
            font-size: 18px;
        }

        .booking-actions {
            margin-top: 30px;
            display: flex;
            justify-content: flex-end;
        }

        .booking-actions a {
            margin-left: 10px;
        }

        @media (max-width: 768px) {
            .booking-detail {
                width: 50%;
            }

            .room-info {
                flex-direction: column;
            }

            .room-image {
                width: 100%;
                margin-right: 0;
                margin-bottom: 20px;
            }
        }

        @media (max-width: 576px) {
            .booking-detail {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Booking Details Section -->
    <section class="section">
        <div class="container">
            <div class="booking-container">
                <div class="booking-header">
                    <h2>Booking #${booking.id}</h2>
                    <span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                </div>
                <div class="booking-body">
                    <div class="booking-section">
                        <h3>Booking Information</h3>
                        <div class="booking-details">
                            <div class="booking-detail">
                                <div class="booking-detail-label">Booking ID</div>
                                <div>${booking.id}</div>
                            </div>
                            <div class="booking-detail">
                                <div class="booking-detail-label">Booking Date</div>
                                <div>${booking.createdAt}</div>
                            </div>
                            <div class="booking-detail">
                                <div class="booking-detail-label">Status</div>
                                <div><span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span></div>
                            </div>
                            <div class="booking-detail">
                                <div class="booking-detail-label">Check-in Date</div>
                                <div>${booking.dateFrom}</div>
                            </div>
                            <div class="booking-detail">
                                <div class="booking-detail-label">Check-out Date</div>
                                <div>${booking.dateTo}</div>
                            </div>
                        </div>
                    </div>

                    <div class="booking-section">
                        <h3>Room Information</h3>
                        <div class="room-info">
                            <div class="room-image">
                                <img src="${pageContext.request.contextPath}/assets/images/${booking.roomType.toLowerCase()}_room.jpg" alt="${booking.roomType} Room">
                            </div>
                            <div class="room-details">
                                <h4>${booking.roomType} Room</h4>
                                <p>Room Number: ${booking.roomNumber}</p>
                                <p>A comfortable ${booking.roomType.toLowerCase()} room with modern amenities and elegant design.</p>
                            </div>
                        </div>
                    </div>

                    <div class="booking-section">
                        <h3>Billing Information</h3>
                        <div class="billing-details">
                            <c:choose>
                                <c:when test="${not empty billing}">
                                    <div class="billing-item">
                                        <span>Room Charge</span>
                                        <span>$${billing.amount}</span>
                                    </div>
                                    <div class="billing-item">
                                        <span>Taxes & Fees</span>
                                        <span>Included</span>
                                    </div>
                                    <div class="billing-total">
                                        <span>Total</span>
                                        <span>$${billing.amount}</span>
                                    </div>
                                    <div style="margin-top: 15px;">
                                        <c:choose>
                                            <c:when test="${billing.status eq 'PAID'}">
                                                <div style="display: flex; align-items: center; margin-bottom: 15px;">
                                                    <div style="background-color: #4CAF50; color: white; padding: 8px 15px; border-radius: 30px; display: inline-block; font-weight: bold; font-size: 18px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-right: 10px;">
                                                        <i class="fas fa-check-circle"></i> PAID
                                                    </div>
                                                    <span style="color: #4CAF50; font-weight: 500;">Payment completed successfully</span>
                                                </div>
                                                <p><strong>Paid On:</strong> ${billing.paidOn}</p>
                                                <p><strong>Payment Method:</strong> ${billing.paymentMethod}</p>
                                                <c:if test="${not empty billing.transactionId}">
                                                    <p><strong>Transaction ID:</strong> ${billing.transactionId}</p>
                                                </c:if>
                                            </c:when>
                                            <c:otherwise>
                                                <p><strong>Payment Status:</strong> ${billing.status}</p>
                                                <c:if test="${not empty billing.paidOn}">
                                                    <p><strong>Paid On:</strong> ${billing.paidOn}</p>
                                                </c:if>
                                                <c:if test="${not empty billing.paymentMethod}">
                                                    <p><strong>Payment Method:</strong> ${billing.paymentMethod}</p>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <p>Billing information not available.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="booking-actions">
                        <a href="${pageContext.request.contextPath}/bookings" class="btn btn-secondary">Back to Bookings</a>

                        <c:if test="${booking.status eq 'PENDING'}">
                            <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.id}" class="btn btn-primary">Make Payment</a>
                        </c:if>

                        <c:if test="${booking.status eq 'PENDING' || booking.status eq 'CONFIRMED'}">
                            <a href="${pageContext.request.contextPath}/cancelBooking?id=${booking.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel Booking</a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
