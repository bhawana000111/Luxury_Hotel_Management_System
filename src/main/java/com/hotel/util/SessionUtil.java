package com.hotel.util;

import com.hotel.model.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Utility class for session management
 */
public class SessionUtil {

    private static final int SESSION_TIMEOUT = 30 * 60; // 30 minutes in seconds

    /**
     * Create a new session for a user
     * @param request The HttpServletRequest
     * @param userId The user ID
     * @param userName The user name
     * @param userEmail The user email
     * @param userRole The user role
     */
    public static void createUserSession(HttpServletRequest request,
                                        int userId,
                                        String userName,
                                        String userEmail,
                                        String userRole) {
        HttpSession session = request.getSession(true);
        session.setAttribute("userId", userId);
        session.setAttribute("userName", userName);
        session.setAttribute("userEmail", userEmail);
        session.setAttribute("userRole", userRole);
        session.setMaxInactiveInterval(SESSION_TIMEOUT);
    }

    /**
     * Check if a user is logged in
     * @param request The HttpServletRequest
     * @return True if the user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("userId") != null;
    }

    /**
     * Check if the logged-in user is an admin
     * @param request The HttpServletRequest
     * @return True if the user is an admin, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            return false;
        }

        return "ADMIN".equals(session.getAttribute("userRole"));
    }

    /**
     * Get the ID of the logged-in user
     * @param request The HttpServletRequest
     * @return The user ID, or -1 if not logged in
     */
    public static int getLoggedInUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            return -1;
        }

        return (int) session.getAttribute("userId");
    }

    /**
     * Invalidate the user session (logout)
     * @param request The HttpServletRequest
     */
    public static void invalidateUserSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * Set the logged-in user in the session
     * @param request The HttpServletRequest
     * @param user The user to set in the session
     */
    public static void setLoggedInUser(HttpServletRequest request, User user) {
        createUserSession(request, user.getId(), user.getName(), user.getEmail(), user.getRole());
    }

    /**
     * Clear the logged-in user from the session (logout)
     * @param request The HttpServletRequest
     */
    public static void clearLoggedInUser(HttpServletRequest request) {
        invalidateUserSession(request);
    }

    /**
     * Redirect to login page if not logged in
     * @param request The HttpServletRequest
     * @param response The HttpServletResponse
     * @return True if the user is logged in, false if redirected
     * @throws IOException If an I/O error occurs
     */
    public static boolean requireLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login to continue");
            return false;
        }

        return true;
    }

    /**
     * Redirect to admin login page if not an admin
     * @param request The HttpServletRequest
     * @param response The HttpServletResponse
     * @return True if the user is an admin, false if redirected
     * @throws IOException If an I/O error occurs
     */
    public static boolean requireAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdmin(request)) {
            // Redirect to the hidden admin panel login page
            response.sendRedirect(request.getContextPath() + "/adminpanel?error=Please login as admin to continue");
            return false;
        }

        return true;
    }
}
