package com.hotel.model;

import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import static org.mockito.Mockito.*;

/**
 * Unit tests for BookingDAO
 */
public class BookingDAOTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockPreparedStatement;

    @Mock
    private Statement mockStatement;

    @Mock
    private ResultSet mockResultSet;

    private BookingDAO bookingDAO;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        bookingDAO = new BookingDAO();

        // Mock database connection
        when(mockConnection.prepareStatement(anyString(), anyInt())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.createStatement()).thenReturn(mockStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockStatement.executeQuery(anyString())).thenReturn(mockResultSet);
    }

    @Test
    public void testGetById_BookingExists() throws Exception {
        // Arrange
        int bookingId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("id")).thenReturn(bookingId);
        when(mockResultSet.getInt("user_id")).thenReturn(1);
        when(mockResultSet.getInt("room_id")).thenReturn(1);
        when(mockResultSet.getDate("date_from")).thenReturn(Date.valueOf("2023-01-01"));
        when(mockResultSet.getDate("date_to")).thenReturn(Date.valueOf("2023-01-05"));
        when(mockResultSet.getString("status")).thenReturn("CONFIRMED");
        when(mockResultSet.getString("special_requests")).thenReturn("Late check-in");

        // Act
        Booking booking = bookingDAO.getById(bookingId);

        // Assert
        assertNotNull("Booking should not be null", booking);
        assertEquals("Booking ID should match", bookingId, booking.getId());
        assertEquals("User ID should match", 1, booking.getUserId());
        assertEquals("Room ID should match", 1, booking.getRoomId());
        assertEquals("Check-in date should match", Date.valueOf("2023-01-01"), booking.getDateFrom());
        assertEquals("Check-out date should match", Date.valueOf("2023-01-05"), booking.getDateTo());
        assertEquals("Status should match", "CONFIRMED", booking.getStatus());
        assertEquals("Special requests should match", "Late check-in", booking.getSpecialRequests());
    }

    @Test
    public void testGetById_BookingDoesNotExist() throws Exception {
        // Arrange
        int bookingId = 999;
        when(mockResultSet.next()).thenReturn(false);

        // Act
        Booking booking = bookingDAO.getById(bookingId);

        // Assert
        assertNull("Booking should be null", booking);
    }

    @Test
    public void testCreate_Success() throws Exception {
        // Arrange
        Booking newBooking = new Booking();
        newBooking.setUserId(1);
        newBooking.setRoomId(1);
        newBooking.setDateFrom(Date.valueOf("2023-01-01"));
        newBooking.setDateTo(Date.valueOf("2023-01-05"));
        newBooking.setStatus("PENDING");
        newBooking.setSpecialRequests("Late check-in");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        // Act
        int bookingId = bookingDAO.create(newBooking);

        // Assert
        assertTrue("Booking ID should be positive", bookingId > 0);
        verify(mockPreparedStatement).setInt(1, newBooking.getUserId());
        verify(mockPreparedStatement).setInt(2, newBooking.getRoomId());
        verify(mockPreparedStatement).setDate(3, newBooking.getDateFrom());
        verify(mockPreparedStatement).setDate(4, newBooking.getDateTo());
        verify(mockPreparedStatement).setString(5, newBooking.getStatus());
        verify(mockPreparedStatement).setString(6, newBooking.getSpecialRequests());
    }

    @Test
    public void testCreate_Failure() throws Exception {
        // Arrange
        Booking newBooking = new Booking();
        newBooking.setUserId(1);
        newBooking.setRoomId(1);
        newBooking.setDateFrom(Date.valueOf("2023-01-01"));
        newBooking.setDateTo(Date.valueOf("2023-01-05"));
        newBooking.setStatus("PENDING");
        newBooking.setSpecialRequests("Late check-in");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        int bookingId = bookingDAO.create(newBooking);

        // Assert
        assertEquals("Booking ID should be -1 on failure", -1, bookingId);
    }

    @Test
    public void testGetAllByUserId() throws Exception {
        // Arrange
        int userId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First booking
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getInt("user_id")).thenReturn(userId).thenReturn(userId);
        when(mockResultSet.getInt("room_id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getDate("date_from")).thenReturn(Date.valueOf("2023-01-01")).thenReturn(Date.valueOf("2023-02-01"));
        when(mockResultSet.getDate("date_to")).thenReturn(Date.valueOf("2023-01-05")).thenReturn(Date.valueOf("2023-02-05"));
        when(mockResultSet.getString("status")).thenReturn("CONFIRMED").thenReturn("PENDING");

        // Act
        List<Booking> bookings = bookingDAO.getAllByUserId(userId);

        // Assert
        assertNotNull("Bookings list should not be null", bookings);
        assertEquals("Bookings list should have 2 items", 2, bookings.size());
        assertEquals("First booking status should match", "CONFIRMED", bookings.get(0).getStatus());
        assertEquals("Second booking status should match", "PENDING", bookings.get(1).getStatus());
    }

    @Test
    public void testUpdate_Success() throws Exception {
        // Arrange
        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(1);
        booking.setRoomId(1);
        booking.setDateFrom(Date.valueOf("2023-01-01"));
        booking.setDateTo(Date.valueOf("2023-01-05"));
        booking.setStatus("CONFIRMED");
        booking.setSpecialRequests("Late check-in");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = bookingDAO.update(booking);

        // Assert
        assertTrue("Update should return true on success", result);
        verify(mockPreparedStatement).setInt(1, booking.getUserId());
        verify(mockPreparedStatement).setInt(2, booking.getRoomId());
        verify(mockPreparedStatement).setDate(3, booking.getDateFrom());
        verify(mockPreparedStatement).setDate(4, booking.getDateTo());
        verify(mockPreparedStatement).setString(5, booking.getStatus());
        verify(mockPreparedStatement).setString(6, booking.getSpecialRequests());
        verify(mockPreparedStatement).setInt(7, booking.getId());
    }

    @Test
    public void testUpdate_Failure() throws Exception {
        // Arrange
        Booking booking = new Booking();
        booking.setId(999);
        booking.setUserId(1);
        booking.setRoomId(1);
        booking.setDateFrom(Date.valueOf("2023-01-01"));
        booking.setDateTo(Date.valueOf("2023-01-05"));
        booking.setStatus("CONFIRMED");
        booking.setSpecialRequests("Late check-in");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = bookingDAO.update(booking);

        // Assert
        assertFalse("Update should return false on failure", result);
    }

    @Test
    public void testDelete_Success() throws Exception {
        // Arrange
        int bookingId = 1;
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = bookingDAO.delete(bookingId);

        // Assert
        assertTrue("Delete should return true on success", result);
        verify(mockPreparedStatement).setInt(1, bookingId);
    }

    @Test
    public void testDelete_Failure() throws Exception {
        // Arrange
        int bookingId = 999;
        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = bookingDAO.delete(bookingId);

        // Assert
        assertFalse("Delete should return false on failure", result);
    }

    @Test
    public void testGetAll() throws Exception {
        // Arrange
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First booking
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getInt("user_id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getInt("room_id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getDate("date_from")).thenReturn(Date.valueOf("2023-01-01")).thenReturn(Date.valueOf("2023-02-01"));
        when(mockResultSet.getDate("date_to")).thenReturn(Date.valueOf("2023-01-05")).thenReturn(Date.valueOf("2023-02-05"));
        when(mockResultSet.getString("status")).thenReturn("CONFIRMED").thenReturn("PENDING");

        // Act
        List<Booking> bookings = bookingDAO.getAll();

        // Assert
        assertNotNull("Bookings list should not be null", bookings);
        assertEquals("Bookings list should have 2 items", 2, bookings.size());
        assertEquals("First booking status should match", "CONFIRMED", bookings.get(0).getStatus());
        assertEquals("Second booking status should match", "PENDING", bookings.get(1).getStatus());
    }

    @Test
    public void testUpdateStatus_Success() throws Exception {
        // Arrange
        int bookingId = 1;
        String newStatus = "CANCELLED";

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = bookingDAO.updateStatus(bookingId, newStatus);

        // Assert
        assertTrue("Update status should return true on success", result);
        verify(mockPreparedStatement).setString(1, newStatus);
        verify(mockPreparedStatement).setInt(2, bookingId);
    }

    @Test
    public void testUpdateStatus_Failure() throws Exception {
        // Arrange
        int bookingId = 999;
        String newStatus = "CANCELLED";

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = bookingDAO.updateStatus(bookingId, newStatus);

        // Assert
        assertFalse("Update status should return false on failure", result);
    }
}
