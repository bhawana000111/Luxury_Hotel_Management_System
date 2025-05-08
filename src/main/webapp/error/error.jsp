<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Error</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .error-container {
            text-align: center;
            padding: 100px 0;
        }
        
        .error-icon {
            font-size: 80px;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 24px;
            margin-bottom: 30px;
        }
        
        .error-details {
            margin-bottom: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 5px;
            text-align: left;
        }
        
        .error-actions {
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../partials/header.jsp" />
    
    <!-- Error Section -->
    <section class="section">
        <div class="container">
            <div class="error-container">
                <div class="error-icon">
                    <i class="fas fa-exclamation-triangle"></i>
                </div>
                <div class="error-message">An Error Occurred</div>
                <p>Sorry, something went wrong. Please try again later or contact our support team.</p>
                
                <% if (exception != null && request.getRemoteAddr().equals("127.0.0.1")) { %>
                    <div class="error-details">
                        <h3>Error Details (Visible only in development environment):</h3>
                        <p><strong>Error Type:</strong> <%= exception.getClass().getName() %></p>
                        <p><strong>Message:</strong> <%= exception.getMessage() %></p>
                        <p><strong>Stack Trace:</strong></p>
                        <pre>
                            <% for (StackTraceElement element : exception.getStackTrace()) { %>
                                <%= element.toString() %>
                            <% } %>
                        </pre>
                    </div>
                <% } %>
                
                <div class="error-actions">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Go to Homepage</a>
                    <a href="${pageContext.request.contextPath}/contact.jsp" class="btn btn-secondary">Contact Support</a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="../partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
