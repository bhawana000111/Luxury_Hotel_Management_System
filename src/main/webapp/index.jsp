<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Welcome</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/responsive.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/room-features.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Welcome to Luxury Hotel</h1>
            <p>Experience luxury and comfort like never before</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">View Rooms</a>
                <a href="${pageContext.request.contextPath}/contact" class="btn btn-outline">Contact Us</a>
            </div>
        </div>

        <!-- Room Search Form -->
        <div class="search-container">
            <div class="search-form">
                <h3>Find Your Perfect Room</h3>
                <form action="${pageContext.request.contextPath}/rooms" method="get" class="room-search-form">
                    <div class="search-row">
                        <div class="search-group">
                            <label for="check-in">Check-in Date</label>
                            <input type="date" id="check-in" name="checkIn" class="form-control" required>
                        </div>
                        <div class="search-group">
                            <label for="check-out">Check-out Date</label>
                            <input type="date" id="check-out" name="checkOut" class="form-control" required>
                        </div>
                        <div class="search-group">
                            <label for="room-type">Room Type</label>
                            <select id="room-type" name="roomType" class="form-control">
                                <option value="">All Types</option>
                                <option value="standard">Standard</option>
                                <option value="deluxe">Deluxe</option>
                                <option value="suite">Suite</option>
                                <option value="executive">Executive</option>
                                <option value="presidential">Presidential</option>
                            </select>
                        </div>
                        <div class="search-group">
                            <label for="price-range">Price Range</label>
                            <select id="price-range" name="priceRange" class="form-control">
                                <option value="">All Prices</option>
                                <option value="0-100">$0 - $100</option>
                                <option value="100-200">$100 - $200</option>
                                <option value="200-300">$200 - $300</option>
                                <option value="300+">$300+</option>
                            </select>
                        </div>
                        <div class="search-group">
                            <label for="guests">Guests</label>
                            <select id="guests" name="guests" class="form-control">
                                <option value="1">1 Person</option>
                                <option value="2" selected>2 People</option>
                                <option value="3">3 People</option>
                                <option value="4">4 People</option>
                                <option value="5+">5+ People</option>
                            </select>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary search-btn">Search Rooms</button>
                </form>
            </div>
        </div>
    </section>

    <!-- About Section -->
    <section class="section about-section">
        <div class="container">
            <div class="section-title">
                <h2>About Our Hotel</h2>
                <p>Discover the perfect blend of luxury, comfort, and exceptional service</p>
            </div>
            <div class="about-content">
                <div class="about-grid">
                    <div class="about-text">
                        <h3>Experience Luxury Like Never Before</h3>
                        <p>Welcome to Luxury Hotel, where elegance meets comfort. Our hotel is designed to provide you with an unforgettable experience, combining luxurious accommodations, world-class amenities, and exceptional service.</p>
                        <p>Located in the heart of the city, we offer easy access to major attractions, shopping centers, and business districts. Whether you're traveling for business or pleasure, our dedicated staff is committed to ensuring your stay is nothing short of perfect.</p>
                        <div class="about-features">
                            <div class="about-feature">
                                <i class="fas fa-concierge-bell"></i>
                                <h4>24/7 Service</h4>
                                <p>Our staff is available around the clock to assist you with any requests.</p>
                            </div>
                            <div class="about-feature">
                                <i class="fas fa-map-marker-alt"></i>
                                <h4>Prime Location</h4>
                                <p>Situated in the heart of the city with easy access to attractions.</p>
                            </div>
                            <div class="about-feature">
                                <i class="fas fa-star"></i>
                                <h4>Luxury Experience</h4>
                                <p>Every detail is designed to provide a luxurious experience.</p>
                            </div>
                        </div>
                        <a href="${pageContext.request.contextPath}/about.jsp" class="btn btn-primary about-btn">Learn More</a>
                    </div>
                    <div class="about-image">
                        <img src="${pageContext.request.contextPath}/assets/images/about-hotel.jpg" alt="Luxury Hotel Interior">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Rooms Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Featured Rooms</h2>
                <p>Experience luxury in our carefully designed rooms</p>
            </div>
            <div class="room-cards">
                <c:forEach var="room" items="${featuredRooms}" varStatus="loop">
                    <div class="room-card">
                        <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="${room.type} Room">
                        <div class="room-card-content">
                            <h3>${room.type} Room</h3>
                            <p>${room.description}</p>
                            <div class="price">$${room.price} / night</div>
                            <a href="${pageContext.request.contextPath}/room?id=${room.id}" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback if no rooms are loaded -->
                <c:if test="${empty featuredRooms}">
                    <div class="room-card">
                        <div class="room-card-image">
                            <img src="${pageContext.request.contextPath}/assets/images/room1.jpg" alt="Standard Room">
                        </div>
                        <div class="room-card-content">
                            <h3>Standard Room</h3>
                            <p>Comfortable standard room with a queen-size bed, perfect for solo travelers or couples.</p>
                            <div class="price">$100 <span>/ night</span></div>
                            <div class="room-card-features">
                                <div class="room-card-feature"><i class="fas fa-wifi"></i> Free WiFi</div>
                                <div class="room-card-feature"><i class="fas fa-tv"></i> Smart TV</div>
                                <div class="room-card-feature"><i class="fas fa-snowflake"></i> AC</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                    <div class="room-card">
                        <div class="room-card-image">
                            <img src="${pageContext.request.contextPath}/assets/images/room2.jpg" alt="Deluxe Room">
                        </div>
                        <div class="room-card-content">
                            <h3>Deluxe Room</h3>
                            <p>Spacious deluxe room with a king-size bed and stunning city view, ideal for a luxurious stay.</p>
                            <div class="price">$150 <span>/ night</span></div>
                            <div class="room-card-features">
                                <div class="room-card-feature"><i class="fas fa-wifi"></i> Free WiFi</div>
                                <div class="room-card-feature"><i class="fas fa-tv"></i> Smart TV</div>
                                <div class="room-card-feature"><i class="fas fa-bath"></i> Jacuzzi</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                    <div class="room-card">
                        <div class="room-card-image">
                            <img src="${pageContext.request.contextPath}/assets/images/room3.jpg" alt="Suite Room">
                        </div>
                        <div class="room-card-content">
                            <h3>Suite Room</h3>
                            <p>Luxury suite with separate living area and panoramic views, offering the ultimate comfort.</p>
                            <div class="price">$250 <span>/ night</span></div>
                            <div class="room-card-features">
                                <div class="room-card-feature"><i class="fas fa-wifi"></i> Free WiFi</div>
                                <div class="room-card-feature"><i class="fas fa-utensils"></i> Mini Bar</div>
                                <div class="room-card-feature"><i class="fas fa-couch"></i> Lounge</div>
                            </div>
                            <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                </c:if>
            </div>
            <div class="text-center" style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">View All Rooms</a>
            </div>
        </div>
    </section>

    <!-- Hotel Features Section -->
    <section class="section services-section">
        <div class="container">
            <div class="section-title">
                <h2>Hotel Features</h2>
                <p>Discover our premium amenities and services</p>
                <a href="${pageContext.request.contextPath}/blog" class="btn btn-secondary">Read Our Blog</a>
            </div>
            <div class="services-content">
                <div class="services-grid">
                    <div class="service-item">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/restaurant.jpg" alt="Fine Dining Restaurant">
                        </div>
                        <div class="service-details">
                            <h3>Fine Dining Restaurant</h3>
                            <p>Enjoy exquisite meals prepared by our world-class chefs using the finest ingredients. Our restaurant offers a sophisticated atmosphere with panoramic views.</p>
                            <a href="${pageContext.request.contextPath}/blog" class="service-link">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                    <div class="service-item">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/spa.jpg" alt="Luxury Spa & Wellness">
                        </div>
                        <div class="service-details">
                            <h3>Luxury Spa & Wellness</h3>
                            <p>Relax and rejuvenate with our premium spa services. Our skilled therapists offer a range of treatments designed to refresh your body and mind.</p>
                            <a href="${pageContext.request.contextPath}/blog" class="service-link">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                    <div class="service-item">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/pool.jpg" alt="Infinity Swimming Pool">
                        </div>
                        <div class="service-details">
                            <h3>Infinity Swimming Pool</h3>
                            <p>Take a refreshing dip in our luxurious infinity swimming pool with stunning views. Perfect for relaxation or a morning workout.</p>
                            <a href="${pageContext.request.contextPath}/blog" class="service-link">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                    <div class="service-item">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/fitness.jpg" alt="State-of-the-Art Fitness Center">
                        </div>
                        <div class="service-details">
                            <h3>State-of-the-Art Fitness Center</h3>
                            <p>Stay fit during your stay with our modern fitness center featuring the latest equipment and personal trainers available upon request.</p>
                            <a href="${pageContext.request.contextPath}/blog" class="service-link">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Upcoming Events Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Upcoming Events</h2>
                <p>Join us for exciting events and experiences</p>
            </div>
            <div class="event-cards">
                <c:forEach var="event" items="${upcomingEvents}" varStatus="loop">
                    <div class="event-card">
                        <img src="${pageContext.request.contextPath}/${event.imagePath}" alt="${event.eventName}">
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
                <c:if test="${empty upcomingEvents}">
                    <div class="event-card">
                        <img src="${pageContext.request.contextPath}/assets/images/new_year_gala.jpg" alt="New Year Gala">
                        <div class="event-card-content">
                            <h3>New Year Gala</h3>
                            <div class="date"><i class="far fa-calendar-alt"></i> December 31, 2023</div>
                            <div class="location"><i class="fas fa-map-marker-alt"></i> Grand Ballroom</div>
                            <p>Join us for an unforgettable New Year celebration with live music, gourmet dinner, and fireworks.</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                    <div class="event-card">
                        <img src="${pageContext.request.contextPath}/assets/images/wedding_showcase.jpg" alt="Wedding Showcase">
                        <div class="event-card-content">
                            <h3>Wedding Showcase</h3>
                            <div class="date"><i class="far fa-calendar-alt"></i> June 15, 2023</div>
                            <div class="location"><i class="fas fa-map-marker-alt"></i> Garden Terrace</div>
                            <p>Explore our wedding venues and packages at this special event designed for couples planning their big day.</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                    <div class="event-card">
                        <img src="${pageContext.request.contextPath}/assets/images/wine_tasting.jpg" alt="Wine Tasting Evening">
                        <div class="event-card-content">
                            <h3>Wine Tasting Evening</h3>
                            <div class="date"><i class="far fa-calendar-alt"></i> July 20, 2023</div>
                            <div class="location"><i class="fas fa-map-marker-alt"></i> Wine Cellar</div>
                            <p>Sample premium wines from around the world paired with delicious appetizers prepared by our chef.</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary">View Details</a>
                        </div>
                    </div>
                </c:if>
            </div>
            <div class="text-center" style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/events" class="btn btn-secondary">View All Events</a>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="section testimonials">
        <div class="container">
            <div class="section-title">
                <h2>What Our Guests Say</h2>
                <p>Read testimonials from our satisfied guests</p>
            </div>
            <div class="testimonial-cards">
                <c:forEach var="feedback" items="${testimonials}" varStatus="loop">
                    <div class="testimonial-card">
                        <p>${feedback.message}</p>
                        <div class="author">
                            <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="${feedback.userName}">
                            <div class="author-info">
                                <h4>${feedback.userName}</h4>
                                <div class="rating">
                                    <c:forEach begin="1" end="${feedback.rating}">
                                        <i class="fas fa-star"></i>
                                    </c:forEach>
                                    <c:forEach begin="${feedback.rating + 1}" end="5">
                                        <i class="far fa-star"></i>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback if no testimonials are loaded -->
                <c:if test="${empty testimonials}">
                    <div class="testimonial-card">
                        <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                        <p>"Our stay at Luxury Hotel was absolutely amazing. The staff was friendly and attentive, the room was clean and comfortable, and the amenities were top-notch. We will definitely be coming back!"</p>
                        <div class="author">
                            <img src="${pageContext.request.contextPath}/assets/images/user1.jpg" alt="John Doe">
                            <div class="author-info">
                                <h4>John Doe</h4>
                                <p class="author-location">New York, USA</p>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-card">
                        <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                        <p>"The service at Luxury Hotel exceeded all our expectations. The staff went above and beyond to make our anniversary special. The room was beautiful and the view was breathtaking."</p>
                        <div class="author">
                            <img src="${pageContext.request.contextPath}/assets/images/user2.jpg" alt="Jane Smith">
                            <div class="author-info">
                                <h4>Jane Smith</h4>
                                <p class="author-location">London, UK</p>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="testimonial-card">
                        <div class="testimonial-quote"><i class="fas fa-quote-left"></i></div>
                        <p>"I've stayed at many luxury hotels around the world, but Luxury Hotel truly stands out. The attention to detail, the quality of service, and the overall experience were exceptional."</p>
                        <div class="author">
                            <img src="${pageContext.request.contextPath}/assets/images/user3.jpg" alt="Robert Johnson">
                            <div class="author-info">
                                <h4>Robert Johnson</h4>
                                <p class="author-location">Sydney, Australia</p>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="far fa-star"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
            <div class="text-center" style="margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/feedback" class="btn btn-secondary">Leave Feedback</a>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <!-- JavaScript is included in the footer -->
</body>
</html>
