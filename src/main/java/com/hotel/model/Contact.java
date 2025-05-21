package com.hotel.model;

import java.sql.Timestamp;

/**
 * Represents a contact form submission
 */
public class Contact {
    
    private int id;
    private String name;
    private String email;
    private String subject;
    private String message;
    private Timestamp createdAt;
    
    /**
     * Default constructor
     */
    public Contact() {
    }
    
    /**
     * Constructor with essential fields
     * @param name The name of the person
     * @param email The email address
     * @param subject The subject of the message
     * @param message The message content
     */
    public Contact(String name, String email, String subject, String message) {
        this.name = name;
        this.email = email;
        this.subject = subject;
        this.message = message;
    }
    
    /**
     * Constructor with all fields
     * @param id The contact ID
     * @param name The name of the person
     * @param email The email address
     * @param subject The subject of the message
     * @param message The message content
     * @param createdAt The creation timestamp
     */
    public Contact(int id, String name, String email, String subject, String message, Timestamp createdAt) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.subject = subject;
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
    
    public String getName() {
        return name;
    }
    
    public void setName(String name) {
        this.name = name;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getSubject() {
        return subject;
    }
    
    public void setSubject(String subject) {
        this.subject = subject;
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
    
    @Override
    public String toString() {
        return "Contact{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", subject='" + subject + '\'' +
                ", message='" + message + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
