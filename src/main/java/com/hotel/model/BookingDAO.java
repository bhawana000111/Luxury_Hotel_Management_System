package com.hotel.model;

import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Booking entity
 */
public class BookingDAO {
    
    /**
     * Create a new booking
     * @param booking The booking to create
     * @return The ID of the created booking, or -1 if creation failed
     */
    public int create(Booking booking) {
        String sql = "INSERT INTO bookings (user_id, room_id, date_from, date_to, status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getRoomId());
            stmt.setDate(3, booking.getDateFrom());
            stmt.setDate(4, booking.getDateTo());
            stmt.setString(5, booking.getStatus());
            
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
     * Get a booking by ID
     * @param id The booking ID
     * @return The booking, or null if not found
     */
    public Booking getById(int id) {
        String sql = "SELECT b.*, u.name as user_name, r.number as room_number, r.type as room_type " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "WHERE b.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
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
     * Get all bookings
     * @return A list of all bookings
     */
    public List<Booking> getAll() {
        String sql = "SELECT b.*, u.name as user_name, r.number as room_number, r.type as room_type " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "ORDER BY b.date_from DESC";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
            
            return bookings;
        } catch (SQLException e) {
            e.printStackTrace();
            return bookings;
        }
    }
    
    /**
     * Get all bookings by user ID
     * @param userId The user ID
     * @return A list of all bookings for the specified user
     */
    public List<Booking> getAllByUserId(int userId) {
        String sql = "SELECT b.*, u.name as user_name, r.number as room_number, r.type as room_type " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "WHERE b.user_id = ? " +
                     "ORDER BY b.date_from DESC";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
            
            return bookings;
        } catch (SQLException e) {
            e.printStackTrace();
            return bookings;
        }
    }
    
    /**
     * Get all bookings by room ID
     * @param roomId The room ID
     * @return A list of all bookings for the specified room
     */
    public List<Booking> getAllByRoomId(int roomId) {
        String sql = "SELECT b.*, u.name as user_name, r.number as room_number, r.type as room_type " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "WHERE b.room_id = ? " +
                     "ORDER BY b.date_from DESC";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
            
            return bookings;
        } catch (SQLException e) {
            e.printStackTrace();
            return bookings;
        }
    }
    
    /**
     * Get all bookings by status
     * @param status The booking status
     * @return A list of all bookings with the specified status
     */
    public List<Booking> getAllByStatus(String status) {
        String sql = "SELECT b.*, u.name as user_name, r.number as room_number, r.type as room_type " +
                     "FROM bookings b " +
                     "JOIN users u ON b.user_id = u.id " +
                     "JOIN rooms r ON b.room_id = r.id " +
                     "WHERE b.status = ? " +
                     "ORDER BY b.date_from DESC";
        List<Booking> bookings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
            
            return bookings;
        } catch (SQLException e) {
            e.printStackTrace();
            return bookings;
        }
    }
    
    /**
     * Update a booking
     * @param booking The booking to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Booking booking) {
        String sql = "UPDATE bookings SET user_id = ?, room_id = ?, date_from = ?, date_to = ?, " +
                     "status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, booking.getUserId());
            stmt.setInt(2, booking.getRoomId());
            stmt.setDate(3, booking.getDateFrom());
            stmt.setDate(4, booking.getDateTo());
            stmt.setString(5, booking.getStatus());
            stmt.setInt(6, booking.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update booking status
     * @param bookingId The booking ID
     * @param status The new status
     * @return True if the update was successful, false otherwise
     */
    public boolean updateStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a booking
     * @param id The booking ID
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM bookings WHERE id = ?";
        
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
     * Check if a room is available for the specified dates
     * @param roomId The room ID
     * @param dateFrom The start date
     * @param dateTo The end date
     * @return True if the room is available, false otherwise
     */
    public boolean isRoomAvailable(int roomId, Date dateFrom, Date dateTo) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                     "WHERE room_id = ? AND status != 'CANCELLED' AND " +
                     "((date_from BETWEEN ? AND ?) OR (date_to BETWEEN ? AND ?) OR " +
                     "(date_from <= ? AND date_to >= ?))";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roomId);
            stmt.setDate(2, dateFrom);
            stmt.setDate(3, dateTo);
            stmt.setDate(4, dateFrom);
            stmt.setDate(5, dateTo);
            stmt.setDate(6, dateFrom);
            stmt.setDate(7, dateTo);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
            
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Map a ResultSet to a Booking object
     * @param rs The ResultSet
     * @return The Booking object
     * @throws SQLException If a database access error occurs
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setRoomId(rs.getInt("room_id"));
        booking.setDateFrom(rs.getDate("date_from"));
        booking.setDateTo(rs.getDate("date_to"));
        booking.setStatus(rs.getString("status"));
        booking.setCreatedAt(rs.getTimestamp("created_at"));
        booking.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Additional fields from joins
        booking.setUserName(rs.getString("user_name"));
        booking.setRoomNumber(rs.getString("room_number"));
        booking.setRoomType(rs.getString("room_type"));
        
        return booking;
    }
}
