<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hotel.model.User" %>
<%@ page import="com.hotel.model.UserDAO" %>
<%@ page import="com.hotel.util.PasswordHasher" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Login Test</title>
</head>
<body>
    <h1>Admin Login Test</h1>
    
    <%
        // Test admin login
        String email = "admin@luxuryhotel.com";
        String password = "admin123";
        
        out.println("<p>Testing login with:</p>");
        out.println("<p>Email: " + email + "</p>");
        out.println("<p>Password: " + password + "</p>");
        
        UserDAO userDAO = new UserDAO();
        
        // Get user by email
        User user = userDAO.getByEmail(email);
        
        if (user != null) {
            out.println("<p>User found in database:</p>");
            out.println("<p>ID: " + user.getId() + "</p>");
            out.println("<p>Name: " + user.getName() + "</p>");
            out.println("<p>Email: " + user.getEmail() + "</p>");
            out.println("<p>Role: " + user.getRole() + "</p>");
            out.println("<p>Password Hash: " + user.getPassword() + "</p>");
            
            // Check password
            boolean passwordMatches = PasswordHasher.checkPassword(password, user.getPassword());
            out.println("<p>Password match: " + passwordMatches + "</p>");
            
            if (passwordMatches) {
                out.println("<p style='color:green;font-weight:bold;'>Authentication successful!</p>");
            } else {
                out.println("<p style='color:red;font-weight:bold;'>Authentication failed: Password does not match</p>");
            }
        } else {
            out.println("<p style='color:red;font-weight:bold;'>Authentication failed: User not found</p>");
        }
    %>
    
    <h2>Try Manual Login</h2>
    <form action="${pageContext.request.contextPath}/login" method="post">
        <div>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="admin@luxuryhotel.com">
        </div>
        <div>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" value="admin123">
        </div>
        <div>
            <button type="submit">Login</button>
        </div>
    </form>
</body>
</html>
