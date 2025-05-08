<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - My Bookings</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .booking-list {
            margin-top: 30px;
        }

        .booking-card {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }

        .booking-card-header {
            background-color: var(--primary-color);
            color: #fff;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .booking-card-header h3 {
            margin: 0;
            font-size: 18px;
        }

        .booking-card-body {
            padding: 20px;
        }

        .booking-details {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 20px;
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

        .booking-status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 3px;
            font-size: 14px;
            font-weight: bold;
        }

        .booking-status.pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .booking-status.confirmed {
            background-color: #d4edda;
            color: #155724;
        }

        .booking-status.cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        .booking-status.completed {
            background-color: #d1ecf1;
            color: #0c5460;
        }

        .booking-actions {
            display: flex;
            justify-content: flex-end;
            margin-top: 20px;
        }

        .booking-actions a {
            margin-left: 10px;
        }

        @media (max-width: 768px) {
            .booking-detail {
                width: 50%;
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

    <!-- Bookings Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>My Bookings</h2>
                <p>View and manage your reservations</p>
            </div>

            <div class="booking-list">
                <c:choose>
                    <c:when test="${not empty bookings}">
                        <c:forEach var="booking" items="${bookings}">
                            <div class="booking-card">
                                <div class="booking-card-header">
                                    <h3>Booking #${booking.id}</h3>
                                    <span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                                </div>
                                <div class="booking-card-body">
                                    <div class="booking-details">
                                        <div class="booking-detail">
                                            <div class="booking-detail-label">Room Type</div>
                                            <div>${booking.roomType}</div>
                                        </div>
                                        <div class="booking-detail">
                                            <div class="booking-detail-label">Room Number</div>
                                            <div>${booking.roomNumber}</div>
                                        </div>
                                        <div class="booking-detail">
                                            <div class="booking-detail-label">Check-in Date</div>
                                            <div>${booking.dateFrom}</div>
                                        </div>
                                        <div class="booking-detail">
                                            <div class="booking-detail-label">Check-out Date</div>
                                            <div>${booking.dateTo}</div>
                                        </div>
                                        <div class="booking-detail">
                                            <div class="booking-detail-label">Booking Date</div>
                                            <div>${booking.createdAt}</div>
                                        </div>
                                    </div>
                                    <div class="booking-actions">
                                        <a href="${pageContext.request.contextPath}/booking?id=${booking.id}" class="btn btn-primary">View Details</a>

                                        <c:if test="${booking.status eq 'PENDING'}">
                                            <a href="${pageContext.request.contextPath}/payment?bookingId=${booking.id}" class="btn btn-success">Make Payment</a>
                                        </c:if>

                                        <c:if test="${booking.status eq 'PENDING' || booking.status eq 'CONFIRMED'}">
                                            <a href="${pageContext.request.contextPath}/cancelBooking?id=${booking.id}" class="btn btn-danger" onclick="return confirm('Are you sure you want to cancel this booking?')">Cancel Booking</a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="no-bookings">
                            <p>You don't have any bookings yet.</p>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">Browse Rooms</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
