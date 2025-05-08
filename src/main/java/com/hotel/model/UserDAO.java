package com.hotel.model;

import com.hotel.util.DBConnection;
import com.hotel.util.PasswordHasher;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for User entity
 */
public class UserDAO {

    /**
     * Create a new user
     * @param user The user to create
     * @return The ID of the created user, or -1 if creation failed
     */
    public int create(User user) {
        String sql = "INSERT INTO users (name, email, password, profile_image, role) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());

            // Hash the password before storing
            String hashedPassword = PasswordHasher.hashPassword(user.getPassword());
            stmt.setString(3, hashedPassword);

            stmt.setString(4, user.getProfileImage());
            stmt.setString(5, user.getRole());

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
     * Get a user by ID
     * @param id The user ID
     * @return The user, or null if not found
     */
    public User getById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
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
     * Get a user by email
     * @param email The user email
     * @return The user, or null if not found
     */
    public User getByEmail(String email) {
        System.out.println("Looking up user by email: " + email);
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            System.out.println("Executing SQL: " + sql + " with parameter: " + email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    User user = mapResultSetToUser(rs);
                    System.out.println("User found: " + user.getEmail() + ", ID: " + user.getId() + ", Role: " + user.getRole());
                    return user;
                } else {
                    System.out.println("No user found with email: " + email);
                    return null;
                }
            }
        } catch (SQLException e) {
            System.out.println("SQL Exception in getByEmail: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get all users
     * @return A list of all users
     */
    public List<User> getAll() {
        String sql = "SELECT * FROM users ORDER BY name";
        List<User> users = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }

            return users;
        } catch (SQLException e) {
            e.printStackTrace();
            return users;
        }
    }

    /**
     * Update a user
     * @param user The user to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, profile_image = ?, role = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getProfileImage());
            stmt.setString(4, user.getRole());
            stmt.setInt(5, user.getId());

            int affectedRows = stmt.executeUpdate();

            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Update a user's password
     * @param userId The user ID
     * @param newPassword The new password
     * @return True if the update was successful, false otherwise
     */
    public boolean updatePassword(int userId, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            // Hash the password before storing
            String hashedPassword = PasswordHasher.hashPassword(newPassword);
            stmt.setString(1, hashedPassword);
            stmt.setInt(2, userId);

            int affectedRows = stmt.executeUpdate();

            return affectedRows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a user
     * @param id The ID of the user to delete
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM users WHERE id = ?";

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
     * Authenticate a user
     * @param email The user email
     * @param password The user password
     * @return The authenticated user, or null if authentication failed
     */
    public User authenticate(String email, String password) {
        System.out.println("Attempting to authenticate: " + email);
        User user = getByEmail(email);

        if (user != null) {
            System.out.println("User found: " + user.getEmail());
            System.out.println("Stored password hash: " + user.getPassword());
            boolean passwordMatches = PasswordHasher.checkPassword(password, user.getPassword());
            System.out.println("Password match: " + passwordMatches);

            if (passwordMatches) {
                return user;
            }
        } else {
            System.out.println("User not found for email: " + email);
        }

        return null;
    }

    /**
     * Check if an email is already in use
     * @param email The email to check
     * @return True if the email is already in use, false otherwise
     */
    public boolean isEmailInUse(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if an email is already in use by another user
     * @param email The email to check
     * @param id The ID of the user to exclude from the check
     * @return True if the email is already in use by another user, false otherwise
     */
    public boolean isEmailInUseByAnother(String email, int id) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND id != ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, email);
            stmt.setInt(2, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Map a ResultSet to a User object
     * @param rs The ResultSet
     * @return The User object
     * @throws SQLException If a database access error occurs
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setName(rs.getString("name"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setProfileImage(rs.getString("profile_image"));
        user.setRole(rs.getString("role"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));

        return user;
    }
}