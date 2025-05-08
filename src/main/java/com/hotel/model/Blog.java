package com.hotel.model;

import java.sql.Timestamp;

/**
 * Represents a blog post in the hotel
 */
public class Blog {
    
    private int id;
    private String title;
    private String content;
    private String imagePath;
    private String videoUrl;
    private String author;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    /**
     * Default constructor
     */
    public Blog() {
    }
    
    /**
     * Constructor with essential fields
     * @param title The blog post title
     * @param content The blog post content
     * @param author The blog post author
     */
    public Blog(String title, String content, String author) {
        this.title = title;
        this.content = content;
        this.author = author;
    }
    
    /**
     * Constructor with all fields
     * @param id The blog post ID
     * @param title The blog post title
     * @param content The blog post content
     * @param imagePath The blog post image path
     * @param videoUrl The blog post video URL
     * @param author The blog post author
     * @param createdAt The creation timestamp
     * @param updatedAt The update timestamp
     */
    public Blog(int id, String title, String content, String imagePath, String videoUrl, 
               String author, Timestamp createdAt, Timestamp updatedAt) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.imagePath = imagePath;
        this.videoUrl = videoUrl;
        this.author = author;
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
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public String getImagePath() {
        return imagePath;
    }
    
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
    
    public String getVideoUrl() {
        return videoUrl;
    }
    
    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }
    
    public String getAuthor() {
        return author;
    }
    
    public void setAuthor(String author) {
        this.author = author;
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
        return "Blog{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content='" + content + '\'' +
                ", imagePath='" + imagePath + '\'' +
                ", videoUrl='" + videoUrl + '\'' +
                ", author='" + author + '\'' +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
