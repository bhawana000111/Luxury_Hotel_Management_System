package com.hotel.util;

import com.hotel.model.User;
import com.hotel.model.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet to create a new admin user
 */
@WebServlet("/createAdmin")
public class CreateAdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Create Admin</title></head><body>");
        out.println("<h1>Creating Admin User</h1>");
        
        try {
            // Create a new admin user
            User admin = new User("Admin User", "admin2@luxuryhotel.com", "admin123");
            admin.setRole("ADMIN");
            
            UserDAO userDAO = new UserDAO();
            
            // Check if user already exists
            User existingUser = userDAO.getByEmail(admin.getEmail());
            if (existingUser != null) {
                out.println("<p>Admin user already exists with email: " + admin.getEmail() + "</p>");
                out.println("<p>User ID: " + existingUser.getId() + "</p>");
                out.println("<p>User Role: " + existingUser.getRole() + "</p>");
            } else {
                // Create the user
                int userId = userDAO.create(admin);
                
                if (userId > 0) {
                    out.println("<p style='color:green'>Admin user created successfully!</p>");
                    out.println("<p>User ID: " + userId + "</p>");
                    out.println("<p>Email: " + admin.getEmail() + "</p>");
                    out.println("<p>Password: admin123</p>");
                } else {
                    out.println("<p style='color:red'>Failed to create admin user</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("<h2>Try logging in with:</h2>");
        out.println("<p>Email: admin2@luxuryhotel.com</p>");
        out.println("<p>Password: admin123</p>");
        
        out.println("<a href='" + request.getContextPath() + "/login'>Go to Login Page</a>");
        
        out.println("</body></html>");
    }
}
