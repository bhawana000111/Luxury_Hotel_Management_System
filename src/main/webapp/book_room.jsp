<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Book Room</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .booking-container {
            display: flex;
            flex-wrap: wrap;
        }
        
        .booking-details {
            width: 60%;
            padding-right: 20px;
        }
        
        .booking-summary {
            width: 40%;
            padding-left: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            padding: 20px;
        }
        
        .room-image img {
            width: 100%;
            height: auto;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .room-info h3 {
            margin-bottom: 10px;
        }
        
        .room-info .price {
            font-size: 20px;
            font-weight: bold;
            color: var(--primary-color);
            margin-bottom: 15px;
        }
        
        .booking-summary-title {
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #ddd;
        }
        
        .booking-summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .booking-summary-total {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
            padding-top: 10px;
            border-top: 1px solid #ddd;
            font-weight: bold;
            font-size: 18px;
        }
        
        @media (max-width: 768px) {
            .booking-details, .booking-summary {
                width: 100%;
                padding: 0;
            }
            
            .booking-details {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Booking Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>Book a Room</h2>
                <p>Complete your reservation</p>
            </div>
            
            <div class="booking-container">
                <div class="booking-details">
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
                        <h3>${room.type} Room</h3>
                        <div class="price">$${room.price} / night</div>
                        <p>${room.description}</p>
                    </div>
                    
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
                            <label for="specialRequests">Special Requests (Optional)</label>
                            <textarea id="specialRequests" name="specialRequests" class="form-control" rows="3"></textarea>
                        </div>
                        <div class="form-group">
                            <button type="submit" class="btn btn-primary">Confirm Booking</button>
                            <a href="${pageContext.request.contextPath}/room?id=${room.id}" class="btn btn-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
                
                <div class="booking-summary">
                    <h3 class="booking-summary-title">Booking Summary</h3>
                    <div class="booking-summary-item">
                        <span>Room Type:</span>
                        <span>${room.type} Room</span>
                    </div>
                    <div class="booking-summary-item">
                        <span>Price per Night:</span>
                        <span>$${room.price}</span>
                    </div>
                    <div class="booking-summary-item">
                        <span>Check-in Date:</span>
                        <span id="summaryCheckIn">-</span>
                    </div>
                    <div class="booking-summary-item">
                        <span>Check-out Date:</span>
                        <span id="summaryCheckOut">-</span>
                    </div>
                    <div class="booking-summary-item">
                        <span>Number of Nights:</span>
                        <span id="summaryNights">-</span>
                    </div>
                    <div class="booking-summary-total">
                        <span>Total:</span>
                        <span id="summaryTotal">-</span>
                    </div>
                    
                    <div class="payment-info" style="margin-top: 30px;">
                        <h4>Payment Information</h4>
                        <p>Payment will be processed at check-in. We accept all major credit cards.</p>
                        <p>Cancellation is free up to 24 hours before check-in.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        // Update booking summary when dates change
        document.addEventListener('DOMContentLoaded', function() {
            const dateFrom = document.getElementById('dateFrom');
            const dateTo = document.getElementById('dateTo');
            const summaryCheckIn = document.getElementById('summaryCheckIn');
            const summaryCheckOut = document.getElementById('summaryCheckOut');
            const summaryNights = document.getElementById('summaryNights');
            const summaryTotal = document.getElementById('summaryTotal');
            const roomPrice = ${room.price};
            
            // Set min date to today for check-in date
            const today = new Date().toISOString().split('T')[0];
            dateFrom.setAttribute('min', today);
            
            function updateSummary() {
                if (dateFrom.value && dateTo.value) {
                    // Format dates for display
                    const checkInDate = new Date(dateFrom.value);
                    const checkOutDate = new Date(dateTo.value);
                    
                    summaryCheckIn.textContent = checkInDate.toLocaleDateString();
                    summaryCheckOut.textContent = checkOutDate.toLocaleDateString();
                    
                    // Calculate number of nights
                    const timeDiff = checkOutDate - checkInDate;
                    const nights = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
                    
                    if (nights > 0) {
                        summaryNights.textContent = nights;
                        summaryTotal.textContent = '$' + (roomPrice * nights).toFixed(2);
                    } else {
                        summaryNights.textContent = '-';
                        summaryTotal.textContent = '-';
                    }
                } else {
                    summaryCheckIn.textContent = '-';
                    summaryCheckOut.textContent = '-';
                    summaryNights.textContent = '-';
                    summaryTotal.textContent = '-';
                }
            }
            
            dateFrom.addEventListener('change', function() {
                // Set min date for check-out to be the check-in date
                dateTo.setAttribute('min', this.value);
                
                // If check-out date is before check-in date, update it
                if (dateTo.value && dateTo.value < this.value) {
                    dateTo.value = this.value;
                }
                
                updateSummary();
            });
            
            dateTo.addEventListener('change', updateSummary);
        });
    </script>
</body>
</html>
