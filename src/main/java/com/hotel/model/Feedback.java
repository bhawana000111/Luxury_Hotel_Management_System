package com.hotel.model;

import java.sql.Timestamp;

/**
 * Represents a feedback from a user
 */
public class Feedback {
    
    private int id;
    private int userId;
    private int bookingId;
    private int rating;
    private String message;
    private Timestamp createdAt;
    private String userName; // For display purposes
    
    /**
     * Default constructor
     */
    public Feedback() {
    }
    
    /**
     * Constructor with essential fields
     * @param userId The user ID
     * @param message The feedback message
     * @param rating The rating (1-5)
     */
    public Feedback(int userId, String message, int rating) {
        this.userId = userId;
        this.message = message;
        this.rating = rating;
    }
    
    /**
     * Constructor with booking
     * @param userId The user ID
     * @param bookingId The booking ID
     * @param message The feedback message
     * @param rating The rating (1-5)
     */
    public Feedback(int userId, int bookingId, String message, int rating) {
        this.userId = userId;
        this.bookingId = bookingId;
        this.message = message;
        this.rating = rating;
    }
    
    /**
     * Constructor with all fields
     * @param id The feedback ID
     * @param userId The user ID
     * @param bookingId The booking ID
     * @param rating The rating (1-5)
     * @param message The feedback message
     * @param createdAt The creation timestamp
     */
    public Feedback(int id, int userId, int bookingId, int rating, String message, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.bookingId = bookingId;
        this.rating = rating;
        this.message = message;
        this.createdAt = createdAt;
    }
    
    // Getters and Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public int getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }
    
    public int getRating() {
        return rating;
    }
    
    public void setRating(int rating) {
        this.rating = rating;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    @Override
    public String toString() {
        return "Feedback{" +
                "id=" + id +
                ", userId=" + userId +
                ", bookingId=" + bookingId +
                ", rating=" + rating +
                ", message='" + message + '\'' +
                ", createdAt=" + createdAt +
                ", userName='" + userName + '\'' +
                '}';
    }
}
