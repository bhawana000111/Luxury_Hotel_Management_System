<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Feedback</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .rating {
            display: flex;
            flex-direction: row-reverse;
            justify-content: flex-end;
        }
        
        .rating input {
            display: none;
        }
        
        .rating label {
            cursor: pointer;
            width: 40px;
            height: 40px;
            margin-right: 5px;
            position: relative;
            font-size: 30px;
            color: #ddd;
        }
        
        .rating label:before {
            content: '\f005';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            position: absolute;
            top: 0;
            left: 0;
        }
        
        .rating input:checked ~ label {
            color: #ffc107;
        }
        
        .rating label:hover,
        .rating label:hover ~ label {
            color: #ffc107;
        }
        
        .rating input:checked + label:hover,
        .rating input:checked ~ label:hover,
        .rating label:hover ~ input:checked ~ label,
        .rating input:checked ~ label:hover ~ label {
            color: #ffc107;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Feedback Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>Share Your Feedback</h2>
                <p>We value your opinion and would love to hear about your experience</p>
            </div>
            
            <div class="row">
                <div class="col-md-8 offset-md-2">
                    <div class="feedback-form">
                        <form action="${pageContext.request.contextPath}/submitFeedback" method="post" id="feedbackForm">
                            <div class="form-group">
                                <label>How would you rate your overall experience?</label>
                                <div class="rating">
                                    <input type="radio" id="star5" name="rating" value="5" />
                                    <label for="star5" title="5 stars"></label>
                                    <input type="radio" id="star4" name="rating" value="4" />
                                    <label for="star4" title="4 stars"></label>
                                    <input type="radio" id="star3" name="rating" value="3" />
                                    <label for="star3" title="3 stars"></label>
                                    <input type="radio" id="star2" name="rating" value="2" />
                                    <label for="star2" title="2 stars"></label>
                                    <input type="radio" id="star1" name="rating" value="1" />
                                    <label for="star1" title="1 star"></label>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="message">Your Feedback</label>
                                <textarea id="message" name="message" class="form-control" rows="5" required></textarea>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Submit Feedback</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Recent Testimonials -->
            <div class="section-title" style="margin-top: 50px;">
                <h2>What Others Say</h2>
                <p>Read testimonials from our guests</p>
            </div>
            
            <div class="testimonial-cards">
                <div class="testimonial-card">
                    <p>"Our stay at Luxury Hotel was absolutely amazing. The staff was friendly and attentive, the room was clean and comfortable, and the amenities were top-notch. We will definitely be coming back!"</p>
                    <div class="author">
                        <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="John Doe">
                        <div class="author-info">
                            <h4>John Doe</h4>
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
                    <p>"The service at Luxury Hotel exceeded all our expectations. The staff went above and beyond to make our anniversary special. The room was beautiful and the view was breathtaking."</p>
                    <div class="author">
                        <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="Jane Smith">
                        <div class="author-info">
                            <h4>Jane Smith</h4>
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
                    <p>"I've stayed at many luxury hotels around the world, but Luxury Hotel truly stands out. The attention to detail, the quality of service, and the overall experience were exceptional."</p>
                    <div class="author">
                        <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="Robert Johnson">
                        <div class="author-info">
                            <h4>Robert Johnson</h4>
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
            </div>
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Validate form submission
            const feedbackForm = document.getElementById('feedbackForm');
            if (feedbackForm) {
                feedbackForm.addEventListener('submit', function(e) {
                    const rating = document.querySelector('input[name="rating"]:checked');
                    const message = document.getElementById('message').value;
                    
                    if (!rating) {
                        e.preventDefault();
                        alert('Please select a rating');
                    } else if (!message.trim()) {
                        e.preventDefault();
                        alert('Please enter your feedback');
                    }
                });
            }
        });
    </script>
</body>
</html>
