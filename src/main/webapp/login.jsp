<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Login</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/login.css">
</head>
<body>
    <div class="login-container">
        <!-- Left side - Background Image with Welcome Text -->
        <div class="login-image" >
            <div class="login-welcome">
                <h1>Welcome Back to</h1>
                <h1>Luxury Hotel</h1>
                <p>Experience luxury and comfort like never before. Login to access your account and improve your stay.</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline" style="background-color: rgba(255,255,255,0.2); border: 2px solid white; padding: 12px 25px; font-size: 18px; font-weight: 600; margin-top: 20px; display: inline-block; transition: all 0.3s ease;" onmouseover="this.style.backgroundColor='rgba(255,255,255,0.3)'; this.style.transform='translateY(-3px)';" onmouseout="this.style.backgroundColor='rgba(255,255,255,0.2)'; this.style.transform='translateY(0)'">
                    <i class="fas fa-home"></i> Return to Home
                </a>
            </div>
        </div>

        <!-- Right side - Login Form -->
        <div class="login-form-container">
            <div class="login-form">
                <div class="login-logo">Luxury <span>Hotel</span></div>
                <h2 class="login-title">Login to Your Account</h2>

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

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" required minlength="8">
                        <div class="password-info" id="passwordInfo"></div>
                    </div>
                    <div class="remember-me">
                        <input type="checkbox" id="remember-me" name="remember-me">
                        <label for="remember-me">Remember me</label>
                    </div>
                    <div class="forgot-password">
                        <a href="#">Forgot Password?</a>
                    </div>
                    <button type="submit" class="btn-login">Login</button>
                </form>

                <div class="login-footer">
                    <p>Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a></p>
                    <p style="margin-top: 10px; font-size: 12px;"><a href="${pageContext.request.contextPath}/session_debug.jsp" style="color: #999;">View Session Debug</a></p>
                    <div style="margin-top: 20px; text-align: center;">
                        <a href="${pageContext.request.contextPath}/" class="btn-home" style="display: inline-block; background-color: #f9f7f4; color: #5a3921; border: 2px solid #5a3921; padding: 10px 20px; border-radius: 5px; text-decoration: none; font-weight: 500; transition: all 0.3s ease;" onmouseover="this.style.backgroundColor='#5a3921'; this.style.color='white'; this.style.transform='translateY(-3px)';" onmouseout="this.style.backgroundColor='#f9f7f4'; this.style.color='#5a3921'; this.style.transform='translateY(0)'">
                            <i class="fas fa-home"></i> Return to Home
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const passwordInput = document.getElementById('password');
            const passwordInfo = document.getElementById('passwordInfo');
            const loginForm = document.querySelector('form');

            // Check password length on input
            passwordInput.addEventListener('input', function() {
                const password = this.value;

                if (password.length > 0 && password.length < 8) {
                    passwordInfo.textContent = 'Password must be at least 8 characters long';
                    passwordInfo.style.display = 'block';
                } else {
                    passwordInfo.textContent = '';
                    passwordInfo.style.display = 'none';
                }
            });

            // Form validation
            loginForm.addEventListener('submit', function(e) {
                const password = passwordInput.value;

                // Check password length
                if (password.length < 8) {
                    e.preventDefault();
                    passwordInfo.textContent = 'Password must be at least 8 characters long';
                    passwordInfo.style.display = 'block';
                    return;
                }
            });
        });
    </script>
</body>
</html>
