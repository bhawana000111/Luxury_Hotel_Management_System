package com.hotel.controller;

import com.hotel.model.Feedback;
import com.hotel.model.FeedbackDAO;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for feedback-related operations
 */
@WebServlet(name = "FeedbackController", urlPatterns = {
    "/feedback", "/submitFeedback", "/admin/feedback", "/admin/deleteFeedback"
})
public class FeedbackController extends HttpServlet {
    
    private FeedbackDAO feedbackDAO;
    
    @Override
    public void init() {
        feedbackDAO = new FeedbackDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/feedback":
                showFeedbackForm(request, response);
                break;
            case "/admin/feedback":
                listFeedback(request, response);
                break;
            case "/admin/deleteFeedback":
                deleteFeedback(request, response);
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
            case "/submitFeedback":
                submitFeedback(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    /**
     * Show feedback form
     */
    private void showFeedbackForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }
        
        request.getRequestDispatcher("/feedback.jsp").forward(request, response);
    }
    
    /**
     * Submit feedback
     */
    private void submitFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }
        
        String message = request.getParameter("message");
        String ratingParam = request.getParameter("rating");
        
        // Validate input
        if (message == null || message.trim().isEmpty() ||
            ratingParam == null || ratingParam.trim().isEmpty()) {
            
            request.setAttribute("error", "Message and rating are required");
            request.getRequestDispatcher("/feedback.jsp").forward(request, response);
            return;
        }
        
        try {
            int rating = Integer.parseInt(ratingParam);
            
            // Validate rating
            if (rating < 1 || rating > 5) {
                request.setAttribute("error", "Rating must be between 1 and 5");
                request.getRequestDispatcher("/feedback.jsp").forward(request, response);
                return;
            }
            
            // Create feedback
            int userId = SessionUtil.getLoggedInUserId(request);
            Feedback feedback = new Feedback(userId, message, rating);
            
            int feedbackId = feedbackDAO.create(feedback);
            
            if (feedbackId > 0) {
                response.sendRedirect(request.getContextPath() + 
                                     "/index.jsp?message=Thank you for your feedback");
            } else {
                request.setAttribute("error", "Failed to submit feedback");
                request.getRequestDispatcher("/feedback.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid rating format");
            request.getRequestDispatcher("/feedback.jsp").forward(request, response);
        }
    }
    
    /**
     * List all feedback (admin only)
     */
    private void listFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String ratingParam = request.getParameter("rating");
        List<Feedback> feedbackList;
        
        if (ratingParam != null && !ratingParam.trim().isEmpty()) {
            try {
                int rating = Integer.parseInt(ratingParam);
                feedbackList = feedbackDAO.getAllByRating(rating);
                request.setAttribute("selectedRating", rating);
            } catch (NumberFormatException e) {
                feedbackList = feedbackDAO.getAll();
            }
        } else {
            feedbackList = feedbackDAO.getAll();
        }
        
        double averageRating = feedbackDAO.getAverageRating();
        
        request.setAttribute("feedbackList", feedbackList);
        request.setAttribute("averageRating", averageRating);
        request.getRequestDispatcher("/admin/feedback.jsp").forward(request, response);
    }
    
    /**
     * Delete feedback (admin only)
     */
    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int feedbackId = Integer.parseInt(idParam);
                boolean deleted = feedbackDAO.delete(feedbackId);
                
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/feedback?message=Feedback deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/feedback?error=Failed to delete feedback");
                }
                
                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/feedback?error=Feedback not found");
    }
}
