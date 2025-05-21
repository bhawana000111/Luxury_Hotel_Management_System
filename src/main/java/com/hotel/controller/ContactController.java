package com.hotel.controller;

import com.hotel.model.Contact;
import com.hotel.model.ContactDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for contact-related operations
 */
@WebServlet(name = "ContactController", urlPatterns = {
    "/contact", "/submitContact", "/admin/contacts", "/admin/deleteContact"
})
public class ContactController extends HttpServlet {
    
    private ContactDAO contactDAO;
    
    @Override
    public void init() {
        contactDAO = new ContactDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/contact":
                showContactForm(request, response);
                break;
            case "/admin/contacts":
                listContacts(request, response);
                break;
            case "/admin/deleteContact":
                deleteContact(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/submitContact":
                submitContact(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    /**
     * Show contact form
     */
    private void showContactForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/contact.jsp").forward(request, response);
    }
    
    /**
     * Submit contact form
     */
    private void submitContact(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");
        
        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            subject == null || subject.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
            return;
        }
        
        // Create contact
        Contact contact = new Contact(name, email, subject, message);
        
        int contactId = contactDAO.create(contact);
        
        if (contactId > 0) {
            // Set success message and forward to thank you page
            request.setAttribute("success", true);
            request.setAttribute("name", name);
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to submit your message. Please try again later.");
            request.getRequestDispatcher("/contact.jsp").forward(request, response);
        }
    }
    
    /**
     * List all contacts (admin only)
     */
    private void listContacts(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is admin (you should implement this check)
        // if (!isAdmin(request)) {
        //     response.sendRedirect(request.getContextPath() + "/login");
        //     return;
        // }
        
        List<Contact> contacts = contactDAO.getAll();
        request.setAttribute("contacts", contacts);
        request.getRequestDispatcher("/admin/contacts.jsp").forward(request, response);
    }
    
    /**
     * Delete a contact (admin only)
     */
    private void deleteContact(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check if user is admin (you should implement this check)
        // if (!isAdmin(request)) {
        //     response.sendRedirect(request.getContextPath() + "/login");
        //     return;
        // }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int contactId = Integer.parseInt(idParam);
                boolean deleted = contactDAO.delete(contactId);
                
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/contacts?message=Contact deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/contacts?error=Failed to delete contact");
                }
                
                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/contacts?error=Invalid contact ID");
    }
}
