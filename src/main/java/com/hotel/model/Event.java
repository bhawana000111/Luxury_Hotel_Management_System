package com.hotel.model;

import java.sql.Date;
import java.sql.Timestamp;

/**
 * Represents an event in the hotel
 */
public class Event {
    
    private int id;
    private String eventName;
    private String description;
    private Date date;
    private String location;
    private String imagePath;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    /**
     * Default constructor
     */
    public Event() {
    }
    
    /**
     * Constructor with essential fields
     * @param eventName The event name
     * @param description The event description
     * @param date The event date
     * @param location The event location
     */
    public Event(String eventName, String description, Date date, String location) {
        this.eventName = eventName;
        this.description = description;
        this.date = date;
        this.location = location;
    }
    
    /**
     * Constructor with all fields
     * @param id The event ID
     * @param eventName The event name
     * @param description The event description
     * @param date The event date
     * @param location The event location
     * @param imagePath The event image path
     * @param createdAt The creation timestamp
     * @param updatedAt The update timestamp
     */
    public Event(int id, String eventName, String description, Date date, String location, 
                String imagePath, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.eventName = eventName;
        this.description = description;
        this.date = date;
        this.location = location;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and Setters
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getEventName() {
        return eventName;
    }
    
    public void setEventName(String eventName) {
        this.eventName = eventName;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Date getDate() {
        return date;
    }
    
    public void setDate(Date date) {
        this.date = date;
    }
    
    public String getLocation() {
        return location;
    }
    
    public void setLocation(String location) {
        this.location = location;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public Timestamp getUpdatedAt() {
        return updatedAt;
    }
    
    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
    
    @Override
    public String toString() {
        return "Event{" +
                "id=" + id +
                ", eventName='" + eventName + '\'' +
                ", description='" + description + '\'' +
                ", date=" + date +
                ", location='" + location + '\'' +
                ", imagePath='" + imagePath + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
