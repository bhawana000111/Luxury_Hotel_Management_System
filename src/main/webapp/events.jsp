<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Events</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Page Header -->
    <section class="page-header" style="background-image: url('https://wallpaperaccess.com/full/2690866.jpg');">
        <div class="container">
            <h1>Events at Luxury Hotel</h1>
            <p>Creating memorable experiences for every occasion</p>
        </div>
    </section>

    <!-- Event Types Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>We Host a Variety of Events</h2>
                <p>From intimate gatherings to grand celebrations, we have the perfect space for your event</p>
            </div>

            <div class="event-types">
                <div class="event-type">
                    <div class="event-type-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/wedding-icon.png" alt="Weddings">
                    </div>
                    <h3>Weddings</h3>
                    <p>Create the wedding of your dreams in our elegant venues with customized service and exquisite catering.</p>
                </div>

                <div class="event-type">
                    <div class="event-type-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/corporate-icon.png" alt="Corporate Events">
                    </div>
                    <h3>Corporate Events</h3>
                    <p>Host successful meetings, conferences, and team building events with our state-of-the-art facilities.</p>
                </div>

                <div class="event-type">
                    <div class="event-type-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/social-icon.png" alt="Social Gatherings">
                    </div>
                    <h3>Social Gatherings</h3>
                    <p>Celebrate birthdays, anniversaries, and special occasions with our customizable event packages.</p>
                </div>

                <div class="event-type">
                    <div class="event-type-icon">
                        <img src="${pageContext.request.contextPath}/assets/images/icons/gala-icon.png" alt="Galas & Fundraisers">
                    </div>
                    <h3>Galas & Fundraisers</h3>
                    <p>Make a statement with our sophisticated venues perfect for charity events and formal galas.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Events Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>Upcoming Events</h2>
                <p>Join us for these special occasions</p>
            </div>

            <!-- Event Location Filter -->
            <div class="event-filter">
                <form action="${pageContext.request.contextPath}/events" method="get">
                    <div class="filter-group">
                        <label for="location">Location:</label>
                        <select id="location" name="location" class="form-control" onchange="this.form.submit()">
                            <option value="">All Locations</option>
                            <option value="Grand Ballroom" ${selectedLocation eq 'Grand Ballroom' ? 'selected' : ''}>Grand Ballroom</option>
                            <option value="Garden Terrace" ${selectedLocation eq 'Garden Terrace' ? 'selected' : ''}>Garden Terrace</option>
                            <option value="Wine Cellar" ${selectedLocation eq 'Wine Cellar' ? 'selected' : ''}>Wine Cellar</option>
                            <option value="Conference Room" ${selectedLocation eq 'Conference Room' ? 'selected' : ''}>Conference Room</option>
                        </select>
                    </div>
                </form>
            </div>

            <!-- Event Cards -->
            <div class="event-cards">
                <c:forEach var="event" items="${events}">
                    <div class="event-card">
                        <c:choose>
                            <c:when test="${not empty event.imagePath}">
                                <img src="${pageContext.request.contextPath}/${event.imagePath}" alt="${event.eventName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/event_default.jpg" alt="${event.eventName}">
                            </c:otherwise>
                        </c:choose>
                        <div class="event-card-content">
                            <h3>${event.eventName}</h3>
                            <div class="date"><i class="far fa-calendar-alt"></i> ${event.date}</div>
                            <div class="location"><i class="fas fa-map-marker-alt"></i> ${event.location}</div>
                            <p>${event.description}</p>
                            <a href="${pageContext.request.contextPath}/event?id=${event.id}" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback if no events are loaded -->
                <c:if test="${empty events}">
                    <div class="no-results">
                        <h3>No events available</h3>
                        <p>Please try a different location or check back later.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
