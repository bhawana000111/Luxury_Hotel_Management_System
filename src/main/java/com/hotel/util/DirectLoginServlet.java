package com.hotel.util;

import com.hotel.model.User;
import com.hotel.model.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

/**
 * Servlet to directly log in as admin (for testing purposes)
 */
@WebServlet("/directLogin")
public class DirectLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<html><head><title>Direct Login</title></head><body>");
        out.println("<h1>Direct Admin Login</h1>");
        
        try {
            UserDAO userDAO = new UserDAO();
            User adminUser = userDAO.getByEmail("admin@luxuryhotel.com");
            
            if (adminUser != null) {
                // Create session directly
                HttpSession session = request.getSession(true);
                session.setAttribute("userId", adminUser.getId());
                session.setAttribute("userName", adminUser.getName());
                session.setAttribute("userEmail", adminUser.getEmail());
                session.setAttribute("userRole", adminUser.getRole());
                
                out.println("<p style='color:green'>Admin session created successfully!</p>");
                out.println("<p>User ID: " + adminUser.getId() + "</p>");
                out.println("<p>Name: " + adminUser.getName() + "</p>");
                out.println("<p>Email: " + adminUser.getEmail() + "</p>");
                out.println("<p>Role: " + adminUser.getRole() + "</p>");
                
                out.println("<p><a href='" + request.getContextPath() + "/admin/dashboard.jsp'>Go to Admin Dashboard</a></p>");
            } else {
                out.println("<p style='color:red'>Admin user not found!</p>");
                
                // Try to create a new admin user
                User newAdmin = new User("Direct Admin", "directadmin@luxuryhotel.com", "admin123");
                newAdmin.setRole("ADMIN");
                
                int userId = userDAO.create(newAdmin);
                
                if (userId > 0) {
                    newAdmin.setId(userId);
                    
                    // Create session for the new admin
                    HttpSession session = request.getSession(true);
                    session.setAttribute("userId", newAdmin.getId());
                    session.setAttribute("userName", newAdmin.getName());
                    session.setAttribute("userEmail", newAdmin.getEmail());
                    session.setAttribute("userRole", newAdmin.getRole());
                    
                    out.println("<p style='color:green'>New admin user created and session established!</p>");
                    out.println("<p>User ID: " + newAdmin.getId() + "</p>");
                    out.println("<p>Email: " + newAdmin.getEmail() + "</p>");
                    out.println("<p>Password: admin123</p>");
                    
                    out.println("<p><a href='" + request.getContextPath() + "/admin/dashboard.jsp'>Go to Admin Dashboard</a></p>");
                } else {
                    out.println("<p style='color:red'>Failed to create new admin user</p>");
                }
            }
        } catch (Exception e) {
            out.println("<p style='color:red'>Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
        
        out.println("</body></html>");
    }
}
