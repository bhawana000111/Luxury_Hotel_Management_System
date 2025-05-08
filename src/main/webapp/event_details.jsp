<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - ${event.eventName}</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .event-details {
            display: flex;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }
        
        .event-image {
            width: 50%;
            padding-right: 20px;
        }
        
        .event-image img {
            width: 100%;
            height: auto;
            border-radius: 5px;
        }
        
        .event-info {
            width: 50%;
            padding-left: 20px;
        }
        
        .event-info h2 {
            margin-bottom: 15px;
        }
        
        .event-meta {
            margin-bottom: 20px;
        }
        
        .event-meta-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .event-meta-item i {
            margin-right: 10px;
            color: var(--primary-color);
            width: 20px;
            text-align: center;
        }
        
        .event-description {
            margin-bottom: 30px;
        }
        
        .event-cta {
            margin-top: 30px;
        }
        
        @media (max-width: 768px) {
            .event-image, .event-info {
                width: 100%;
                padding: 0;
            }
            
            .event-image {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Event Details Section -->
    <section class="section">
        <div class="container">
            <div class="event-details">
                <div class="event-image">
                    <c:choose>
                        <c:when test="${not empty event.imagePath}">
                            <img src="${pageContext.request.contextPath}/${event.imagePath}" alt="${event.eventName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/images/event_default.jpg" alt="${event.eventName}">
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="event-info">
                    <h2>${event.eventName}</h2>
                    <div class="event-meta">
                        <div class="event-meta-item">
                            <i class="far fa-calendar-alt"></i>
                            <span>${event.date}</span>
                        </div>
                        <div class="event-meta-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span>${event.location}</span>
                        </div>
                        <div class="event-meta-item">
                            <i class="far fa-clock"></i>
                            <span>7:00 PM - 10:00 PM</span>
                        </div>
                    </div>
                    <div class="event-description">
                        <p>${event.description}</p>
                    </div>
                    <div class="event-cta">
                        <a href="#" class="btn btn-primary">Register for Event</a>
                        <a href="${pageContext.request.contextPath}/events" class="btn btn-secondary">Back to Events</a>
                    </div>
                </div>
            </div>
            
            <div class="event-details-content">
                <h3>Event Details</h3>
                <p>Join us for an unforgettable evening at Luxury Hotel. This event promises to be a highlight of the season, featuring:</p>
                <ul>
                    <li>Gourmet dining experience prepared by our Executive Chef</li>
                    <li>Live entertainment and music</li>
                    <li>Networking opportunities with distinguished guests</li>
                    <li>Complimentary welcome drinks</li>
                </ul>
                <p>Dress code: Formal</p>
                <p>For more information or to make special arrangements, please contact our events team at events@luxuryhotel.com or call +1 234 567 8900.</p>
            </div>
        </div>
    </section>
    
    <!-- Similar Events Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Other Upcoming Events</h2>
                <p>You might also be interested in these events</p>
            </div>
            <div class="event-cards">
                <!-- This would be populated with similar events from the database -->
                <div class="event-card">
                    <img src="${pageContext.request.contextPath}/assets/images/wine_tasting.jpg" alt="Wine Tasting Evening">
                    <div class="event-card-content">
                        <h3>Wine Tasting Evening</h3>
                        <div class="date"><i class="far fa-calendar-alt"></i> July 20, 2023</div>
                        <div class="location"><i class="fas fa-map-marker-alt"></i> Wine Cellar</div>
                        <p>Sample premium wines from around the world paired with delicious appetizers prepared by our chef.</p>
                        <a href="${pageContext.request.contextPath}/event?id=3" class="btn btn-primary">View Details</a>
                    </div>
                </div>
                <div class="event-card">
                    <img src="${pageContext.request.contextPath}/assets/images/wedding_showcase.jpg" alt="Wedding Showcase">
                    <div class="event-card-content">
                        <h3>Wedding Showcase</h3>
                        <div class="date"><i class="far fa-calendar-alt"></i> June 15, 2023</div>
                        <div class="location"><i class="fas fa-map-marker-alt"></i> Garden Terrace</div>
                        <p>Explore our wedding venues and packages at this special event designed for couples planning their big day.</p>
                        <a href="${pageContext.request.contextPath}/event?id=2" class="btn btn-primary">View Details</a>
                    </div>
                </div>
                <div class="event-card">
                    <img src="${pageContext.request.contextPath}/assets/images/jazz_night.jpg" alt="Jazz Night">
                    <div class="event-card-content">
                        <h3>Jazz Night</h3>
                        <div class="date"><i class="far fa-calendar-alt"></i> August 5, 2023</div>
                        <div class="location"><i class="fas fa-map-marker-alt"></i> Lounge Bar</div>
                        <p>Enjoy an evening of smooth jazz music with our resident jazz band while sipping on signature cocktails.</p>
                        <a href="${pageContext.request.contextPath}/event?id=4" class="btn btn-primary">View Details</a>
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
