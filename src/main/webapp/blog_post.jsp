<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - ${blog.title}</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .blog-post {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }
        
        .blog-post-image {
            width: 100%;
        }
        
        .blog-post-image img {
            width: 100%;
            height: auto;
        }
        
        .blog-post-content {
            padding: 30px;
        }
        
        .blog-post-title {
            margin-bottom: 15px;
        }
        
        .blog-post-meta {
            display: flex;
            margin-bottom: 20px;
            color: #777;
        }
        
        .blog-post-meta span {
            margin-right: 20px;
        }
        
        .blog-post-meta i {
            margin-right: 5px;
        }
        
        .blog-post-body {
            line-height: 1.8;
            margin-bottom: 30px;
        }
        
        .blog-post-body p {
            margin-bottom: 20px;
        }
        
        .blog-post-video {
            margin: 30px 0;
            position: relative;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
            overflow: hidden;
        }
        
        .blog-post-video iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        
        .blog-post-share {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .blog-post-share h4 {
            margin-bottom: 15px;
        }
        
        .social-share {
            display: flex;
        }
        
        .social-share a {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 40px;
            height: 40px;
            background-color: #f4f4f4;
            border-radius: 50%;
            margin-right: 10px;
            color: #333;
            transition: all 0.3s ease;
        }
        
        .social-share a:hover {
            background-color: var(--primary-color);
            color: #fff;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Blog Post Section -->
    <section class="section">
        <div class="container">
            <div class="blog-content">
                <div class="blog-main">
                    <div class="blog-post">
                        <div class="blog-post-image">
                            <c:choose>
                                <c:when test="${not empty blog.imagePath}">
                                    <img src="${pageContext.request.contextPath}/${blog.imagePath}" alt="${blog.title}">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/assets/images/blog_default.jpg" alt="${blog.title}">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="blog-post-content">
                            <h1 class="blog-post-title">${blog.title}</h1>
                            <div class="blog-post-meta">
                                <span><i class="fas fa-user"></i> ${blog.author}</span>
                                <span><i class="far fa-calendar-alt"></i> ${blog.createdAt}</span>
                            </div>
                            <div class="blog-post-body">
                                <p>${blog.content}</p>
                                
                                <!-- Video if available -->
                                <c:if test="${not empty blog.videoUrl}">
                                    <div class="blog-post-video">
                                        <iframe src="${blog.videoUrl}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                    </div>
                                </c:if>
                            </div>
                            
                            <div class="blog-post-share">
                                <h4>Share This Post</h4>
                                <div class="social-share">
                                    <a href="#"><i class="fab fa-facebook-f"></i></a>
                                    <a href="#"><i class="fab fa-twitter"></i></a>
                                    <a href="#"><i class="fab fa-linkedin-in"></i></a>
                                    <a href="#"><i class="fab fa-pinterest"></i></a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="blog-sidebar">
                    <div class="sidebar-widget">
                        <h3>Recent Posts</h3>
                        <ul class="recent-posts">
                            <li>
                                <a href="${pageContext.request.contextPath}/blogPost?id=1">Welcome to Luxury Hotel</a>
                                <span class="date">June 1, 2023</span>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/blogPost?id=2">Summer Special Offers</a>
                                <span class="date">June 10, 2023</span>
                            </li>
                            <li>
                                <a href="${pageContext.request.contextPath}/blogPost?id=3">Meet Our Executive Chef</a>
                                <span class="date">June 15, 2023</span>
                            </li>
                        </ul>
                    </div>
                    
                    <div class="sidebar-widget">
                        <h3>Categories</h3>
                        <ul class="categories">
                            <li><a href="#">Hotel News</a></li>
                            <li><a href="#">Special Offers</a></li>
                            <li><a href="#">Events</a></li>
                            <li><a href="#">Travel Tips</a></li>
                            <li><a href="#">Dining</a></li>
                        </ul>
                    </div>
                    
                    <div class="sidebar-widget">
                        <h3>Subscribe to Our Newsletter</h3>
                        <form action="#" method="post">
                            <div class="form-group">
                                <input type="email" name="email" placeholder="Your Email" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary btn-block">Subscribe</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
            
            <!-- Related Posts -->
            <div class="related-posts">
                <h3>Related Posts</h3>
                <div class="blog-cards">
                    <div class="blog-card">
                        <img src="${pageContext.request.contextPath}/assets/images/summer_offer.jpg" alt="Summer Special Offers">
                        <div class="blog-card-content">
                            <h3>Summer Special Offers</h3>
                            <div class="blog-meta">
                                <span class="author"><i class="fas fa-user"></i> Admin User</span>
                                <span class="date"><i class="far fa-calendar-alt"></i> June 10, 2023</span>
                            </div>
                            <p>Enjoy our special summer packages with 20% off on all room types. Book now to avail this limited-time offer...</p>
                            <a href="${pageContext.request.contextPath}/blogPost?id=2" class="btn btn-primary">Read More</a>
                        </div>
                    </div>
                    <div class="blog-card">
                        <img src="${pageContext.request.contextPath}/assets/images/chef_intro.jpg" alt="Meet Our Executive Chef">
                        <div class="blog-card-content">
                            <h3>Meet Our Executive Chef</h3>
                            <div class="blog-meta">
                                <span class="author"><i class="fas fa-user"></i> Admin User</span>
                                <span class="date"><i class="far fa-calendar-alt"></i> June 15, 2023</span>
                            </div>
                            <p>We are proud to introduce our new Executive Chef, Michael Brown, who brings 15 years of international culinary experience to our hotel...</p>
                            <a href="${pageContext.request.contextPath}/blogPost?id=3" class="btn btn-primary">Read More</a>
                        </div>
                    </div>
                    <div class="blog-card">
                        <img src="${pageContext.request.contextPath}/assets/images/spa_services.jpg" alt="New Spa Services">
                        <div class="blog-card-content">
                            <h3>New Spa Services</h3>
                            <div class="blog-meta">
                                <span class="author"><i class="fas fa-user"></i> Admin User</span>
                                <span class="date"><i class="far fa-calendar-alt"></i> June 20, 2023</span>
                            </div>
                            <p>Discover our new range of spa services designed to provide the ultimate relaxation experience during your stay...</p>
                            <a href="${pageContext.request.contextPath}/blogPost?id=4" class="btn btn-primary">Read More</a>
                        </div>
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
