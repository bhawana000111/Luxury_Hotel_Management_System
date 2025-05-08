package com.hotel.controller;

import com.hotel.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Test servlet to verify database connection
 */
@WebServlet(name = "TestServlet", urlPatterns = {"/test"})
public class TestServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Database Connection Test</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }");
            out.println(".container { max-width: 800px; margin: 0 auto; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }");
            out.println(".success { color: green; }");
            out.println(".error { color: red; }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='container'>");
            out.println("<h1>Database Connection Test</h1>");
            
            try {
                Connection conn = DBConnection.getConnection();
                out.println("<p class='success'>✅ Database connection successful!</p>");
                out.println("<p>Connection URL: " + DBConnection.getURL() + "</p>");
                out.println("<p>Database User: " + DBConnection.getUSER() + "</p>");
                DBConnection.closeConnection(conn);
            } catch (SQLException e) {
                out.println("<p class='error'>❌ Database connection failed: " + e.getMessage() + "</p>");
                out.println("<h2>Troubleshooting:</h2>");
                out.println("<ol>");
                out.println("<li>Make sure MySQL server is running</li>");
                out.println("<li>Verify database 'hotel_db' exists</li>");
                out.println("<li>Check that user 'hotel_user' exists with password 'hotel_password'</li>");
                out.println("<li>Ensure user has proper permissions on the database</li>");
                out.println("</ol>");
            }
            
            out.println("<p><a href='index.jsp'>Back to Home</a></p>");
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        }
    }
}
