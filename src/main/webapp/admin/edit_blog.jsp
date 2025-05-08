<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Edit Blog Post</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../partials/header.jsp" />
    
    <!-- Dashboard Section -->
    <section class="dashboard">
        <!-- Sidebar -->
        <div class="dashboard-sidebar">
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard.jsp"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fas fa-users"></i> Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fas fa-bed"></i> Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/bookings"><i class="fas fa-calendar-check"></i> Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/staff"><i class="fas fa-user-tie"></i> Staff</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/events"><i class="fas fa-calendar-day"></i> Events</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Edit Blog Post</h2>
                <div>
                    <a href="${pageContext.request.contextPath}/admin/blog" class="btn btn-secondary"><i class="fas fa-arrow-left"></i> Back to Blog</a>
                </div>
            </div>
            
            <!-- Edit Blog Form -->
            <div class="form-container">
                <form action="${pageContext.request.contextPath}/admin/editBlog" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="id" value="${blog.id}">
                    
                    <div class="form-group">
                        <label for="title">Title</label>
                        <input type="text" id="title" name="title" class="form-control" value="${blog.title}" required>
                    </div>
                    <div class="form-group">
                        <label for="content">Content</label>
                        <textarea id="content" name="content" class="form-control" rows="15" required>${blog.content}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="videoUrl">Video URL (Optional)</label>
                        <input type="text" id="videoUrl" name="videoUrl" class="form-control" value="${blog.videoUrl}" placeholder="e.g., https://www.youtube.com/embed/VIDEO_ID">
                        <small>Use embed URL format for YouTube videos</small>
                    </div>
                    <div class="form-group">
                        <label for="blogImage">Blog Image</label>
                        <c:if test="${not empty blog.imagePath}">
                            <div class="current-image">
                                <img src="${pageContext.request.contextPath}/${blog.imagePath}" alt="${blog.title}" width="200">
                                <p>Current image</p>
                            </div>
                        </c:if>
                        <input type="file" id="blogImage" name="blogImage" class="form-control" accept="image/*">
                        <small>Leave empty to keep current image</small>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">Update Blog Post</button>
                        <a href="${pageContext.request.contextPath}/admin/blog" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
