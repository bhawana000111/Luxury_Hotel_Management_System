package com.hotel.util;

import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet to test BCrypt functionality
 */
@WebServlet("/testBCrypt")
public class BCryptTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>BCrypt Test</title></head><body>");
        out.println("<h1>BCrypt Functionality Test</h1>");
        
        try {
            // Test password
            String password = "admin123";
            out.println("<p>Test password: " + password + "</p>");
            
            // Generate salt
            String salt = BCrypt.gensalt();
            out.println("<p>Generated salt: " + salt + "</p>");
            
            // Hash password
            String hashedPassword = BCrypt.hashpw(password, salt);
            out.println("<p>Hashed password: " + hashedPassword + "</p>");
            
            // Verify password
            boolean passwordMatches = BCrypt.checkpw(password, hashedPassword);
            out.println("<p>Password verification result: " + passwordMatches + "</p>");
            
            if (passwordMatches) {
                out.println("<p style='color:green;font-weight:bold;'>BCrypt is working correctly!</p>");
            } else {
                out.println("<p style='color:red;font-weight:bold;'>BCrypt verification failed!</p>");
            }
            
            // Test with the hash from the database
            String dbHash = "$2a$10$hKDVYxLefVHV/vtuPhWD3OigtRyOykRLDdUAp80Z1crSoS1lFqaFS";
            out.println("<h2>Testing with hash from database</h2>");
            out.println("<p>Database hash: " + dbHash + "</p>");
            
            boolean dbPasswordMatches = BCrypt.checkpw(password, dbHash);
            out.println("<p>Database password verification result: " + dbPasswordMatches + "</p>");
            
            if (dbPasswordMatches) {
                out.println("<p style='color:green;font-weight:bold;'>Password 'admin123' matches the database hash!</p>");
            } else {
                out.println("<p style='color:red;font-weight:bold;'>Password 'admin123' does NOT match the database hash!</p>");
                
                // Try other common passwords
                String[] commonPasswords = {"admin", "password", "123456", "admin123456", "adminadmin"};
                out.println("<h3>Trying other common passwords:</h3>");
                
                for (String commonPassword : commonPasswords) {
                    boolean matches = BCrypt.checkpw(commonPassword, dbHash);
                    out.println("<p>Password '" + commonPassword + "': " + (matches ? 
                        "<span style='color:green;font-weight:bold;'>MATCHES!</span>" : 
                        "<span style='color:red;'>No match</span>") + "</p>");
                }
            }
            
        } catch (Exception e) {
            out.println("<p style='color:red;font-weight:bold;'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}
