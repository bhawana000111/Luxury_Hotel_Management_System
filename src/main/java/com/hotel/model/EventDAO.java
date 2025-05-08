package com.hotel.model;

import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Event entity
 */
public class EventDAO {
    
    /**
     * Create a new event
     * @param event The event to create
     * @return The ID of the created event, or -1 if creation failed
     */
    public int create(Event event) {
        String sql = "INSERT INTO events (event_name, description, date, location, image_path) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, event.getEventName());
            stmt.setString(2, event.getDescription());
            stmt.setDate(3, event.getDate());
            stmt.setString(4, event.getLocation());
            stmt.setString(5, event.getImagePath());
            
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
     * Get an event by ID
     * @param id The event ID
     * @return The event, or null if not found
     */
    public Event getById(int id) {
        String sql = "SELECT * FROM events WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToEvent(rs);
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
     * Get all events
     * @return A list of all events
     */
    public List<Event> getAll() {
        String sql = "SELECT * FROM events ORDER BY date";
        List<Event> events = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            
            return events;
        } catch (SQLException e) {
            e.printStackTrace();
            return events;
        }
    }
    
    /**
     * Get all upcoming events
     * @return A list of all upcoming events
     */
    public List<Event> getAllUpcoming() {
        String sql = "SELECT * FROM events WHERE date >= CURRENT_DATE ORDER BY date";
        List<Event> events = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }
            
            return events;
        } catch (SQLException e) {
            e.printStackTrace();
            return events;
        }
    }
    
    /**
     * Get all events by location
     * @param location The location
     * @return A list of all events at the specified location
     */
    public List<Event> getAllByLocation(String location) {
        String sql = "SELECT * FROM events WHERE location = ? ORDER BY date";
        List<Event> events = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, location);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapResultSetToEvent(rs));
                }
            }
            
            return events;
        } catch (SQLException e) {
            e.printStackTrace();
            return events;
        }
    }
    
    /**
     * Get latest events
     * @param limit The maximum number of events to return
     * @return A list of the latest events
     */
    public List<Event> getLatest(int limit) {
        String sql = "SELECT * FROM events WHERE date >= CURRENT_DATE ORDER BY date LIMIT ?";
        List<Event> events = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    events.add(mapResultSetToEvent(rs));
                }
            }
            
            return events;
        } catch (SQLException e) {
            e.printStackTrace();
            return events;
        }
    }
    
    /**
     * Update an event
     * @param event The event to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Event event) {
        String sql = "UPDATE events SET event_name = ?, description = ?, date = ?, " +
                     "location = ?, image_path = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, event.getEventName());
            stmt.setString(2, event.getDescription());
            stmt.setDate(3, event.getDate());
            stmt.setString(4, event.getLocation());
            stmt.setString(5, event.getImagePath());
            stmt.setInt(6, event.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete an event
     * @param id The event ID
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM events WHERE id = ?";
        
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
     * Map a ResultSet to an Event object
     * @param rs The ResultSet
     * @return The Event object
     * @throws SQLException If a database access error occurs
     */
    private Event mapResultSetToEvent(ResultSet rs) throws SQLException {
        Event event = new Event();
        event.setId(rs.getInt("id"));
        event.setEventName(rs.getString("event_name"));
        event.setDescription(rs.getString("description"));
        event.setDate(rs.getDate("date"));
        event.setLocation(rs.getString("location"));
        event.setImagePath(rs.getString("image_path"));
        event.setCreatedAt(rs.getTimestamp("created_at"));
        event.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return event;
    }
}
