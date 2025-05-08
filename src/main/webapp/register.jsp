<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Register</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/register.css">
</head>
<body>
    <div class="register-container">
        <!-- Left side - Background Image with Welcome Text -->
        <div class="register-image">
            <div class="register-welcome">
                <h1>Create Your Account</h1>
                <h1>Luxury Hotel</h1>
                <p>Join us to experience luxury and comfort. Create your account to access exclusive offers and personalized services.</p>
                <a href="${pageContext.request.contextPath}/" class="btn btn-outline">Return to Home</a>
            </div>
        </div>

        <!-- Right side - Register Form -->
        <div class="register-form-container">
            <div class="register-form">
                <div class="register-logo">Luxury <span>Hotel</span></div>
                <h2 class="register-title">Create Your Account</h2>

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

                <form action="${pageContext.request.contextPath}/register" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="name">Full Name</label>
                        <input type="text" id="name" name="name" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" class="form-control" required>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" class="form-control" required minlength="8">
                        <div class="password-strength" id="passwordStrength"></div>
                        <div class="form-info">
                            <p>Password must be at least 8 characters.</p>
                            <p>Examples of strong passwords:</p>
                            <ul class="password-examples">
                                <li>Luxury2024!</li>
                                <li>Hotel@Room123</li>
                                <li>Welcome_2024</li>
                            </ul>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                        <div class="password-match" id="passwordMatch"></div>
                    </div>
                    <div class="form-group">
                        <label for="profileImage">Profile Image (Optional)</label>
                        <input type="file" id="profileImage" name="profileImage" class="form-control" accept="image/*">
                    </div>
                    <div class="terms-checkbox">
                        <input type="checkbox" id="terms" name="terms" required>
                        <label for="terms">I agree to the <a href="#">Terms and Conditions</a> and <a href="#">Privacy Policy</a></label>
                    </div>
                    <button type="submit" class="btn-register">Register</button>
                </form>

                <div class="register-footer">
                    <p>Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a></p>
                </div>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const passwordInput = document.getElementById('password');
            const confirmPasswordInput = document.getElementById('confirmPassword');
            const passwordStrength = document.getElementById('passwordStrength');
            const passwordMatch = document.getElementById('passwordMatch');
            const registerForm = document.querySelector('form');

            // Check password strength
            passwordInput.addEventListener('input', function() {
                const password = this.value;

                // Clear previous classes
                passwordStrength.className = 'password-strength';

                if (password.length === 0) {
                    passwordStrength.style.display = 'none';
                    return;
                }

                passwordStrength.style.display = 'block';

                // Check password strength
                if (password.length < 8) {
                    passwordStrength.classList.add('weak');
                } else if (password.length < 12) {
                    passwordStrength.classList.add('medium');
                } else {
                    passwordStrength.classList.add('strong');
                }
            });

            // Check password match
            function checkPasswordMatch() {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;

                if (confirmPassword.length === 0) {
                    passwordMatch.textContent = '';
                    passwordMatch.className = 'password-match';
                    return;
                }

                if (password === confirmPassword) {
                    passwordMatch.textContent = 'Passwords match';
                    passwordMatch.className = 'password-match match';
                } else {
                    passwordMatch.textContent = 'Passwords do not match';
                    passwordMatch.className = 'password-match not-match';
                }
            }

            confirmPasswordInput.addEventListener('input', checkPasswordMatch);
            passwordInput.addEventListener('input', function() {
                if (confirmPasswordInput.value.length > 0) {
                    checkPasswordMatch();
                }
            });

            // Form validation
            registerForm.addEventListener('submit', function(e) {
                const password = passwordInput.value;
                const confirmPassword = confirmPasswordInput.value;

                // Check password length
                if (password.length < 8) {
                    e.preventDefault();
                    alert('Password must be at least 8 characters long');
                    return;
                }

                // Check password match
                if (password !== confirmPassword) {
                    e.preventDefault();
                    alert('Passwords do not match');
                    return;
                }
            });
        });
    </script>
</body>
</html>
