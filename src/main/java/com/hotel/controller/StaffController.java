package com.hotel.controller;

import com.hotel.model.Staff;
import com.hotel.model.StaffDAO;
import com.hotel.util.FileUploadUtil;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for staff-related operations
 */
@WebServlet(name = "StaffController", urlPatterns = {
    "/staff", "/admin/staff", "/admin/addStaff", "/admin/editStaff", "/admin/deleteStaff"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,    // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class StaffController extends HttpServlet {
    
    private StaffDAO staffDAO;
    
    @Override
    public void init() {
        staffDAO = new StaffDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/staff":
                listStaffForGuests(request, response);
                break;
            case "/admin/staff":
                listStaffForAdmin(request, response);
                break;
            case "/admin/addStaff":
                showAddStaffForm(request, response);
                break;
            case "/admin/editStaff":
                showEditStaffForm(request, response);
                break;
            case "/admin/deleteStaff":
                deleteStaff(request, response);
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
            case "/admin/addStaff":
                addStaff(request, response);
                break;
            case "/admin/editStaff":
                editStaff(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    /**
     * List all staff for guests
     */
    private void listStaffForGuests(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String roleParam = request.getParameter("role");
        List<Staff> staffList;
        
        if (roleParam != null && !roleParam.trim().isEmpty()) {
            staffList = staffDAO.getAllByRole(roleParam);
            request.setAttribute("selectedRole", roleParam);
        } else {
            staffList = staffDAO.getAll();
        }
        
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/staff.jsp").forward(request, response);
    }
    
    /**
     * List all staff for admin
     */
    private void listStaffForAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String roleParam = request.getParameter("role");
        List<Staff> staffList;
        
        if (roleParam != null && !roleParam.trim().isEmpty()) {
            staffList = staffDAO.getAllByRole(roleParam);
            request.setAttribute("selectedRole", roleParam);
        } else {
            staffList = staffDAO.getAll();
        }
        
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("/admin/staff.jsp").forward(request, response);
    }
    
    /**
     * Show add staff form (admin only)
     */
    private void showAddStaffForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        request.getRequestDispatcher("/admin/add_staff.jsp").forward(request, response);
    }
    
    /**
     * Add a new staff member (admin only)
     */
    private void addStaff(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String name = request.getParameter("name");
        String role = request.getParameter("role");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Validate input
        if (name == null || name.trim().isEmpty() ||
            role == null || role.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            phone == null || phone.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/admin/add_staff.jsp").forward(request, response);
            return;
        }
        
        // Check if email is already registered
        if (staffDAO.isEmailRegistered(email)) {
            request.setAttribute("error", "Email is already registered");
            request.getRequestDispatcher("/admin/add_staff.jsp").forward(request, response);
            return;
        }
        
        // Create staff member
        Staff staff = new Staff(name, role, email, phone);
        
        // Upload staff image if provided
        try {
            String imagePath = FileUploadUtil.uploadFile(request, "staffImage", "images");
            if (imagePath != null) {
                staff.setImagePath(imagePath);
            }
        } catch (Exception e) {
            // Ignore if file upload fails
        }
        
        int staffId = staffDAO.create(staff);
        
        if (staffId > 0) {
            response.sendRedirect(request.getContextPath() + 
                                 "/admin/staff?message=Staff member added successfully");
        } else {
            request.setAttribute("error", "Failed to add staff member");
            request.getRequestDispatcher("/admin/add_staff.jsp").forward(request, response);
        }
    }
    
    /**
     * Show edit staff form (admin only)
     */
    private void showEditStaffForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int staffId = Integer.parseInt(idParam);
                Staff staff = staffDAO.getById(staffId);
                
                if (staff != null) {
                    request.setAttribute("staff", staff);
                    request.getRequestDispatcher("/admin/edit_staff.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/staff?error=Staff member not found");
    }
    
    /**
     * Edit a staff member (admin only)
     */
    private void editStaff(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int staffId = Integer.parseInt(idParam);
                Staff staff = staffDAO.getById(staffId);
                
                if (staff != null) {
                    String name = request.getParameter("name");
                    String role = request.getParameter("role");
                    String email = request.getParameter("email");
                    String phone = request.getParameter("phone");
                    
                    // Validate input
                    if (name == null || name.trim().isEmpty() ||
                        role == null || role.trim().isEmpty() ||
                        email == null || email.trim().isEmpty() ||
                        phone == null || phone.trim().isEmpty()) {
                        
                        request.setAttribute("error", "All fields are required");
                        request.setAttribute("staff", staff);
                        request.getRequestDispatcher("/admin/edit_staff.jsp").forward(request, response);
                        return;
                    }
                    
                    // Check if email is already registered by another staff member
                    Staff existingStaff = staffDAO.getByEmail(email);
                    if (existingStaff != null && existingStaff.getId() != staffId) {
                        request.setAttribute("error", "Email is already registered by another staff member");
                        request.setAttribute("staff", staff);
                        request.getRequestDispatcher("/admin/edit_staff.jsp").forward(request, response);
                        return;
                    }
                    
                    // Update staff member
                    staff.setName(name);
                    staff.setRole(role);
                    staff.setEmail(email);
                    staff.setPhone(phone);
                    
                    // Upload staff image if provided
                    try {
                        String imagePath = FileUploadUtil.uploadFile(request, "staffImage", "images");
                        if (imagePath != null) {
                            staff.setImagePath(imagePath);
                        }
                    } catch (Exception e) {
                        // Ignore if file upload fails
                    }
                    
                    boolean updated = staffDAO.update(staff);
                    
                    if (updated) {
                        response.sendRedirect(request.getContextPath() + 
                                             "/admin/staff?message=Staff member updated successfully");
                    } else {
                        request.setAttribute("error", "Failed to update staff member");
                        request.setAttribute("staff", staff);
                        request.getRequestDispatcher("/admin/edit_staff.jsp").forward(request, response);
                    }
                    
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/staff?error=Staff member not found");
    }
    
    /**
     * Delete a staff member (admin only)
     */
    private void deleteStaff(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int staffId = Integer.parseInt(idParam);
                boolean deleted = staffDAO.delete(staffId);
                
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/staff?message=Staff member deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/staff?error=Failed to delete staff member");
                }
                
                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/staff?error=Staff member not found");
    }
}
