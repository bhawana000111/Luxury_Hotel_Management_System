<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Our Staff</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <!-- Page Header -->
    <section class="page-header" style="background-image: url('${pageContext.request.contextPath}/assets/images/staff_header.jpg');">
        <div class="container">
            <h1>Our Staff</h1>
        </div>
    </section>
    
    <!-- Staff Section -->
    <section class="section">
        <div class="container">
            <div class="section-title">
                <h2>Meet Our Team</h2>
                <p>The people behind our exceptional service</p>
            </div>
            
            <!-- Staff Role Filter -->
            <div class="staff-filter">
                <form action="${pageContext.request.contextPath}/staff" method="get">
                    <div class="filter-group">
                        <label for="role">Role:</label>
                        <select id="role" name="role" class="form-control" onchange="this.form.submit()">
                            <option value="">All Roles</option>
                            <option value="Management" ${selectedRole eq 'Management' ? 'selected' : ''}>Management</option>
                            <option value="Front Desk" ${selectedRole eq 'Front Desk' ? 'selected' : ''}>Front Desk</option>
                            <option value="Housekeeping" ${selectedRole eq 'Housekeeping' ? 'selected' : ''}>Housekeeping</option>
                            <option value="Restaurant" ${selectedRole eq 'Restaurant' ? 'selected' : ''}>Restaurant</option>
                            <option value="Spa" ${selectedRole eq 'Spa' ? 'selected' : ''}>Spa</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Staff Cards -->
            <div class="staff-cards">
                <c:forEach var="staff" items="${staffList}">
                    <div class="staff-card">
                        <c:choose>
                            <c:when test="${not empty staff.imagePath}">
                                <img src="${pageContext.request.contextPath}/${staff.imagePath}" alt="${staff.name}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/images/staff_default.jpg" alt="${staff.name}">
                            </c:otherwise>
                        </c:choose>
                        <div class="staff-card-content">
                            <h3>${staff.name}</h3>
                            <div class="role">${staff.role}</div>
                            <p>${staff.email}</p>
                            <p>${staff.phone}</p>
                        </div>
                    </div>
                </c:forEach>
                
                <!-- Fallback if no staff are loaded -->
                <c:if test="${empty staffList}">
                    <div class="staff-card">
                        <img src="${pageContext.request.contextPath}/assets/images/john_smith.jpg" alt="John Smith">
                        <div class="staff-card-content">
                            <h3>John Smith</h3>
                            <div class="role">General Manager</div>
                            <p>With over 20 years of experience in the hospitality industry, John leads our team with passion and dedication.</p>
                        </div>
                    </div>
                    <div class="staff-card">
                        <img src="${pageContext.request.contextPath}/assets/images/emily_johnson.jpg" alt="Emily Johnson">
                        <div class="staff-card-content">
                            <h3>Emily Johnson</h3>
                            <div class="role">Front Desk Manager</div>
                            <p>Emily ensures that every guest receives a warm welcome and exceptional service throughout their stay.</p>
                        </div>
                    </div>
                    <div class="staff-card">
                        <img src="${pageContext.request.contextPath}/assets/images/michael_brown.jpg" alt="Michael Brown">
                        <div class="staff-card-content">
                            <h3>Michael Brown</h3>
                            <div class="role">Executive Chef</div>
                            <p>Michael brings his culinary expertise to create delicious and innovative dishes for our guests.</p>
                        </div>
                    </div>
                    <div class="staff-card">
                        <img src="${pageContext.request.contextPath}/assets/images/sarah_davis.jpg" alt="Sarah Davis">
                        <div class="staff-card-content">
                            <h3>Sarah Davis</h3>
                            <div class="role">Housekeeping Manager</div>
                            <p>Sarah and her team ensure that our rooms and facilities are always clean and comfortable.</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </section>
    
    <!-- Join Our Team Section -->
    <section class="section bg-light">
        <div class="container">
            <div class="section-title">
                <h2>Join Our Team</h2>
                <p>Become part of our exceptional team at Luxury Hotel</p>
            </div>
            <div class="join-team-content">
                <p>At Luxury Hotel, we are always looking for talented and passionate individuals to join our team. We offer a dynamic work environment, competitive compensation, and opportunities for growth and development.</p>
                <p>If you are interested in a career in the hospitality industry and want to be part of a team that is dedicated to providing exceptional service, we would love to hear from you.</p>
                <div class="text-center" style="margin-top: 30px;">
                    <a href="${pageContext.request.contextPath}/careers.jsp" class="btn btn-primary">View Current Openings</a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
