package com.hotel.controller;

import com.hotel.model.User;
import com.hotel.model.UserDAO;
import com.hotel.util.FileUploadUtil;
import com.hotel.util.PasswordHasher;
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
 * Controller for user-related operations
 */
@WebServlet(name = "UserController", urlPatterns = {
    "/login", "/logout", "/register",
    "/profile", "/updateProfile", "/updatePassword",
    "/adminpanel", "/admin/users", "/admin/addUser", "/admin/editUser", "/admin/deleteUser"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,    // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class UserController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    /**
     * Set the UserDAO (for testing)
     * @param userDAO The UserDAO to use
     */
    public void setUserDAO(UserDAO userDAO) {
        this.userDAO = userDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/login":
                showLoginForm(request, response);
                break;
            case "/logout":
                logout(request, response);
                break;
            case "/register":
                showRegisterForm(request, response);
                break;
            case "/profile":
                showProfile(request, response);
                break;
            case "/adminpanel":
                showAdminPanel(request, response);
                break;
            case "/admin/users":
                listUsers(request, response);
                break;
            case "/admin/addUser":
                showAddUserForm(request, response);
                break;
            case "/admin/editUser":
                showEditUserForm(request, response);
                break;
            case "/admin/deleteUser":
                deleteUser(request, response);
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
            case "/login":
                login(request, response);
                break;
            case "/adminpanel":
                adminLogin(request, response);
                break;
            case "/register":
                register(request, response);
                break;
            case "/updateProfile":
                updateProfile(request, response);
                break;
            case "/updatePassword":
                updatePassword(request, response);
                break;
            case "/admin/addUser":
                addUser(request, response);
                break;
            case "/admin/editUser":
                editUser(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    /**
     * Show login form
     */
    private void showLoginForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to home page
        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    /**
     * Show admin panel login page
     */
    private void showAdminPanel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in as admin, redirect to admin dashboard
        if (SessionUtil.isLoggedIn(request) && SessionUtil.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }

        // If logged in as regular user, log them out first
        if (SessionUtil.isLoggedIn(request)) {
            SessionUtil.clearLoggedInUser(request);
        }

        request.getRequestDispatcher("/adminpanel.jsp").forward(request, response);
    }

    /**
     * Process login
     */
    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Login attempt - Email: " + email);
        System.out.println("Login attempt - Password: " + (password != null ? "provided" : "null"));

        // Check password length
        if (password == null || password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            System.out.println("Authentication successful for: " + email);
            // Create session
            SessionUtil.setLoggedInUser(request, user);
            System.out.println("Session created for user: " + user.getName() + ", Role: " + user.getRole());

            // Redirect based on role
            if (user.isAdmin()) {
                System.out.println("Redirecting admin to dashboard");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                System.out.println("Redirecting user to index");
                response.sendRedirect(request.getContextPath() + "/index.jsp");
            }
        } else {
            System.out.println("Authentication failed for: " + email);
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    /**
     * Process admin login with simple, non-encrypted credentials
     */
    private void adminLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Admin login attempt - Email: " + email);

        // Simple admin credentials check (no encryption)
        if ("admin@luxuryhotel.com".equals(email) && "admin123".equals(password)) {
            System.out.println("Admin authentication successful using simple credentials");

            // Get the admin user from the database or create a session with admin role
            User adminUser = userDAO.getByEmail(email);

            if (adminUser != null && adminUser.isAdmin()) {
                // If admin exists in database, use that user
                SessionUtil.setLoggedInUser(request, adminUser);
                System.out.println("Admin session created for existing user: " + adminUser.getName());
            } else {
                // Create a temporary admin user for the session
                User tempAdmin = new User();
                tempAdmin.setId(999); // Temporary ID
                tempAdmin.setName("Administrator");
                tempAdmin.setEmail(email);
                tempAdmin.setRole("ADMIN");

                // Create session with admin role
                SessionUtil.setLoggedInUser(request, tempAdmin);
                System.out.println("Admin session created for temporary admin user");
            }

            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        } else {
            // Try the database authentication as fallback
            User user = userDAO.getByEmail(email);

            if (user != null && user.isAdmin() && "admin123".equals(password)) {
                System.out.println("Admin authentication successful using simple password match");
                SessionUtil.setLoggedInUser(request, user);
                response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            } else {
                System.out.println("Admin authentication failed for: " + email);
                request.setAttribute("error", "Invalid admin credentials");
                request.getRequestDispatcher("/adminpanel.jsp").forward(request, response);
            }
        }
    }

    /**
     * Process logout
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        SessionUtil.clearLoggedInUser(request);
        response.sendRedirect(request.getContextPath() + "/login.jsp?message=You have been logged out");
    }

    /**
     * Show register form
     */
    private void showRegisterForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // If already logged in, redirect to home page
        if (SessionUtil.isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    /**
     * Process registration
     */
    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            confirmPassword == null || confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check password length
        if (password.length() < 8) {
            request.setAttribute("error", "Password must be at least 8 characters long");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email is already registered
        if (userDAO.isEmailInUse(email)) {
            request.setAttribute("error", "Email is already registered");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create user
        User user = new User(name, email, password);

        // Upload profile image if provided
        try {
            String profileImage = FileUploadUtil.uploadFile(request, "profileImage", "images");
            if (profileImage != null) {
                user.setProfileImage(profileImage);
            }
        } catch (Exception e) {
            // Ignore if file upload fails
        }

        int userId = userDAO.create(user);

        if (userId > 0) {
            // Create session
            user.setId(userId);
            SessionUtil.setLoggedInUser(request, user);

            response.sendRedirect(request.getContextPath() + "/index.jsp?message=Registration successful");
        } else {
            request.setAttribute("error", "Registration failed");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    /**
     * Show user profile
     */
    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        int userId = SessionUtil.getLoggedInUserId(request);
        User user = userDAO.getById(userId);

        if (user != null) {
            request.setAttribute("user", user);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session expired");
        }
    }

    /**
     * Update user profile
     */
    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        int userId = SessionUtil.getLoggedInUserId(request);
        User user = userDAO.getById(userId);

        if (user != null) {
            String name = request.getParameter("name");
            String email = request.getParameter("email");

            // Validate input
            if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

                request.setAttribute("error", "Name and email are required");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Check if email is already registered by another user
            User existingUser = userDAO.getByEmail(email);
            if (existingUser != null && existingUser.getId() != userId) {
                request.setAttribute("error", "Email is already registered by another user");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Update user
            user.setName(name);
            user.setEmail(email);

            // Upload profile image if provided
            try {
                String profileImage = FileUploadUtil.uploadFile(request, "profileImage", "images");
                if (profileImage != null) {
                    user.setProfileImage(profileImage);
                }
            } catch (Exception e) {
                // Ignore if file upload fails
            }

            boolean updated = userDAO.update(user);

            if (updated) {
                // Update session
                SessionUtil.setLoggedInUser(request, user);

                request.setAttribute("message", "Profile updated successfully");
            } else {
                request.setAttribute("error", "Profile update failed");
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session expired");
        }
    }

    /**
     * Update user password
     */
    private void updatePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        int userId = SessionUtil.getLoggedInUserId(request);
        User user = userDAO.getById(userId);

        if (user != null) {
            String currentPassword = request.getParameter("currentPassword");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");

            // Validate input
            if (currentPassword == null || currentPassword.trim().isEmpty() ||
                newPassword == null || newPassword.trim().isEmpty() ||
                confirmPassword == null || confirmPassword.trim().isEmpty()) {

                request.setAttribute("error", "All password fields are required");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Check password length
            if (newPassword.length() < 8) {
                request.setAttribute("error", "Password must be at least 8 characters long");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "New passwords do not match");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Verify current password
            if (!PasswordHasher.checkPassword(currentPassword, user.getPassword())) {
                request.setAttribute("error", "Current password is incorrect");
                request.setAttribute("user", user);
                request.getRequestDispatcher("/profile.jsp").forward(request, response);
                return;
            }

            // Update password
            boolean updated = userDAO.updatePassword(userId, newPassword);

            if (updated) {
                request.setAttribute("message", "Password updated successfully");
            } else {
                request.setAttribute("error", "Password update failed");
            }

            request.setAttribute("user", user);
            request.getRequestDispatcher("/profile.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Session expired");
        }
    }

    /**
     * List all users (admin only)
     */
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        List<User> users = userDAO.getAll();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
    }

    /**
     * Show add user form (admin only)
     */
    private void showAddUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        request.getRequestDispatcher("/admin/add_user.jsp").forward(request, response);
    }

    /**
     * Add a new user (admin only)
     */
    private void addUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // Validate input
        if (name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            role == null || role.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/admin/add_user.jsp").forward(request, response);
            return;
        }

        // Check if email is already registered
        if (userDAO.isEmailInUse(email)) {
            request.setAttribute("error", "Email is already registered");
            request.getRequestDispatcher("/admin/add_user.jsp").forward(request, response);
            return;
        }

        // Create user
        User user = new User(name, email, password);
        user.setRole(role);

        // Upload profile image if provided
        try {
            String profileImage = FileUploadUtil.uploadFile(request, "profileImage", "images");
            if (profileImage != null) {
                user.setProfileImage(profileImage);
            }
        } catch (Exception e) {
            // Ignore if file upload fails
        }

        int userId = userDAO.create(user);

        if (userId > 0) {
            response.sendRedirect(request.getContextPath() + "/admin/users?message=User added successfully");
        } else {
            request.setAttribute("error", "Failed to add user");
            request.getRequestDispatcher("/admin/add_user.jsp").forward(request, response);
        }
    }

    /**
     * Show edit user form (admin only)
     */
    private void showEditUserForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);
                User user = userDAO.getById(userId);

                if (user != null) {
                    request.setAttribute("user", user);
                    request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
    }

    /**
     * Edit a user (admin only)
     */
    private void editUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);
                User user = userDAO.getById(userId);

                if (user != null) {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String role = request.getParameter("role");
                    String password = request.getParameter("password");

                    // Validate input
                    if (name == null || name.trim().isEmpty() ||
                        email == null || email.trim().isEmpty() ||
                        role == null || role.trim().isEmpty()) {

                        request.setAttribute("error", "Name, email, and role are required");
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
                        return;
                    }

                    // Check if email is already registered by another user
                    User existingUser = userDAO.getByEmail(email);
                    if (existingUser != null && existingUser.getId() != userId) {
                        request.setAttribute("error", "Email is already registered by another user");
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
                        return;
                    }

                    // Update user
                    user.setName(name);
                    user.setEmail(email);
                    user.setRole(role);

                    // Upload profile image if provided
                    try {
                        String profileImage = FileUploadUtil.uploadFile(request, "profileImage", "images");
                        if (profileImage != null) {
                            user.setProfileImage(profileImage);
                        }
                    } catch (Exception e) {
                        // Ignore if file upload fails
                    }

                    boolean updated = userDAO.update(user);

                    // Update password if provided
                    if (password != null && !password.trim().isEmpty()) {
                        userDAO.updatePassword(userId, password);
                    }

                    if (updated) {
                        response.sendRedirect(request.getContextPath() +
                                             "/admin/users?message=User updated successfully");
                    } else {
                        request.setAttribute("error", "Failed to update user");
                        request.setAttribute("user", user);
                        request.getRequestDispatcher("/admin/edit_user.jsp").forward(request, response);
                    }

                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
    }

    /**
     * Delete a user (admin only)
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(idParam);

                // Prevent deleting the current user
                if (userId == SessionUtil.getLoggedInUserId(request)) {
                    response.sendRedirect(request.getContextPath() +
                                         "/admin/users?error=You cannot delete your own account");
                    return;
                }

                boolean deleted = userDAO.delete(userId);

                if (deleted) {
                    response.sendRedirect(request.getContextPath() +
                                         "/admin/users?message=User deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() +
                                         "/admin/users?error=Failed to delete user");
                }

                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?error=User not found");
    }
}
