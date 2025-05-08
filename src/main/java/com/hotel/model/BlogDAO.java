package com.hotel.model;

import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Blog entity
 */
public class BlogDAO {
    
    /**
     * Create a new blog post
     * @param blog The blog post to create
     * @return The ID of the created blog post, or -1 if creation failed
     */
    public int create(Blog blog) {
        String sql = "INSERT INTO blog (title, content, image_path, video_url, author) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, blog.getTitle());
            stmt.setString(2, blog.getContent());
            stmt.setString(3, blog.getImagePath());
            stmt.setString(4, blog.getVideoUrl());
            stmt.setString(5, blog.getAuthor());
            
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
     * Get a blog post by ID
     * @param id The blog post ID
     * @return The blog post, or null if not found
     */
    public Blog getById(int id) {
        String sql = "SELECT * FROM blog WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBlog(rs);
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
     * Get all blog posts
     * @return A list of all blog posts
     */
    public List<Blog> getAll() {
        String sql = "SELECT * FROM blog ORDER BY created_at DESC";
        List<Blog> blogs = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                blogs.add(mapResultSetToBlog(rs));
            }
            
            return blogs;
        } catch (SQLException e) {
            e.printStackTrace();
            return blogs;
        }
    }
    
    /**
     * Get all blog posts by author
     * @param author The author
     * @return A list of all blog posts by the specified author
     */
    public List<Blog> getAllByAuthor(String author) {
        String sql = "SELECT * FROM blog WHERE author = ? ORDER BY created_at DESC";
        List<Blog> blogs = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, author);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    blogs.add(mapResultSetToBlog(rs));
                }
            }
            
            return blogs;
        } catch (SQLException e) {
            e.printStackTrace();
            return blogs;
        }
    }
    
    /**
     * Get latest blog posts
     * @param limit The maximum number of blog posts to return
     * @return A list of the latest blog posts
     */
    public List<Blog> getLatest(int limit) {
        String sql = "SELECT * FROM blog ORDER BY created_at DESC LIMIT ?";
        List<Blog> blogs = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    blogs.add(mapResultSetToBlog(rs));
                }
            }
            
            return blogs;
        } catch (SQLException e) {
            e.printStackTrace();
            return blogs;
        }
    }
    
    /**
     * Update a blog post
     * @param blog The blog post to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Blog blog) {
        String sql = "UPDATE blog SET title = ?, content = ?, image_path = ?, " +
                     "video_url = ?, author = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, blog.getTitle());
            stmt.setString(2, blog.getContent());
            stmt.setString(3, blog.getImagePath());
            stmt.setString(4, blog.getVideoUrl());
            stmt.setString(5, blog.getAuthor());
            stmt.setInt(6, blog.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a blog post
     * @param id The blog post ID
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM blog WHERE id = ?";
        
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
     * Map a ResultSet to a Blog object
     * @param rs The ResultSet
     * @return The Blog object
     * @throws SQLException If a database access error occurs
     */
    private Blog mapResultSetToBlog(ResultSet rs) throws SQLException {
        Blog blog = new Blog();
        blog.setId(rs.getInt("id"));
        blog.setTitle(rs.getString("title"));
        blog.setContent(rs.getString("content"));
        blog.setImagePath(rs.getString("image_path"));
        blog.setVideoUrl(rs.getString("video_url"));
        blog.setAuthor(rs.getString("author"));
        blog.setCreatedAt(rs.getTimestamp("created_at"));
        blog.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return blog;
    }
}
