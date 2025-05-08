<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Admin Feedback</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .rating-stars {
            color: #ffc107;
        }
        
        .feedback-stats {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        
        .stat-card {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            width: calc(25% - 20px);
            text-align: center;
        }
        
        .stat-card h3 {
            margin-bottom: 10px;
            color: #777;
        }
        
        .stat-card .number {
            font-size: 36px;
            font-weight: bold;
            color: var(--primary-color);
        }
        
        .feedback-card {
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            overflow: hidden;
        }
        
        .feedback-card-header {
            background-color: #f9f9f9;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #eee;
        }
        
        .feedback-card-body {
            padding: 20px;
        }
        
        .feedback-card-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        @media (max-width: 992px) {
            .stat-card {
                width: calc(50% - 15px);
                margin-bottom: 20px;
            }
        }
        
        @media (max-width: 576px) {
            .stat-card {
                width: 100%;
            }
        }
    </style>
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
                <li><a href="${pageContext.request.contextPath}/admin/blog"><i class="fas fa-blog"></i> Blog</a></li>
                <li class="active"><a href="${pageContext.request.contextPath}/admin/feedback"><i class="fas fa-comment"></i> Feedback</a></li>
            </ul>
        </div>
        
        <!-- Content -->
        <div class="dashboard-content">
            <div class="dashboard-header">
                <h2>Guest Feedback</h2>
            </div>
            
            <!-- Feedback Stats -->
            <div class="feedback-stats">
                <div class="stat-card">
                    <h3>Average Rating</h3>
                    <div class="number">${averageRating}/5</div>
                    <div class="rating-stars">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= averageRating}">
                                    <i class="fas fa-star"></i>
                                </c:when>
                                <c:when test="${i <= averageRating + 0.5}">
                                    <i class="fas fa-star-half-alt"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="far fa-star"></i>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </div>
                <div class="stat-card">
                    <h3>Total Feedback</h3>
                    <div class="number">${feedbackList.size()}</div>
                </div>
                <div class="stat-card">
                    <h3>5-Star Ratings</h3>
                    <div class="number">
                        <c:set var="fiveStarCount" value="0" />
                        <c:forEach var="feedback" items="${feedbackList}">
                            <c:if test="${feedback.rating == 5}">
                                <c:set var="fiveStarCount" value="${fiveStarCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${fiveStarCount}
                    </div>
                </div>
                <div class="stat-card">
                    <h3>Recent Feedback</h3>
                    <div class="number">
                        <c:set var="recentCount" value="0" />
                        <c:forEach var="feedback" items="${feedbackList}">
                            <c:if test="${feedback.createdAt.time > (System.currentTimeMillis() - 7 * 24 * 60 * 60 * 1000)}">
                                <c:set var="recentCount" value="${recentCount + 1}" />
                            </c:if>
                        </c:forEach>
                        ${recentCount}
                    </div>
                    <small>Last 7 days</small>
                </div>
            </div>
            
            <!-- Feedback Rating Filter -->
            <div class="filter-container">
                <form action="${pageContext.request.contextPath}/admin/feedback" method="get">
                    <div class="filter-group">
                        <label for="rating">Filter by Rating:</label>
                        <select id="rating" name="rating" class="form-control" onchange="this.form.submit()">
                            <option value="">All Ratings</option>
                            <option value="5" ${selectedRating eq '5' ? 'selected' : ''}>5 Stars</option>
                            <option value="4" ${selectedRating eq '4' ? 'selected' : ''}>4 Stars</option>
                            <option value="3" ${selectedRating eq '3' ? 'selected' : ''}>3 Stars</option>
                            <option value="2" ${selectedRating eq '2' ? 'selected' : ''}>2 Stars</option>
                            <option value="1" ${selectedRating eq '1' ? 'selected' : ''}>1 Star</option>
                        </select>
                    </div>
                </form>
            </div>
            
            <!-- Feedback List -->
            <div class="feedback-list">
                <c:forEach var="feedback" items="${feedbackList}">
                    <div class="feedback-card">
                        <div class="feedback-card-header">
                            <div class="user-info">
                                <h3>${feedback.userName}</h3>
                            </div>
                            <div class="rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= feedback.rating}">
                                            <i class="fas fa-star rating-stars"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="far fa-star rating-stars"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>
                        <div class="feedback-card-body">
                            <p>${feedback.message}</p>
                        </div>
                        <div class="feedback-card-footer">
                            <div class="date">
                                <i class="far fa-calendar-alt"></i> ${feedback.createdAt}
                            </div>
                            <div class="actions">
                                <a href="${pageContext.request.contextPath}/admin/deleteFeedback?id=${feedback.id}" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure you want to delete this feedback?')"><i class="fas fa-trash"></i> Delete</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty feedbackList}">
                    <div class="no-results">
                        <p>No feedback found.</p>
                    </div>
                </c:if>
            </div>
        </div>
    </section>
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
