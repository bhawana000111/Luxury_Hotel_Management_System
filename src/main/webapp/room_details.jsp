<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - ${room.type} Room</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .room-details {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        
        .room-image {
            width: 50%;
            padding-right: 20px;
        }
        
        .room-image img {
            width: 100%;
            height: auto;
            border-radius: 5px;
        }
        
        .room-info {
            width: 50%;
            padding-left: 20px;
        }
        
        .room-info h2 {
            margin-bottom: 15px;
        }
        
        .room-info .price {
            font-size: 24px;
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .room-info .description {
            margin-bottom: 20px;
        }
        
        .room-features {
            margin-bottom: 20px;
        }
        
        .room-features h3 {
            margin-bottom: 10px;
        }
        
        .room-features ul {
            list-style: none;
            padding: 0;
        }
        
        .room-features ul li {
            margin-bottom: 10px;
        }
        
        .room-features ul li i {
            margin-right: 10px;
            color: var(--secondary-color);
        }
        
        .booking-form {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 5px;
            margin-top: 20px;
        }
        
        .booking-form h3 {
            margin-bottom: 15px;
        }
        
        @media (max-width: 768px) {
            .room-image, .room-info {
                width: 100%;
                padding: 0;
            }
            
            .room-image {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Room Details Section -->
    <section class="section">
        <div class="container">
            <div class="room-details">
                <div class="room-image">
                    <c:choose>
                        <c:when test="${not empty room.imagePath}">
                            <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="${room.type} Room">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/images/${room.type.toLowerCase()}_room.jpg" alt="${room.type} Room">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="room-info">
                    <h2>${room.type} Room</h2>
                    <div class="price">$${room.price} / night</div>
                    <div class="description">
                        <p>${room.description}</p>
                    </div>
                    <div class="room-features">
                        <h3>Room Features</h3>
                        <ul>
                            <li><i class="fas fa-bed"></i> King-size bed</li>
                            <li><i class="fas fa-bath"></i> Private bathroom with shower and bathtub</li>
                            <li><i class="fas fa-wifi"></i> Free high-speed WiFi</li>
                            <li><i class="fas fa-tv"></i> 55-inch Smart TV</li>
                            <li><i class="fas fa-coffee"></i> Coffee maker</li>
                            <li><i class="fas fa-snowflake"></i> Air conditioning</li>
                            <li><i class="fas fa-concierge-bell"></i> 24-hour room service</li>
                            <li><i class="fas fa-safe"></i> In-room safe</li>
                        </ul>
                    </div>
                    <div class="room-actions">
                        <c:if test="${room.availability}">
                            <a href="${pageContext.request.contextPath}/bookRoom?roomId=${room.id}" class="btn btn-primary">Book Now</a>
                        </c:if>
                        <c:if test="${!room.availability}">
                            <span class="btn btn-danger disabled">Not Available</span>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">Back to Rooms</a>
                    </div>
                </div>
            </div>
            
            <!-- Booking Form (shown only if room is available and user is logged in) -->
            <c:if test="${room.availability && not empty sessionScope.userId}">
                <div class="booking-form">
                    <h3>Book This Room</h3>
                    <form action="${pageContext.request.contextPath}/bookRoom" method="post" id="bookingForm">
                        <input type="hidden" name="roomId" value="${room.id}">
                        <div class="form-group">
                            <label for="dateFrom">Check-in Date</label>
                            <input type="date" id="dateFrom" name="dateFrom" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="dateTo">Check-out Date</label>
                            <input type="date" id="dateTo" name="dateTo" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Book Now</button>
                        </div>
                    </form>
                </div>
            </c:if>
            
            <!-- Login Prompt (shown if user is not logged in) -->
            <c:if test="${room.availability && empty sessionScope.userId}">
                <div class="login-prompt">
                    <p>Please <a href="${pageContext.request.contextPath}/login">login</a> or <a href="${pageContext.request.contextPath}/register">register</a> to book this room.</p>
                </div>
            </c:if>
        </div>
    </section>
    
    <!-- Similar Rooms Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Similar Rooms</h2>
                <p>You might also like these rooms</p>
            </div>
            <div class="room-cards">
                <!-- This would be populated with similar rooms from the database -->
                <div class="room-card">
                    <img src="${pageContext.request.contextPath}/assets/images/deluxe_room.jpg" alt="Deluxe Room">
                    <div class="room-card-content">
                        <h3>Deluxe Room</h3>
                        <p>Spacious deluxe room with a king-size bed and city view.</p>
                        <div class="price">$150 / night</div>
                        <a href="${pageContext.request.contextPath}/room?id=2" class="btn btn-primary">View Details</a>
                    </div>
                </div>
                <div class="room-card">
                    <img src="${pageContext.request.contextPath}/assets/images/suite_room.jpg" alt="Suite Room">
                    <div class="room-card-content">
                        <h3>Suite Room</h3>
                        <p>Luxury suite with separate living area and panoramic views.</p>
                        <div class="price">$250 / night</div>
                        <a href="${pageContext.request.contextPath}/room?id=3" class="btn btn-primary">View Details</a>
                    </div>
                </div>
                <div class="room-card">
                    <img src="${pageContext.request.contextPath}/assets/images/executive_room.jpg" alt="Executive Room">
                    <div class="room-card-content">
                        <h3>Executive Room</h3>
                        <p>Executive suite with premium amenities and butler service.</p>
                        <div class="price">$300 / night</div>
                        <a href="${pageContext.request.contextPath}/room?id=4" class="btn btn-primary">View Details</a>
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
