package com.hotel.model;

import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Billing entity
 */
public class BillingDAO {
    
    /**
     * Create a new billing record
     * @param billing The billing record to create
     * @return The ID of the created billing record, or -1 if creation failed
     */
    public int create(Billing billing) {
        String sql = "INSERT INTO billing (booking_id, amount, payment_method, transaction_id, status) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, billing.getBookingId());
            stmt.setBigDecimal(2, billing.getAmount());
            stmt.setString(3, billing.getPaymentMethod());
            stmt.setString(4, billing.getTransactionId());
            stmt.setString(5, billing.getStatus());
            
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
     * Get a billing record by ID
     * @param id The billing record ID
     * @return The billing record, or null if not found
     */
    public Billing getById(int id) {
        String sql = "SELECT b.*, bk.date_from, bk.date_to, u.name as user_name, r.number as room_number " +
                     "FROM billing b " +
                     "JOIN bookings bk ON b.booking_id = bk.id " +
                     "JOIN users u ON bk.user_id = u.id " +
                     "JOIN rooms r ON bk.room_id = r.id " +
                     "WHERE b.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBilling(rs);
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
     * Get a billing record by booking ID
     * @param bookingId The booking ID
     * @return The billing record, or null if not found
     */
    public Billing getByBookingId(int bookingId) {
        String sql = "SELECT b.*, bk.date_from, bk.date_to, u.name as user_name, r.number as room_number " +
                     "FROM billing b " +
                     "JOIN bookings bk ON b.booking_id = bk.id " +
                     "JOIN users u ON bk.user_id = u.id " +
                     "JOIN rooms r ON bk.room_id = r.id " +
                     "WHERE b.booking_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, bookingId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBilling(rs);
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
     * Get all billing records
     * @return A list of all billing records
     */
    public List<Billing> getAll() {
        String sql = "SELECT b.*, bk.date_from, bk.date_to, u.name as user_name, r.number as room_number " +
                     "FROM billing b " +
                     "JOIN bookings bk ON b.booking_id = bk.id " +
                     "JOIN users u ON bk.user_id = u.id " +
                     "JOIN rooms r ON bk.room_id = r.id " +
                     "ORDER BY b.created_at DESC";
        List<Billing> billings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                billings.add(mapResultSetToBilling(rs));
            }
            
            return billings;
        } catch (SQLException e) {
            e.printStackTrace();
            return billings;
        }
    }
    
    /**
     * Get all billing records by user ID
     * @param userId The user ID
     * @return A list of all billing records for the specified user
     */
    public List<Billing> getAllByUserId(int userId) {
        String sql = "SELECT b.*, bk.date_from, bk.date_to, u.name as user_name, r.number as room_number " +
                     "FROM billing b " +
                     "JOIN bookings bk ON b.booking_id = bk.id " +
                     "JOIN users u ON bk.user_id = u.id " +
                     "JOIN rooms r ON bk.room_id = r.id " +
                     "WHERE bk.user_id = ? " +
                     "ORDER BY b.created_at DESC";
        List<Billing> billings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    billings.add(mapResultSetToBilling(rs));
                }
            }
            
            return billings;
        } catch (SQLException e) {
            e.printStackTrace();
            return billings;
        }
    }
    
    /**
     * Get all billing records by status
     * @param status The billing status
     * @return A list of all billing records with the specified status
     */
    public List<Billing> getAllByStatus(String status) {
        String sql = "SELECT b.*, bk.date_from, bk.date_to, u.name as user_name, r.number as room_number " +
                     "FROM billing b " +
                     "JOIN bookings bk ON b.booking_id = bk.id " +
                     "JOIN users u ON bk.user_id = u.id " +
                     "JOIN rooms r ON bk.room_id = r.id " +
                     "WHERE b.status = ? " +
                     "ORDER BY b.created_at DESC";
        List<Billing> billings = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    billings.add(mapResultSetToBilling(rs));
                }
            }
            
            return billings;
        } catch (SQLException e) {
            e.printStackTrace();
            return billings;
        }
    }
    
    /**
     * Update a billing record
     * @param billing The billing record to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Billing billing) {
        String sql = "UPDATE billing SET amount = ?, paid_on = ?, payment_method = ?, " +
                     "transaction_id = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBigDecimal(1, billing.getAmount());
            stmt.setTimestamp(2, billing.getPaidOn());
            stmt.setString(3, billing.getPaymentMethod());
            stmt.setString(4, billing.getTransactionId());
            stmt.setString(5, billing.getStatus());
            stmt.setInt(6, billing.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update billing status
     * @param billingId The billing record ID
     * @param status The new status
     * @param paidOn The payment timestamp (null if not paid)
     * @return True if the update was successful, false otherwise
     */
    public boolean updateStatus(int billingId, String status, Timestamp paidOn) {
        String sql = "UPDATE billing SET status = ?, paid_on = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setTimestamp(2, paidOn);
            stmt.setInt(3, billingId);
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a billing record
     * @param id The billing record ID
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM billing WHERE id = ?";
        
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
     * Map a ResultSet to a Billing object
     * @param rs The ResultSet
     * @return The Billing object
     * @throws SQLException If a database access error occurs
     */
    private Billing mapResultSetToBilling(ResultSet rs) throws SQLException {
        Billing billing = new Billing();
        billing.setId(rs.getInt("id"));
        billing.setBookingId(rs.getInt("booking_id"));
        billing.setAmount(rs.getBigDecimal("amount"));
        billing.setPaidOn(rs.getTimestamp("paid_on"));
        billing.setPaymentMethod(rs.getString("payment_method"));
        billing.setTransactionId(rs.getString("transaction_id"));
        billing.setStatus(rs.getString("status"));
        billing.setCreatedAt(rs.getTimestamp("created_at"));
        billing.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Additional fields from joins
        billing.setUserName(rs.getString("user_name"));
        billing.setRoomNumber(rs.getString("room_number"));
        billing.setBookingDateFrom(rs.getDate("date_from"));
        billing.setBookingDateTo(rs.getDate("date_to"));
        
        return billing;
    }
}
