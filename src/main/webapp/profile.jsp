<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - My Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Profile Section -->
    <section class="section">
        <div class="container">
            <div class="profile-container">
                <div class="profile-header">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/${user.profileImage}" alt="${user.name}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/images/user.jpg" alt="${user.name}">
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <h2>${user.name}</h2>
                        <p>${user.email}</p>
                        <p>Member since: ${user.createdAt}</p>
                    </div>
                </div>
                
                <div class="profile-tabs">
                    <div class="tab active" data-tab="profile-info">Profile Information</div>
                    <div class="tab" data-tab="change-password">Change Password</div>
                    <div class="tab" data-tab="booking-history">Booking History</div>
                </div>
                
                <div class="profile-content">
                    <!-- Profile Information Tab -->
                    <div id="profile-info" class="tab-content active">
                        <form action="${pageContext.request.contextPath}/updateProfile" method="post" enctype="multipart/form-data" id="updateProfileForm">
                            <div class="form-group">
                                <label for="name">Full Name</label>
                                <input type="text" id="name" name="name" class="form-control" value="${user.name}" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" class="form-control" value="${user.email}" required>
                            </div>
                            <div class="form-group">
                                <label for="profileImage">Profile Image</label>
                                <input type="file" id="profileImage" name="profileImage" class="form-control" accept="image/*">
                                <small>Leave empty to keep current image</small>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Update Profile</button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Change Password Tab -->
                    <div id="change-password" class="tab-content">
                        <form action="${pageContext.request.contextPath}/updatePassword" method="post" id="updatePasswordForm">
                            <div class="form-group">
                                <label for="currentPassword">Current Password</label>
                                <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="newPassword">New Password</label>
                                <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <label for="confirmPassword">Confirm New Password</label>
                                <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                            </div>
                            <div class="form-group">
                                <button type="submit" class="btn btn-primary">Change Password</button>
                            </div>
                        </form>
                    </div>
                    
                    <!-- Booking History Tab -->
                    <div id="booking-history" class="tab-content">
                        <c:choose>
                            <c:when test="${not empty bookings}">
                                <div class="booking-list">
                                    <c:forEach var="booking" items="${bookings}">
                                        <div class="booking-item">
                                            <div class="booking-item-header">
                                                <h3>Booking #${booking.id}</h3>
                                                <span class="booking-status ${booking.status.toLowerCase()}">${booking.status}</span>
                                            </div>
                                            <div class="booking-item-body">
                                                <p><strong>Room:</strong> ${booking.roomType} (${booking.roomNumber})</p>
                                                <p><strong>Check-in:</strong> ${booking.dateFrom}</p>
                                                <p><strong>Check-out:</strong> ${booking.dateTo}</p>
                                                <p><strong>Booked on:</strong> ${booking.createdAt}</p>
                                                <div class="booking-item-actions">
                                                    <a href="${pageContext.request.contextPath}/booking?id=${booking.id}" class="btn btn-primary btn-sm">View Details</a>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="no-bookings">
                                    <p>You don't have any bookings yet.</p>
                                    <a href="${pageContext.request.contextPath}/rooms" class="btn btn-primary">Browse Rooms</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
            // Tab switching functionality
            const tabs = document.querySelectorAll('.profile-tabs .tab');
            const tabContents = document.querySelectorAll('.profile-content .tab-content');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Remove active class from all tabs
                    tabs.forEach(t => t.classList.remove('active'));
                    
                    // Add active class to clicked tab
                    this.classList.add('active');
                    
                    // Show corresponding tab content
                    const tabId = this.getAttribute('data-tab');
                    tabContents.forEach(content => {
                        content.classList.remove('active');
                        if (content.getAttribute('id') === tabId) {
                            content.classList.add('active');
                        }
                    });
                });
            });
            
            // Password validation
            const updatePasswordForm = document.getElementById('updatePasswordForm');
            if (updatePasswordForm) {
                updatePasswordForm.addEventListener('submit', function(e) {
                    const newPassword = document.getElementById('newPassword').value;
                    const confirmPassword = document.getElementById('confirmPassword').value;
                    
                    if (newPassword !== confirmPassword) {
                        e.preventDefault();
                        alert('New passwords do not match');
                    }
                });
            }
        });
    </script>
</body>
</html>
