<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Luxury Hotel - Page Not Found</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .error-container {
            text-align: center;
            padding: 100px 0;
        }
        
        .error-code {
            font-size: 120px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 20px;
        }
        
        .error-message {
            font-size: 24px;
            margin-bottom: 30px;
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
                <div class="error-code">404</div>
                <div class="error-message">Page Not Found</div>
                <p>The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
                <div class="error-actions">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-primary">Go to Homepage</a>
                </div>
            </div>
        </div>
    </section>
    
    <!-- Include Footer -->
    <jsp:include page="../partials/footer.jsp" />
    
    <script src="${pageContext.request.contextPath}/assets/js/script.js"></script>
</body>
</html>
