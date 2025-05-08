<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Session Debug - Luxury Hotel</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .debug-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 30px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .debug-title {
            text-align: center;
            margin-bottom: 30px;
            color: #5a3921;
        }
        
        .debug-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .debug-section h3 {
            margin-bottom: 15px;
            color: #5a3921;
        }
        
        .debug-table {
            width: 100%;
            border-collapse: collapse;
        }
        
        .debug-table th, .debug-table td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        
        .debug-table th {
            background-color: #f9f7f4;
            font-weight: 600;
            color: #5a3921;
        }
        
        .debug-table tr:hover {
            background-color: #f9f7f4;
        }
        
        .debug-info {
            background-color: #f9f7f4;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 15px;
        }
        
        .debug-info p {
            margin: 5px 0;
        }
        
        .debug-actions {
            margin-top: 30px;
            text-align: center;
        }
        
        .debug-actions .btn {
            margin: 0 10px;
        }
        
        .session-id {
            font-family: monospace;
            background-color: #f1f1f1;
            padding: 5px 10px;
            border-radius: 3px;
        }
        
        .no-session {
            color: #d9534f;
            font-style: italic;
        }
        
        .has-session {
            color: #5cb85c;
            font-weight: 500;
        }
    </style>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="partials/header.jsp" />
    
    <div class="debug-container">
        <h1 class="debug-title">Session Debug Information</h1>
        
        <div class="debug-section">
            <h3>Session Status</h3>
            <div class="debug-info">
                <% if (session != null && !session.isNew()) { %>
                    <p class="has-session"><i class="fas fa-check-circle"></i> Active session found</p>
                    <p>Session ID: <span class="session-id"><%= session.getId() %></span></p>
                    <p>Creation Time: <%= new java.util.Date(session.getCreationTime()) %></p>
                    <p>Last Accessed: <%= new java.util.Date(session.getLastAccessedTime()) %></p>
                    <p>Max Inactive Interval: <%= session.getMaxInactiveInterval() %> seconds</p>
                <% } else { %>
                    <p class="no-session"><i class="fas fa-exclamation-circle"></i> No active session found</p>
                <% } %>
            </div>
        </div>
        
        <div class="debug-section">
            <h3>Session Attributes</h3>
            <table class="debug-table">
                <thead>
                    <tr>
                        <th>Attribute Name</th>
                        <th>Attribute Value</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                    if (session != null) {
                        Enumeration<String> attributeNames = session.getAttributeNames();
                        if (!attributeNames.hasMoreElements()) {
                    %>
                        <tr>
                            <td colspan="2" style="text-align: center;">No session attributes found</td>
                        </tr>
                    <% 
                        } else {
                            while (attributeNames.hasMoreElements()) {
                                String name = attributeNames.nextElement();
                                Object value = session.getAttribute(name);
                    %>
                        <tr>
                            <td><%= name %></td>
                            <td><%= value != null ? value.toString() : "null" %></td>
                        </tr>
                    <% 
                            }
                        }
                    } else {
                    %>
                        <tr>
                            <td colspan="2" style="text-align: center;">No session available</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
        
        <div class="debug-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">Return to Home</a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary">Go to Login</a>
            <% if (session != null && !session.isNew()) { %>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger">Logout (Clear Session)</a>
            <% } %>
        </div>
    </div>
    
    <!-- Include Footer -->
    <jsp:include page="partials/footer.jsp" />
</body>
</html>
