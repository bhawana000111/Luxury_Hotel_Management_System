<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Contact Us</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .contact-image {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .contact-image img {
            width: 100%;
            height: auto;
            display: block;
            transition: transform 0.5s ease;
        }

        .contact-image:hover img {
            transform: scale(1.03);
        }

        .contact-form {
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
        }

        .form-control {
            border: 1px solid #e0e0e0;
            padding: 12px 15px;
            border-radius: 5px;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            border-color: #5a3921;
            box-shadow: 0 0 0 3px rgba(90, 57, 33, 0.1);
        }

        .btn-submit {
            background-color: #5a3921;
            color: #fff;
            border: none;
            padding: 12px 25px;
            border-radius: 5px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
        }

        .btn-submit:hover {
            background-color: #4a2e1a;
            transform: translateY(-2px);
        }

        .success-message {
            background-color: #e8f5e9;
            border-left: 4px solid #4caf50;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
        }

        .success-message i {
            font-size: 24px;
            color: #4caf50;
            margin-right: 15px;
        }

        .error-message {
            background-color: #ffebee;
            border-left: 4px solid #f44336;
            padding: 20px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />

    <!-- Page Header -->
    <section class="page-header" style="background-image: url('${pageContext.request.contextPath}/assets/images/contact_header.jpg');">
        <div class="container">
            <h1>Contact Us</h1>
        </div>
    </section>

    <!-- Contact Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>Get in Touch</h2>
                <div class="title-underline"></div>
                <p>We'd love to hear from you. Please feel free to contact us with any questions or inquiries.</p>
            </div>

            <div class="contact-content">
                <div class="row">
                    <div class="contact-info">
                        <div class="contact-image">
                            <img src="${pageContext.request.contextPath}/assets/images/contact us background.webp" alt="Luxury Hotel Lobby">
                        </div>

                        <div class="contact-details">
                            <div class="contact-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <div>
                                    <h3>Address</h3>
                                    <p>123 Luxury Street, City, Country</p>
                                </div>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-phone"></i>
                                <div>
                                    <h3>Phone</h3>
                                    <p>+1 234 567 8900</p>
                                </div>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-envelope"></i>
                                <div>
                                    <h3>Email</h3>
                                    <p>info@luxuryhotel.com</p>
                                </div>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-clock"></i>
                                <div>
                                    <h3>Working Hours</h3>
                                    <p>24/7 - We're always here for you</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="contact-form">
                        <h2>Send us a Message</h2>

                        <c:if test="${success == true}">
                            <div class="success-message">
                                <i class="fas fa-check-circle"></i>
                                <div>
                                    <h3>Thank You for Contacting Us!</h3>
                                    <p>Dear ${name}, we have received your message and will get back to you as soon as possible.</p>
                                </div>
                            </div>
                        </c:if>

                        <c:if test="${not empty error}">
                            <div class="error-message">
                                <p><i class="fas fa-exclamation-circle"></i> ${error}</p>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/submitContact" method="post" id="contactForm">
                            <div class="form-group">
                                <label for="name">Name</label>
                                <input type="text" id="name" name="name" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="subject">Subject</label>
                                <input type="text" id="subject" name="subject" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="message">Message</label>
                                <textarea id="message" name="message" class="form-control" rows="5" required></textarea>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn-submit">Send Message</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Map Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Our Location</h2>
                <p>Find us on the map</p>
            </div>
            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3022.2176668558516!2d-73.98784482426815!3d40.75790937138252!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25855c6480299%3A0x55194ec5a1ae072e!2sTimes%20Square!5e0!3m2!1sen!2sus!4v1685000000000!5m2!1sen!2sus" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
        </div>
    </section>

    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
