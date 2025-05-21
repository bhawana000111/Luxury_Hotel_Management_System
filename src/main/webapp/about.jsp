<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - About Us</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .about-image {
            position: relative;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
            height: 100%;
        }

        .about-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .about-image:hover img {
            transform: scale(1.05);
        }

        .about-feature {
            transition: all 0.3s ease;
            border-radius: 10px;
            padding: 25px 20px;
            background-color: #fff;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }

        .about-feature:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
            border-bottom: 3px solid #d4af37;
        }

        .about-feature i {
            font-size: 36px;
            color: #d4af37;
            margin-bottom: 20px;
        }

        .staff-card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            background-color: #fff;
        }

        .staff-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .staff-card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .staff-card:hover img {
            transform: scale(1.05);
        }

        .staff-card-content {
            padding: 20px;
        }

        .staff-card .role {
            color: #d4af37;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .facility-item {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
            background-color: #fff;
            margin-bottom: 30px;
        }

        .facility-item:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }

        .facility-item img {
            width: 100%;
            height: 250px;
            object-fit: cover;
            transition: transform 0.5s ease;
        }

        .facility-item:hover img {
            transform: scale(1.05);
        }

        .facility-item h3 {
            padding: 20px 20px 10px;
            color: #5a3921;
        }

        .facility-item p {
            padding: 0 20px 20px;
            color: #666;
        }

        .about-btn {
            display: inline-block;
            background-color: #5a3921;
            color: #fff;
            padding: 12px 25px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            margin-top: 20px;
        }

        .about-btn:hover {
            background-color: #d4af37;
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Page Header -->
    <section class="page-header" style="background-image: url('${pageContext.request.contextPath}/assets/images/about_header.jpg');">
        <div class="container">
            <h1>About Us</h1>
        </div>
    </section>

    <!-- About Section -->
    <section class="section about-page-section">
        <div class="container">
            <div class="section-title">
                <h2>About Our Hotel</h2>
                <div class="title-underline"></div>
                <p>Discover the perfect blend of luxury, comfort, and exceptional service</p>
            </div>

            <div class="about-content">
                <div class="about-grid">
                    <div class="about-text">
                        <h3>Experience Luxury Like Never Before</h3>
                        <p>Welcome to Luxury Hotel, where elegance meets comfort. Our hotel is designed to provide you with an unforgettable experience, combining luxurious accommodations, world-class amenities, and exceptional service.</p>
                        <p>Located in the heart of the city, we offer easy access to major attractions, shopping centers, and business districts. Whether you're traveling for business or pleasure, our dedicated staff is committed to ensuring your stay is nothing short of perfect.</p>
                        <p>Since our establishment in 1995, we have been committed to providing our guests with the highest level of service and comfort. Our hotel has received numerous awards for excellence in hospitality, including the prestigious "Five-Star Luxury Hotel" award for five consecutive years.</p>

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

                        <a href="${pageContext.request.contextPath}/blog.jsp" class="about-btn">Read Our Blog</a>
                    </div>
                    <div class="about-image">
                        <img src="${pageContext.request.contextPath}/assets/images/about suite.webp" alt="Luxury Hotel Suite">
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Team Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Meet Our Team</h2>
                <p>The people behind our exceptional service</p>
            </div>
            <div class="staff-cards">
                <div class="staff-card">
                    <img src="${pageContext.request.contextPath}/assets/images/bhawana.jpg" alt="John Smith">
                    <div class="staff-card-content">
                        <h3>Bhawana Ghimire</h3>
                        <div class="role">General Manager</div>
                        <p>With over 4 years of experience in the hospitality industry, She leads our team with passion and dedication. She is the Yongest General Manager and the talented.</p>
                    </div>
                </div>
                <div class="staff-card">
                    <img src="${pageContext.request.contextPath}/assets/images/sakila.jpg" alt="Emily Johnson">
                    <div class="staff-card-content">
                        <h3>Sakila Shrestha</h3>
                        <div class="role">Front Desk Manager</div>
                        <p>Emily ensures that every guest receives a warm welcome and exceptional service throughout their stay.</p>
                    </div>
                </div>
                <div class="staff-card">
                    <img src="${pageContext.request.contextPath}/assets/images/michael_brown.jpg" alt="Michael Brown">
                    <div class="staff-card-content">
                        <h3>Roshni Tamang</h3>
                        <div class="role">Executive Chef</div>
                        <p>Michael brings his culinary expertise to create delicious and innovative dishes for our guests.</p>
                    </div>
                </div>
                <div class="staff-card">
                    <img src="${pageContext.request.contextPath}/assets/images/sarah_davis.jpg" alt="Sarah Davis">
                    <div class="staff-card-content">
                        <h3>Sudip Mahni Gautam</h3>
                        <div class="role">Housekeeping Manager</div>
                        <p>Sarah and her team ensure that our rooms and facilities are always clean and comfortable.</p>
                    </div>
                </div>
                <div class="staff-card">
                    <img src="${pageContext.request.contextPath}/assets/images/robert_wilson.jpg" alt="Robert Wilson">
                    <div class="staff-card-content">
                        <h3>Saurav Basnet</h3>
                        <div class="role">Concierge</div>
                        <p>Robert's extensive knowledge of the city helps our guests discover the best local attractions and experiences.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Facilities Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>Our Facilities</h2>
                <p>Discover the amenities that make your stay comfortable</p>
            </div>
            <div class="facilities-content">
                <div class="row">
                    <div class="facility-item">
                        <img src="${pageContext.request.contextPath}/assets/images/resturant.webp" alt="Restaurant">
                        <h3>Restaurant</h3>
                        <p>Our restaurant offers a diverse menu of international and local cuisine, prepared by our talented chefs using the finest ingredients.</p>
                    </div>
                    <div class="facility-item">
                        <img src="${pageContext.request.contextPath}/assets/images/spa.webp" alt="Spa">
                        <h3>Spa</h3>
                        <p>Relax and rejuvenate with our range of spa treatments, designed to provide the ultimate relaxation experience.</p>
                    </div>
                    <div class="facility-item">
                        <img src="${pageContext.request.contextPath}/assets/images/pool.webp" alt="Swimming Pool">
                        <h3>Swimming Pool</h3>
                        <p>Take a refreshing dip in our luxurious swimming pool, surrounded by comfortable loungers and a poolside bar.</p>
                    </div>
                    <div class="facility-item">
                        <img src="${pageContext.request.contextPath}/assets/images/fitness.webp" alt="Fitness Center">
                        <h3>Fitness Center</h3>
                        <p>Stay fit during your stay with our state-of-the-art fitness center, equipped with modern exercise machines and free weights.</p>
                    </div>
                    <div class="facility-item">
                        <img src="${pageContext.request.contextPath}/assets/images/banquete.webp" alt="Conference Room">
                        <h3>Conference Room</h3>
                        <p>Our conference rooms are perfect for business meetings, seminars, and other corporate events.</p>
                    </div>
                    <div class="facility-item">
                        <img src="${pageContext.request.contextPath}/assets/images/ball.webp" alt="Ballroom">
                        <h3>Ballroom</h3>
                        <p>Our elegant ballroom is the perfect venue for weddings, galas, and other special events.</p>
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
