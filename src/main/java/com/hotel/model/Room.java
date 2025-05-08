package com.hotel.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * Room model class
 */
public class Room {
    private int id;
    private String type;
    private String number;
    private BigDecimal price;
    private boolean availability;
    private String description;
    private String imagePath;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // Default constructor
    public Room() {
    }
    
    // Constructor with essential fields
    public Room(String type, String number, BigDecimal price, boolean availability) {
        this.type = type;
        this.number = number;
        this.price = price;
        this.availability = availability;
    }
    
    // Constructor with all fields
    public Room(int id, String type, String number, BigDecimal price, boolean availability,
                String description, String imagePath, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.type = type;
        this.number = number;
        this.price = price;
        this.availability = availability;
        this.description = description;
        this.imagePath = imagePath;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
    
    // Getters and setters
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getNumber() {
        return number;
    }
    
    public void setNumber(String number) {
        this.number = number;
    }
    
    public BigDecimal getPrice() {
        return price;
    }
    
    public void setPrice(BigDecimal price) {
        this.price = price;
    }
    
    public boolean isAvailability() {
        return availability;
    }
    
    public void setAvailability(boolean availability) {
        this.availability = availability;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
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
        return "Room{" +
                "id=" + id +
                ", type='" + type + '\'' +
                ", number='" + number + '\'' +
                ", price=" + price +
                ", availability=" + availability +
                '}';
    }
}
