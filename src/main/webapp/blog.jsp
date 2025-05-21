<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Blog</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Page Header -->
    <section class="page-header" style="background-image: url('${pageContext.request.contextPath}/assets/images/blog_header.jpg');">
        <div class="container">
            <h1>Our Blog</h1>
        </div>
    </section>
    
    <!-- Blog Section -->
    <section class="section">
        <div class="container">
            <div class="blog-content">
                <div class="blog-main">
                    <div class="blog-cards">
                        <c:forEach var="blog" items="${blogs}">
                            <div class="blog-card">
                                <c:choose>
                                    <c:when test="${not empty blog.imagePath}">
                                        <img src="${pageContext.request.contextPath}/${blog.imagePath}" alt="${blog.title}">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/abouts%20us%20background.webp" alt="${blog.title}">
                                    </c:otherwise>
                                </c:choose>
                                <div class="blog-card-content">
                                    <h3>${blog.title}</h3>
                                    <div class="blog-meta">
                                        <span class="author"><i class="fas fa-user"></i> ${blog.author}</span>
                                        <span class="date"><i class="far fa-calendar-alt"></i> ${blog.createdAt}</span>
                                    </div>
                                    <p>${blog.content.substring(0, Math.min(blog.content.length(), 150))}...</p>
                                    <a href="${pageContext.request.contextPath}/blogPost?id=${blog.id}" class="btn btn-primary">Read More</a>
                                </div>
                            </div>
                        </c:forEach>
                        
                        <!-- Fallback if no blogs are loaded -->
                        <c:if test="${empty blogs}">
                            <div class="blog-card">
                                <img src="${pageContext.request.contextPath}/assets/images/contact%20us%20background.webp
" alt="Welcome to Luxury Hotel">
                                <div class="blog-card-content">
                                    <h3>Welcome to Luxury Hotel</h3>
                                    <div class="blog-meta">
                                        <span class="author"><i class="fas fa-user"></i> Admin User</span>
                                        <span class="date"><i class="far fa-calendar-alt"></i> June 1, 2023</span>
                                    </div>
                                    <p>We are delighted to welcome you to our newly renovated Luxury Hotel. Experience the epitome of luxury and comfort during your stay with us...</p>
                                    <a href="${pageContext.request.contextPath}/blogPost?id=1" class="btn btn-primary">Read More</a>
                                </div>
                            </div>
                            <div class="blog-card">
                                <img src="${pageContext.request.contextPath}/assets/images/summer%20offer.webp" alt="Summer Special Offers">
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
                                <img src="${pageContext.request.contextPath}/assets/images/Chefs_intro.webp" alt="Meet Our Executive Chef">
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
                        </c:if>
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
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
