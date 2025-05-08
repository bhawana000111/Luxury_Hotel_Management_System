package com.hotel.model;

import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Feedback entity
 */
public class FeedbackDAO {
    
    /**
     * Create a new feedback
     * @param feedback The feedback to create
     * @return The ID of the created feedback, or -1 if creation failed
     */
    public int create(Feedback feedback) {
        String sql = "INSERT INTO feedback (user_id, message, rating) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, feedback.getUserId());
            stmt.setString(2, feedback.getMessage());
            stmt.setInt(3, feedback.getRating());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows == 0) {
                return -1;
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    /**
     * Get a feedback by ID
     * @param id The feedback ID
     * @return The feedback, or null if not found
     */
    public Feedback getById(int id) {
        String sql = "SELECT f.*, u.name as user_name FROM feedback f " +
                     "JOIN users u ON f.user_id = u.id " +
                     "WHERE f.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Get all feedback
     * @return A list of all feedback
     */
    public List<Feedback> getAll() {
        String sql = "SELECT f.*, u.name as user_name FROM feedback f " +
                     "JOIN users u ON f.user_id = u.id " +
                     "ORDER BY f.created_at DESC";
        List<Feedback> feedbackList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                feedbackList.add(mapResultSetToFeedback(rs));
            }
            
            return feedbackList;
        } catch (SQLException e) {
            e.printStackTrace();
            return feedbackList;
        }
    }
    
    /**
     * Get all feedback by user ID
     * @param userId The user ID
     * @return A list of all feedback for the specified user
     */
    public List<Feedback> getAllByUserId(int userId) {
        String sql = "SELECT f.*, u.name as user_name FROM feedback f " +
                     "JOIN users u ON f.user_id = u.id " +
                     "WHERE f.user_id = ? " +
                     "ORDER BY f.created_at DESC";
        List<Feedback> feedbackList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapResultSetToFeedback(rs));
                }
            }
            
            return feedbackList;
        } catch (SQLException e) {
            e.printStackTrace();
            return feedbackList;
        }
    }
    
    /**
     * Get all feedback by rating
     * @param rating The rating
     * @return A list of all feedback with the specified rating
     */
    public List<Feedback> getAllByRating(int rating) {
        String sql = "SELECT f.*, u.name as user_name FROM feedback f " +
                     "JOIN users u ON f.user_id = u.id " +
                     "WHERE f.rating = ? " +
                     "ORDER BY f.created_at DESC";
        List<Feedback> feedbackList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, rating);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapResultSetToFeedback(rs));
                }
            }
            
            return feedbackList;
        } catch (SQLException e) {
            e.printStackTrace();
            return feedbackList;
        }
    }
    
    /**
     * Get average rating
     * @return The average rating, or 0 if no feedback exists
     */
    public double getAverageRating() {
        String sql = "SELECT AVG(rating) FROM feedback";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            if (rs.next()) {
                return rs.getDouble(1);
            } else {
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
    /**
     * Update a feedback
     * @param feedback The feedback to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Feedback feedback) {
        String sql = "UPDATE feedback SET message = ?, rating = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, feedback.getMessage());
            stmt.setInt(2, feedback.getRating());
            stmt.setInt(3, feedback.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a feedback
     * @param id The feedback ID
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM feedback WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map a ResultSet to a Feedback object
     * @param rs The ResultSet
     * @return The Feedback object
     * @throws SQLException If a database access error occurs
     */
    private Feedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        Feedback feedback = new Feedback();
        feedback.setId(rs.getInt("id"));
        feedback.setUserId(rs.getInt("user_id"));
        feedback.setMessage(rs.getString("message"));
        feedback.setRating(rs.getInt("rating"));
        feedback.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Additional fields from joins
        feedback.setUserName(rs.getString("user_name"));
        
        return feedback;
    }
}
