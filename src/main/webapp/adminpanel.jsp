<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Panel</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-login.css">
</head>
<body>
    <div class="admin-login-container">
        <!-- Left side - Background Image with Welcome Text -->
        <div class="admin-login-image">
            <div class="admin-login-welcome">
                <h1>Admin Panel</h1>
                <h1>Luxury Hotel</h1>
                <p>Secure access to the hotel management system. Only authorized personnel are allowed.</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline">Return to Home</a>
            </div>
        </div>

        <!-- Right side - Admin Login Form -->
        <div class="admin-login-form-container">
            <div class="admin-login-form">
                <div class="admin-login-logo">Luxury <span>Hotel</span></div>
                <div class="admin-login-icon">
                    <i class="fas fa-user-shield"></i>
                </div>
                <h2 class="admin-login-title">Admin Panel</h2>
                <p class="admin-login-subtitle">Enter your credentials to access the admin panel</p>

                <!-- Display error message if any -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger">
                        ${error}
                    </div>
                </c:if>

                <!-- Display message if any -->
                <c:if test="${not empty param.message}">
                    <div class="alert alert-success">
                        ${param.message}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/adminpanel" method="post">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" required>
                    </div>
                    <button type="submit" class="btn-admin-login">Login</button>
                </form>

                <div class="admin-login-footer">
                    <a href="${pageContext.request.contextPath}/"><i class="fas fa-arrow-left"></i> Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
