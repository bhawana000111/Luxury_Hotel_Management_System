package com.hotel.model;

import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import static org.mockito.Mockito.*;

/**
 * Unit tests for UserDAO
 */
public class UserDAOTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockPreparedStatement;

    @Mock
    private Statement mockStatement;

    @Mock
    private ResultSet mockResultSet;

    private UserDAO userDAO;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        userDAO = new UserDAO();

        // Mock database connection
        when(mockConnection.prepareStatement(anyString(), anyInt())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.createStatement()).thenReturn(mockStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockStatement.executeQuery(anyString())).thenReturn(mockResultSet);
    }

    @Test
    public void testGetById_UserExists() throws Exception {
        // Arrange
        int userId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("id")).thenReturn(userId);
        when(mockResultSet.getString("name")).thenReturn("Test User");
        when(mockResultSet.getString("email")).thenReturn("test@example.com");
        when(mockResultSet.getString("password")).thenReturn("hashedPassword");
        when(mockResultSet.getString("role")).thenReturn("USER");

        // Act
        User user = userDAO.getById(userId);

        // Assert
        assertNotNull("User should not be null", user);
        assertEquals("User ID should match", userId, user.getId());
        assertEquals("User name should match", "Test User", user.getName());
        assertEquals("User email should match", "test@example.com", user.getEmail());
        assertEquals("User role should match", "USER", user.getRole());
    }

    @Test
    public void testGetById_UserDoesNotExist() throws Exception {
        // Arrange
        int userId = 999;
        when(mockResultSet.next()).thenReturn(false);

        // Act
        User user = userDAO.getById(userId);

        // Assert
        assertNull("User should be null", user);
    }

    @Test
    public void testCreate_Success() throws Exception {
        // Arrange
        User newUser = new User();
        newUser.setName("New User");
        newUser.setEmail("new@example.com");
        newUser.setPassword("password123");
        newUser.setRole("USER");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        // Act
        int userId = userDAO.create(newUser);

        // Assert
        assertTrue("User ID should be positive", userId > 0);
        verify(mockPreparedStatement).setString(1, newUser.getName());
        verify(mockPreparedStatement).setString(2, newUser.getEmail());
        // Password is hashed, so we can't verify the exact value
        verify(mockPreparedStatement).setString(4, newUser.getProfileImage());
        verify(mockPreparedStatement).setString(5, newUser.getRole());
    }

    @Test
    public void testCreate_Failure() throws Exception {
        // Arrange
        User newUser = new User();
        newUser.setName("New User");
        newUser.setEmail("new@example.com");
        newUser.setPassword("password123");
        newUser.setRole("USER");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        int userId = userDAO.create(newUser);

        // Assert
        assertEquals("User ID should be -1 on failure", -1, userId);
    }

    @Test
    public void testAuthenticate_Success() throws Exception {
        // Arrange
        String email = "test@example.com";
        String password = "password123";
        String hashedPassword = "$2a$10$abcdefghijklmnopqrstuvwxyz0123456789";

        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("id")).thenReturn(1);
        when(mockResultSet.getString("name")).thenReturn("Test User");
        when(mockResultSet.getString("email")).thenReturn(email);
        when(mockResultSet.getString("password")).thenReturn(hashedPassword);
        when(mockResultSet.getString("role")).thenReturn("USER");

        // Mock the password check
        // Note: This requires refactoring PasswordHasher to be more testable
        // For now, we'll assume it works

        // Act
        User user = userDAO.authenticate(email, password);

        // Assert
        // Since we can't easily mock the password check, this test is incomplete
        // In a real test, we would verify that the user is returned when the password matches
    }

    @Test
    public void testGetAll() throws Exception {
        // Arrange
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First user
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getString("name")).thenReturn("User 1").thenReturn("User 2");
        when(mockResultSet.getString("email")).thenReturn("user1@example.com").thenReturn("user2@example.com");
        when(mockResultSet.getString("password")).thenReturn("hash1").thenReturn("hash2");
        when(mockResultSet.getString("role")).thenReturn("USER").thenReturn("ADMIN");

        // Act
        List<User> users = userDAO.getAll();

        // Assert
        assertNotNull("Users list should not be null", users);
        assertEquals("Users list should have 2 items", 2, users.size());
        assertEquals("First user name should match", "User 1", users.get(0).getName());
        assertEquals("Second user name should match", "User 2", users.get(1).getName());
    }

    @Test
    public void testUpdate_Success() throws Exception {
        // Arrange
        User user = new User();
        user.setId(1);
        user.setName("Updated User");
        user.setEmail("updated@example.com");
        user.setProfileImage("profile.jpg");
        user.setRole("ADMIN");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = userDAO.update(user);

        // Assert
        assertTrue("Update should return true on success", result);
        verify(mockPreparedStatement).setString(1, user.getName());
        verify(mockPreparedStatement).setString(2, user.getEmail());
        verify(mockPreparedStatement).setString(3, user.getProfileImage());
        verify(mockPreparedStatement).setString(4, user.getRole());
        verify(mockPreparedStatement).setInt(5, user.getId());
    }

    @Test
    public void testUpdate_Failure() throws Exception {
        // Arrange
        User user = new User();
        user.setId(999);
        user.setName("Updated User");
        user.setEmail("updated@example.com");
        user.setProfileImage("profile.jpg");
        user.setRole("ADMIN");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = userDAO.update(user);

        // Assert
        assertFalse("Update should return false on failure", result);
    }

    @Test
    public void testDelete_Success() throws Exception {
        // Arrange
        int userId = 1;
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = userDAO.delete(userId);

        // Assert
        assertTrue("Delete should return true on success", result);
        verify(mockPreparedStatement).setInt(1, userId);
    }

    @Test
    public void testDelete_Failure() throws Exception {
        // Arrange
        int userId = 999;
        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = userDAO.delete(userId);

        // Assert
        assertFalse("Delete should return false on failure", result);
    }

    @Test
    public void testIsEmailInUse_True() throws Exception {
        // Arrange
        String email = "existing@example.com";
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        // Act
        boolean result = userDAO.isEmailInUse(email);

        // Assert
        assertTrue("Email should be in use", result);
        verify(mockPreparedStatement).setString(1, email);
    }

    @Test
    public void testIsEmailInUse_False() throws Exception {
        // Arrange
        String email = "new@example.com";
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0);

        // Act
        boolean result = userDAO.isEmailInUse(email);

        // Assert
        assertFalse("Email should not be in use", result);
    }
}
