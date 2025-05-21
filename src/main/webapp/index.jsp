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
    <style>
        /* Enhanced Animations and Transitions */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideIn {
            from { transform: translateX(-30px); opacity: 0; }
            to { transform: translateX(0); opacity: 1; }
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }

        .animate-fade-in {
            animation: fadeIn 0.8s ease forwards;
        }

        .animate-slide-in {
            animation: slideIn 0.8s ease forwards;
        }

        /* Enhanced Room Cards */
        .room-cards {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
            padding: 0 10px;
        }

        .room-card {
            transition: all 0.4s ease;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            position: relative;
            height: 100%;
            display: flex;
            flex-direction: column;
        }

        .room-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.2);
        }

        .room-card img {
            transition: all 0.5s ease;
            width: 100%;
            height: 300px;
            object-fit: cover;
        }

        .room-card:hover img {
            transform: scale(1.1);
        }

        .room-card-content {
            padding: 20px;
            background: #fff;
            position: relative;
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 250px;
            overflow: hidden;
        }

        .room-card-content > a {
            margin-top: auto;
        }

        .room-card h3 {
            margin-top: 0;
            color: #333;
            font-size: 22px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .room-card p {
            color: #666;
            margin-bottom: 15px;
            line-height: 1.5;
            font-size: 15px;
            min-height: 70px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }

        .room-card .price {
            font-size: 20px;
            font-weight: 700;
            color: #5a3921;
            margin-bottom: 15px;
        }

        .room-card .btn {
            margin-top: 10px;
            transition: all 0.3s ease;
        }

        .room-card .btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 10px rgba(0,0,0,0.1);
        }

        /* Enhanced Blog Cards in Hotel Features */
        .blog-feature {
            display: flex;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            transition: all 0.4s ease;
        }

        .blog-feature:hover {
            transform: translateY(-8px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.1);
        }

        .blog-feature-image {
            flex: 0 0 40%;
            overflow: hidden;
        }

        .blog-feature-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: all 0.5s ease;
        }

        .blog-feature:hover .blog-feature-image img {
            transform: scale(1.1);
        }

        .blog-feature-content {
            flex: 0 0 60%;
            padding: 25px;
        }

        .blog-feature-content h3 {
            margin-top: 0;
            font-size: 20px;
            margin-bottom: 10px;
            color: #333;
        }

        .blog-meta {
            display: flex;
            margin-bottom: 15px;
            font-size: 14px;
            color: #777;
        }

        .blog-meta span {
            margin-right: 15px;
            display: flex;
            align-items: center;
        }

        .blog-meta i {
            margin-right: 5px;
            color: #5a3921;
        }

        .blog-feature-content p {
            margin-bottom: 15px;
            color: #666;
            line-height: 1.6;
        }

        .blog-feature-content .btn {
            padding: 8px 15px;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .blog-feature-content .btn:hover {
            transform: translateY(-3px);
        }

        /* Enhanced Section Titles */
        .section-title {
            text-align: center;
            margin-bottom: 50px;
            position: relative;
        }

        .section-title h2 {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            margin-bottom: 15px;
            position: relative;
            display: inline-block;
        }

        .section-title h2:after {
            content: '';
            position: absolute;
            width: 50px;
            height: 3px;
            background: #5a3921;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            transition: width 0.3s ease;
        }

        .section:hover .section-title h2:after {
            width: 100px;
        }

        .section-title p {
            color: #666;
            font-size: 18px;
            max-width: 700px;
            margin: 0 auto;
            margin-top: 20px;
        }
    </style>
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
                        <img src="${pageContext.request.contextPath}/assets/images/about%20home%20background.jpg" alt="Luxury Hotel Interior">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Featured Rooms Section -->
    <section class="section" style="background-color: #f8f8f8; padding: 60px 0;">
        <div class="container">
            <div class="section-title animate-fade-in" style="text-align: center; margin-bottom: 40px;">
                <h2 style="font-size: 32px; color: #333; margin-bottom: 10px;">Featured Rooms</h2>
                <p style="font-size: 16px; color: #666;">Experience luxury in our carefully designed rooms</p>
            </div>

            <div class="room-cards" style="display: flex; justify-content: space-between; flex-wrap: nowrap; overflow-x: auto; padding-bottom: 15px;">
                <!-- Show only first 3 rooms -->
                <c:forEach var="room" items="${featuredRooms}" varStatus="loop" begin="0" end="2">
                    <c:set var="marginRight" value="${loop.last ? '0' : '2%'}" />
                    <div class="room-card animate-fade-in" style="animation-delay: ${loop.index * 0.2}s; flex: 0 0 32%; margin-right: ${marginRight}; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/${room.imagePath}" alt="${room.type} Room" style="width: 100%; height: 250px; object-fit: cover;">
                            <div style="position: absolute; top: 15px; right: 15px; background-color: #5a3921; color: white; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold;">
                                <i class="fas fa-star"></i> Featured
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">${room.type} Room</h3>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">${room.description}</p>
                            <div style="display: flex; gap: 8px; margin-bottom: 15px;">
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-wifi" style="color: #5a3921; margin-right: 5px;"></i> WiFi</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-tv" style="color: #5a3921; margin-right: 5px;"></i> TV</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-snowflake" style="color: #5a3921; margin-right: 5px;"></i> AC</div>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div style="font-size: 20px; font-weight: 700; color: #5a3921;">$${room.price} <span style="font-size: 14px; font-weight: normal; color: #888;">/ night</span></div>
                                <a href="${pageContext.request.contextPath}/room?id=${room.id}" class="btn btn-primary" style="padding: 8px 15px; font-size: 14px;">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback if no rooms are loaded -->
                <c:if test="${empty featuredRooms}">
                    <!-- Standard Room -->
                    <div class="room-card animate-fade-in" style="animation-delay: 0.1s; width: 32%; margin-bottom: 20px; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/assets/images/room.webp" alt="Standard Room" style="width: 100%; height: 250px; object-fit: cover;">
                            <div style="position: absolute; top: 15px; right: 15px; background-color: #5a3921; color: white; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold;">
                                <i class="fas fa-star"></i> Featured
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">Standard Room</h3>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">Comfortable and cozy room with all essential amenities for a pleasant stay. Perfect for business travelers or short stays.</p>
                            <div style="display: flex; gap: 8px; margin-bottom: 15px;">
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-wifi" style="color: #5a3921; margin-right: 5px;"></i> WiFi</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-tv" style="color: #5a3921; margin-right: 5px;"></i> TV</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-snowflake" style="color: #5a3921; margin-right: 5px;"></i> AC</div>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div style="font-size: 20px; font-weight: 700; color: #5a3921;">$99 <span style="font-size: 14px; font-weight: normal; color: #888;">/ night</span></div>
                                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary" style="padding: 8px 15px; font-size: 14px;">View Details</a>
                            </div>
                        </div>
                    </div>

                    <!-- Deluxe Room -->
                    <div class="room-card animate-fade-in" style="animation-delay: 0.2s; width: 32%; margin-bottom: 20px; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/assets/images/room1.webp" alt="Deluxe Room" style="width: 100%; height: 250px; object-fit: cover;">
                            <div style="position: absolute; top: 15px; right: 15px; background-color: #5a3921; color: white; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold;">
                                <i class="fas fa-star"></i> Featured
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">Deluxe Room</h3>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">Spacious room with premium amenities and elegant decor. Enjoy the comfort of a king-size bed and modern bathroom.</p>
                            <div style="display: flex; gap: 8px; margin-bottom: 15px;">
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-wifi" style="color: #5a3921; margin-right: 5px;"></i> WiFi</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-tv" style="color: #5a3921; margin-right: 5px;"></i> TV</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-bath" style="color: #5a3921; margin-right: 5px;"></i> Jacuzzi</div>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div style="font-size: 20px; font-weight: 700; color: #5a3921;">$149 <span style="font-size: 14px; font-weight: normal; color: #888;">/ night</span></div>
                                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary" style="padding: 8px 15px; font-size: 14px;">View Details</a>
                            </div>
                        </div>
                    </div>

                    <!-- Suite Room -->
                    <div class="room-card animate-fade-in" style="animation-delay: 0.3s; width: 32%; margin-bottom: 20px; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/assets/images/room 4.webp" alt="Suite Room" style="width: 100%; height: 250px; object-fit: cover;">
                            <div style="position: absolute; top: 15px; right: 15px; background-color: #5a3921; color: white; padding: 5px 10px; border-radius: 4px; font-size: 12px; font-weight: bold;">
                                <i class="fas fa-star"></i> Featured
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">Suite Room</h3>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">Luxurious suite with separate living area and bedroom. Enjoy panoramic views and exclusive amenities for a memorable stay.</p>
                            <div style="display: flex; gap: 8px; margin-bottom: 15px;">
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-wifi" style="color: #5a3921; margin-right: 5px;"></i> WiFi</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-utensils" style="color: #5a3921; margin-right: 5px;"></i> Mini Bar</div>
                                <div style="background: #f5f5f5; padding: 5px 10px; border-radius: 4px; font-size: 12px;"><i class="fas fa-couch" style="color: #5a3921; margin-right: 5px;"></i> Lounge</div>
                            </div>
                            <div style="display: flex; justify-content: space-between; align-items: center;">
                                <div style="font-size: 20px; font-weight: 700; color: #5a3921;">$249 <span style="font-size: 14px; font-weight: normal; color: #888;">/ night</span></div>
                                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary" style="padding: 8px 15px; font-size: 14px;">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- View All Rooms Button -->
            <div style="text-align: center; margin-top: 30px;">
                <a href="${pageContext.request.contextPath}/rooms" class="btn btn-secondary">View All Rooms</a>
            </div>
        </div>
    </section>

    <!-- Hotel Features & Blog Section -->
    <section class="section services-section">
        <div class="container">
            <div class="section-title animate-fade-in">
                <h2>Hotel Features & Blog</h2>
                <p>Discover our premium amenities and latest updates</p>
            </div>

            <!-- Services Grid -->
            <div class="services-content">
                <div class="services-grid">
                    <div class="service-item animate-fade-in" style="animation-delay: 0.1s;">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/resturant.webp" alt="Fine Dining Restaurant">
                            <div class="service-overlay" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.3); display: flex; align-items: center; justify-content: center; opacity: 0; transition: all 0.3s ease;">
                                <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-light" style="background: rgba(255,255,255,0.9); color: #333;">View Details</a>
                            </div>
                        </div>
                        <div class="service-details">
                            <h3>Fine Dining Restaurant</h3>
                            <p>Enjoy exquisite meals prepared by our world-class chefs using the finest ingredients. Our restaurant offers a sophisticated atmosphere with panoramic views.</p>
                            <a href="${pageContext.request.contextPath}/blog.jsp" class="service-link">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                    <div class="service-item animate-fade-in" style="animation-delay: 0.2s;">
                        <div class="service-image">
                            <img src="${pageContext.request.contextPath}/assets/images/spa.webp" alt="Luxury Spa & Wellness">
                            <div class="service-overlay" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.3); display: flex; align-items: center; justify-content: center; opacity: 0; transition: all 0.3s ease;">
                                <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-light" style="background: rgba(255,255,255,0.9); color: #333;">View Details</a>
                            </div>
                        </div>
                        <div class="service-details">
                            <h3>Luxury Spa & Wellness</h3>
                            <p>Relax and rejuvenate with our premium spa services. Our skilled therapists offer a range of treatments designed to refresh your body and mind.</p>
                            <a href="${pageContext.request.contextPath}/blog.jsp" class="service-link">Read More <i class="fas fa-arrow-right"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Blog Features -->
            <div class="section-subtitle animate-fade-in" style="text-align: center; margin: 50px 0 30px;">
                <h3 style="font-size: 28px; color: #333; margin-bottom: 15px;">Latest From Our Blog</h3>
                <p style="color: #666; max-width: 700px; margin: 0 auto;">Stay updated with the latest news and events at our hotel</p>
            </div>

            <div class="blog-features">
                <!-- Blog Feature 1 -->
                <div class="blog-feature animate-fade-in" style="animation-delay: 0.3s;">
                    <div class="blog-feature-image">
                        <img src="${pageContext.request.contextPath}/assets/images/Chefs_intro.webp" alt="Meet Our Executive Chef">
                    </div>
                    <div class="blog-feature-content">
                        <h3>Meet Our Executive Chef</h3>
                        <div class="blog-meta">
                            <span><i class="fas fa-user"></i> Admin</span>
                            <span><i class="far fa-calendar-alt"></i> June 15, 2023</span>
                        </div>
                        <p>We are proud to introduce our new Executive Chef, Michael Brown, who brings 15 years of international culinary experience to our hotel. Chef Michael specializes in fusion cuisine that combines local flavors with international techniques.</p>
                        <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-primary">Read More</a>
                    </div>
                </div>

                <!-- Blog Feature 2 -->
                <div class="blog-feature animate-fade-in" style="animation-delay: 0.4s;">
                    <div class="blog-feature-image">
                        <img src="${pageContext.request.contextPath}/assets/images/spa_services.webp" alt="New Spa Services">
                    </div>
                    <div class="blog-feature-content">
                        <h3>New Spa Services</h3>
                        <div class="blog-meta">
                            <span><i class="fas fa-user"></i> Admin</span>
                            <span><i class="far fa-calendar-alt"></i> June 20, 2023</span>
                        </div>
                        <p>Discover our new range of spa services designed to provide the ultimate relaxation experience during your stay. Our new treatments include aromatherapy massages, hot stone therapy, and rejuvenating facials using premium organic products.</p>
                        <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-primary">Read More</a>
                    </div>
                </div>

                <!-- Blog Feature 3 -->
                <div class="blog-feature animate-fade-in" style="animation-delay: 0.5s;">
                    <div class="blog-feature-image">
                        <img src="${pageContext.request.contextPath}/assets/images/wine-2891894_1280.webp" alt="Wine Tasting Event">
                    </div>
                    <div class="blog-feature-content">
                        <h3>Wine Tasting Event</h3>
                        <div class="blog-meta">
                            <span><i class="fas fa-user"></i> Admin</span>
                            <span><i class="far fa-calendar-alt"></i> July 5, 2023</span>
                        </div>
                        <p>Join us for an exclusive wine tasting event featuring premium selections from renowned vineyards around the world. Our sommelier will guide you through a journey of flavors, paired with gourmet appetizers prepared by our culinary team.</p>
                        <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-primary">Read More</a>
                    </div>
                </div>

                <!-- Blog Feature 4 -->
                <div class="blog-feature animate-fade-in" style="animation-delay: 0.6s;">
                    <div class="blog-feature-image">
                        <img src="${pageContext.request.contextPath}/assets/images/pool.webp" alt="Pool Renovation Complete">
                    </div>
                    <div class="blog-feature-content">
                        <h3>Pool Renovation Complete</h3>
                        <div class="blog-meta">
                            <span><i class="fas fa-user"></i> Admin</span>
                            <span><i class="far fa-calendar-alt"></i> July 10, 2023</span>
                        </div>
                        <p>We're excited to announce the completion of our infinity pool renovation. The enhanced pool area now features a swim-up bar, heated sections, and expanded lounging areas with panoramic views of the city skyline.</p>
                        <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-primary">Read More</a>
                    </div>
                </div>

                <!-- Blog Feature 5 -->
                <div class="blog-feature animate-fade-in" style="animation-delay: 0.7s;">
                    <div class="blog-feature-image">
                        <img src="${pageContext.request.contextPath}/assets/images/fitness.webp" alt="New Fitness Programs">
                    </div>
                    <div class="blog-feature-content">
                        <h3>New Fitness Programs</h3>
                        <div class="blog-meta">
                            <span><i class="fas fa-user"></i> Admin</span>
                            <span><i class="far fa-calendar-alt"></i> July 15, 2023</span>
                        </div>
                        <p>Stay fit during your stay with our new fitness programs led by certified personal trainers. We now offer yoga classes, HIIT workouts, and personalized training sessions to help you maintain your fitness routine while traveling.</p>
                        <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-primary">Read More</a>
                    </div>
                </div>
            </div>

            <div class="text-center" style="margin-top: 40px;">
                <a href="${pageContext.request.contextPath}/blog.jsp" class="btn btn-secondary animate-fade-in" style="animation-delay: 0.8s;">View All Blog Posts</a>
            </div>
        </div>
    </section>

    <!-- Upcoming Events Section -->
    <section class="section" style="background-color: #fff; padding: 60px 0;">
        <div class="container">
            <div class="section-title animate-fade-in" style="text-align: center; margin-bottom: 40px;">
                <h2 style="font-size: 32px; color: #333; margin-bottom: 10px;">Upcoming Events</h2>
                <p style="font-size: 16px; color: #666;">Join us for exciting events and experiences</p>
            </div>

            <div class="event-cards" style="display: flex; justify-content: space-between; flex-wrap: nowrap; overflow-x: auto; padding-bottom: 15px;">
                <!-- Show only first 3 events -->
                <c:forEach var="event" items="${upcomingEvents}" varStatus="loop" begin="0" end="2">
                    <c:set var="marginRight" value="${loop.last ? '0' : '2%'}" />
                    <div class="event-card animate-fade-in" style="animation-delay: ${loop.index * 0.2}s; flex: 0 0 32%; margin-right: ${marginRight}; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/${event.imagePath}" alt="${event.eventName}" style="width: 100%; height: 200px; object-fit: cover;">
                            <div style="position: absolute; bottom: 0; left: 0; width: 100%; padding: 10px; background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0)); color: white;">
                                <div style="display: flex; align-items: center;">
                                    <i class="far fa-calendar-alt" style="margin-right: 5px;"></i> ${event.date}
                                </div>
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">${event.eventName}</h3>
                            <div style="margin-bottom: 10px; color: #666;"><i class="fas fa-map-marker-alt" style="color: #5a3921; margin-right: 5px;"></i> ${event.location}</div>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">${event.description}</p>
                            <a href="${pageContext.request.contextPath}/event?id=${event.id}" class="btn btn-primary" style="display: block; text-align: center;">View Details</a>
                        </div>
                    </div>
                </c:forEach>

                <!-- Fallback if no events are loaded -->
                <c:if test="${empty upcomingEvents}">
                    <!-- New Year Gala -->
                    <div class="event-card animate-fade-in" style="animation-delay: 0.1s; flex: 0 0 32%; margin-right: 2%; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/assets/images/new%20year%20event.webp" alt="New Year Gala" style="width: 100%; height: 200px; object-fit: cover;">
                            <div style="position: absolute; bottom: 0; left: 0; width: 100%; padding: 10px; background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0)); color: white;">
                                <div style="display: flex; align-items: center;">
                                    <i class="far fa-calendar-alt" style="margin-right: 5px;"></i> December 31, 2023
                                </div>
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">New Year Gala</h3>
                            <div style="margin-bottom: 10px; color: #666;"><i class="fas fa-map-marker-alt" style="color: #5a3921; margin-right: 5px;"></i> Grand Ballroom</div>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">Join us for an unforgettable New Year celebration with live music, gourmet dinner, and fireworks.</p>
                            <a href="${pageContext.request.contextPath}/events.jsp" class="btn btn-primary" style="display: block; text-align: center;">View Details</a>
                        </div>
                    </div>

                    <!-- Wedding Showcase -->
                    <div class="event-card animate-fade-in" style="animation-delay: 0.2s; flex: 0 0 32%; margin-right: 2%; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/assets/images/weeding show case.webp" alt="Wedding Showcase" style="width: 100%; height: 200px; object-fit: cover;">
                            <div style="position: absolute; bottom: 0; left: 0; width: 100%; padding: 10px; background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0)); color: white;">
                                <div style="display: flex; align-items: center;">
                                    <i class="far fa-calendar-alt" style="margin-right: 5px;"></i> June 15, 2023
                                </div>
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">Wedding Showcase</h3>
                            <div style="margin-bottom: 10px; color: #666;"><i class="fas fa-map-marker-alt" style="color: #5a3921; margin-right: 5px;"></i> Garden Terrace</div>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">Explore our wedding venues and packages at this special event designed for couples planning their big day.</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary" style="display: block; text-align: center;">View Details</a>
                        </div>
                    </div>

                    <!-- Wine Tasting Evening -->
                    <div class="event-card animate-fade-in" style="animation-delay: 0.3s; flex: 0 0 32%; margin-right: 0; background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.1);">
                        <div style="position: relative;">
                            <img src="${pageContext.request.contextPath}/assets/images/wine%20tasting.webp" alt="Wine Tasting Evening" style="width: 100%; height: 200px; object-fit: cover;">
                            <div style="position: absolute; bottom: 0; left: 0; width: 100%; padding: 10px; background: linear-gradient(to top, rgba(0,0,0,0.7), rgba(0,0,0,0)); color: white;">
                                <div style="display: flex; align-items: center;">
                                    <i class="far fa-calendar-alt" style="margin-right: 5px;"></i> July 20, 2023
                                </div>
                            </div>
                        </div>
                        <div style="padding: 20px;">
                            <h3 style="font-size: 20px; margin-bottom: 10px; color: #333;">Wine Tasting Evening</h3>
                            <div style="margin-bottom: 10px; color: #666;"><i class="fas fa-map-marker-alt" style="color: #5a3921; margin-right: 5px;"></i> Wine Cellar</div>
                            <p style="color: #666; margin-bottom: 15px; line-height: 1.5; height: 60px; overflow: hidden;">Sample premium wines from around the world paired with delicious appetizers prepared by our chef.</p>
                            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary" style="display: block; text-align: center;">View Details</a>
                        </div>
                    </div>
                </c:if>
            </div>

            <!-- View All Events Button -->
            <div style="text-align: center; margin-top: 30px;">
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
                            <img src="${pageContext.request.contextPath}/assets/images/kushal pp size photo.jpg" alt="John Doe">
                            <div class="author-info">
                                <h4>Kushal Poudel</h4>
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
                            <img src="${pageContext.request.contextPath}/assets/images/Nishal Poudel 9800995423 EDV.jpg" alt="Jane Smith">
                            <div class="author-info">
                                <h4>Nishal Poudel</h4>
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
                            <img src="${pageContext.request.contextPath}/assets/images/chandani.JPG" alt="Robert Johnson">
                            <div class="author-info">
                                <h4>Chadhani Adhikari</h4>
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
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Initialize animations for elements in viewport
            const animateElements = document.querySelectorAll('.animate-fade-in, .animate-slide-in');

            // Function to check if element is in viewport
            function isInViewport(element) {
                const rect = element.getBoundingClientRect();
                return (
                    rect.top <= (window.innerHeight || document.documentElement.clientHeight) &&
                    rect.bottom >= 0
                );
            }

            // Function to handle scroll animation
            function handleScrollAnimation() {
                animateElements.forEach(element => {
                    if (isInViewport(element) && !element.classList.contains('animated')) {
                        element.classList.add('animated');
                        element.style.visibility = 'visible';
                    }
                });
            }

            // Hide elements initially
            animateElements.forEach(element => {
                element.style.visibility = 'hidden';
            });

            // Trigger once on load
            handleScrollAnimation();

            // Trigger on scroll
            window.addEventListener('scroll', handleScrollAnimation);

            // Add hover effect to service items
            const serviceItems = document.querySelectorAll('.service-item');
            serviceItems.forEach(item => {
                item.addEventListener('mouseenter', function() {
                    const overlay = this.querySelector('.service-overlay');
                    if (overlay) {
                        overlay.style.opacity = '1';
                    }
                });

                item.addEventListener('mouseleave', function() {
                    const overlay = this.querySelector('.service-overlay');
                    if (overlay) {
                        overlay.style.opacity = '0';
                    }
                });
            });


        });
    </script>
</body>
</html>
