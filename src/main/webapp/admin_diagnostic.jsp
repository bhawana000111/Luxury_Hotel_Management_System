<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hotel.model.User" %>
<%@ page import="com.hotel.model.UserDAO" %>
<%@ page import="com.hotel.util.PasswordHasher" %>
<%@ page import="com.hotel.util.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Diagnostic</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1, h2 { color: #333; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .section { margin-bottom: 30px; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        pre { background-color: #f5f5f5; padding: 10px; border-radius: 5px; overflow-x: auto; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        form { margin-top: 20px; }
        input, button { padding: 8px; margin: 5px 0; }
    </style>
</head>
<body>
    <h1>Admin Diagnostic Page</h1>
    
    <div class="section">
        <h2>1. Database Connection Test</h2>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                out.println("<p class='success'>Database connection successful!</p>");
                out.println("<p>Connection URL: " + DBConnection.getURL() + "</p>");
                out.println("<p>Database User: " + DBConnection.getUSER() + "</p>");
                conn.close();
            } catch (Exception e) {
                out.println("<p class='error'>Database connection failed: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </div>
    
    <div class="section">
        <h2>2. Users Table Check</h2>
        <%
            try {
                Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM users");
                
                out.println("<p class='success'>Users table exists and is accessible.</p>");
                
                // Get column metadata
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                
                out.println("<h3>Table Structure:</h3>");
                out.println("<table>");
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<th>" + metaData.getColumnName(i) + " (" + metaData.getColumnTypeName(i) + ")</th>");
                }
                out.println("</tr>");
                
                // Display data
                out.println("<h3>Table Data:</h3>");
                out.println("<table>");
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<th>" + metaData.getColumnName(i) + "</th>");
                }
                out.println("</tr>");
                
                int rowCount = 0;
                while (rs.next()) {
                    rowCount++;
                    out.println("<tr>");
                    for (int i = 1; i <= columnCount; i++) {
                        String value = rs.getString(i);
                        // Truncate password for security
                        if (metaData.getColumnName(i).equalsIgnoreCase("password") && value != null) {
                            value = value.substring(0, Math.min(20, value.length())) + "...";
                        }
                        out.println("<td>" + (value == null ? "NULL" : value) + "</td>");
                    }
                    out.println("</tr>");
                }
                out.println("</table>");
                
                out.println("<p>Total rows: " + rowCount + "</p>");
                
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.println("<p class='error'>Error accessing users table: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </div>
    
    <div class="section">
        <h2>3. Admin User Check</h2>
        <%
            try {
                UserDAO userDAO = new UserDAO();
                User adminUser = userDAO.getByEmail("admin@luxuryhotel.com");
                
                if (adminUser != null) {
                    out.println("<p class='success'>Admin user found!</p>");
                    out.println("<p>ID: " + adminUser.getId() + "</p>");
                    out.println("<p>Name: " + adminUser.getName() + "</p>");
                    out.println("<p>Email: " + adminUser.getEmail() + "</p>");
                    out.println("<p>Role: " + adminUser.getRole() + "</p>");
                    out.println("<p>Password Hash: " + adminUser.getPassword() + "</p>");
                    
                    // Test password
                    boolean passwordMatches = PasswordHasher.checkPassword("admin123", adminUser.getPassword());
                    if (passwordMatches) {
                        out.println("<p class='success'>Password 'admin123' matches the stored hash!</p>");
                    } else {
                        out.println("<p class='error'>Password 'admin123' does NOT match the stored hash!</p>");
                    }
                } else {
                    out.println("<p class='error'>Admin user not found with email: admin@luxuryhotel.com</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error checking admin user: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </div>
    
    <div class="section">
        <h2>4. Password Hashing Test</h2>
        <%
            try {
                String testPassword = "admin123";
                String hashedPassword = PasswordHasher.hashPassword(testPassword);
                
                out.println("<p>Original Password: " + testPassword + "</p>");
                out.println("<p>Hashed Password: " + hashedPassword + "</p>");
                
                boolean passwordMatches = PasswordHasher.checkPassword(testPassword, hashedPassword);
                if (passwordMatches) {
                    out.println("<p class='success'>Password verification successful!</p>");
                } else {
                    out.println("<p class='error'>Password verification failed!</p>");
                }
            } catch (Exception e) {
                out.println("<p class='error'>Error testing password hashing: " + e.getMessage() + "</p>");
                e.printStackTrace(new java.io.PrintWriter(out));
            }
        %>
    </div>
    
    <div class="section">
        <h2>5. Create New Admin User</h2>
        <form method="post" action="">
            <div>
                <label for="name">Name:</label>
                <input type="text" id="name" name="name" value="New Admin" required>
            </div>
            <div>
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="newadmin@luxuryhotel.com" required>
            </div>
            <div>
                <label for="password">Password:</label>
                <input type="text" id="password" name="password" value="admin123" required>
            </div>
            <button type="submit" name="createAdmin">Create Admin User</button>
        </form>
        
        <%
            if (request.getParameter("createAdmin") != null) {
                try {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    
                    UserDAO userDAO = new UserDAO();
                    
                    // Check if user already exists
                    User existingUser = userDAO.getByEmail(email);
                    if (existingUser != null) {
                        out.println("<p class='error'>User already exists with email: " + email + "</p>");
                    } else {
                        // Create new admin user
                        User newAdmin = new User(name, email, password);
                        newAdmin.setRole("ADMIN");
                        
                        int userId = userDAO.create(newAdmin);
                        
                        if (userId > 0) {
                            out.println("<p class='success'>Admin user created successfully!</p>");
                            out.println("<p>User ID: " + userId + "</p>");
                            out.println("<p>Email: " + email + "</p>");
                            out.println("<p>Password: " + password + "</p>");
                            out.println("<p><a href='" + request.getContextPath() + "/login'>Go to Login Page</a></p>");
                        } else {
                            out.println("<p class='error'>Failed to create admin user</p>");
                        }
                    }
                } catch (Exception e) {
                    out.println("<p class='error'>Error creating admin user: " + e.getMessage() + "</p>");
                    e.printStackTrace(new java.io.PrintWriter(out));
                }
            }
        %>
    </div>
    
    <div class="section">
        <h2>6. Manual Login Form</h2>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <div>
                <label for="loginEmail">Email:</label>
                <input type="email" id="loginEmail" name="email" value="admin@luxuryhotel.com" required>
            </div>
            <div>
                <label for="loginPassword">Password:</label>
                <input type="password" id="loginPassword" name="password" value="admin123" required>
            </div>
            <button type="submit">Login</button>
        </form>
    </div>
</body>
</html>
