package com.hotel.model;

import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for Staff entity
 */
public class StaffDAO {
    
    /**
     * Create a new staff member
     * @param staff The staff member to create
     * @return The ID of the created staff member, or -1 if creation failed
     */
    public int create(Staff staff) {
        String sql = "INSERT INTO staff (name, role, email, phone, image_path) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, staff.getName());
            stmt.setString(2, staff.getRole());
            stmt.setString(3, staff.getEmail());
            stmt.setString(4, staff.getPhone());
            stmt.setString(5, staff.getImagePath());
            
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
     * Get a staff member by ID
     * @param id The staff member ID
     * @return The staff member, or null if not found
     */
    public Staff getById(int id) {
        String sql = "SELECT * FROM staff WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStaff(rs);
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
     * Get a staff member by email
     * @param email The staff member email
     * @return The staff member, or null if not found
     */
    public Staff getByEmail(String email) {
        String sql = "SELECT * FROM staff WHERE email = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToStaff(rs);
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
     * Get all staff members
     * @return A list of all staff members
     */
    public List<Staff> getAll() {
        String sql = "SELECT * FROM staff ORDER BY name";
        List<Staff> staffList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                staffList.add(mapResultSetToStaff(rs));
            }
            
            return staffList;
        } catch (SQLException e) {
            e.printStackTrace();
            return staffList;
        }
    }
    
    /**
     * Get all staff members by role
     * @param role The staff role
     * @return A list of all staff members with the specified role
     */
    public List<Staff> getAllByRole(String role) {
        String sql = "SELECT * FROM staff WHERE role = ? ORDER BY name";
        List<Staff> staffList = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, role);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    staffList.add(mapResultSetToStaff(rs));
                }
            }
            
            return staffList;
        } catch (SQLException e) {
            e.printStackTrace();
            return staffList;
        }
    }
    
    /**
     * Update a staff member
     * @param staff The staff member to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Staff staff) {
        String sql = "UPDATE staff SET name = ?, role = ?, email = ?, phone = ?, image_path = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, staff.getName());
            stmt.setString(2, staff.getRole());
            stmt.setString(3, staff.getEmail());
            stmt.setString(4, staff.getPhone());
            stmt.setString(5, staff.getImagePath());
            stmt.setInt(6, staff.getId());
            
            int affectedRows = stmt.executeUpdate();
            
            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Delete a staff member
     * @param id The staff member ID
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM staff WHERE id = ?";
        
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
     * Check if an email is already registered for a staff member
     * @param email The email to check
     * @return True if the email is already registered, false otherwise
     */
    public boolean isEmailRegistered(String email) {
        return getByEmail(email) != null;
    }
    
    /**
     * Map a ResultSet to a Staff object
     * @param rs The ResultSet
     * @return The Staff object
     * @throws SQLException If a database access error occurs
     */
    private Staff mapResultSetToStaff(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setId(rs.getInt("id"));
        staff.setName(rs.getString("name"));
        staff.setRole(rs.getString("role"));
        staff.setEmail(rs.getString("email"));
        staff.setPhone(rs.getString("phone"));
        staff.setImagePath(rs.getString("image_path"));
        staff.setCreatedAt(rs.getTimestamp("created_at"));
        staff.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        return staff;
    }
}
