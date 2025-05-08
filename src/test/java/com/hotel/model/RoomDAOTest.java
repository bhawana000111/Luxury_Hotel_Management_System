package com.hotel.model;

import static org.junit.Assert.*;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

import static org.mockito.Mockito.*;

/**
 * Unit tests for RoomDAO
 */
public class RoomDAOTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockPreparedStatement;

    @Mock
    private Statement mockStatement;

    @Mock
    private ResultSet mockResultSet;

    private RoomDAO roomDAO;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        roomDAO = new RoomDAO();

        // Mock database connection
        when(mockConnection.prepareStatement(anyString(), anyInt())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.createStatement()).thenReturn(mockStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockStatement.executeQuery(anyString())).thenReturn(mockResultSet);
    }

    @Test
    public void testGetById_RoomExists() throws Exception {
        // Arrange
        int roomId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("id")).thenReturn(roomId);
        when(mockResultSet.getString("type")).thenReturn("Deluxe");
        when(mockResultSet.getString("number")).thenReturn("101");
        when(mockResultSet.getBigDecimal("price")).thenReturn(new BigDecimal("150.00"));
        when(mockResultSet.getBoolean("availability")).thenReturn(true);
        when(mockResultSet.getString("description")).thenReturn("A luxurious room");

        // Act
        Room room = roomDAO.getById(roomId);

        // Assert
        assertNotNull("Room should not be null", room);
        assertEquals("Room ID should match", roomId, room.getId());
        assertEquals("Room type should match", "Deluxe", room.getType());
        assertEquals("Room number should match", "101", room.getNumber());
        assertEquals("Room price should match", new BigDecimal("150.00"), room.getPrice());
        assertTrue("Room should be available", room.isAvailability());
        assertEquals("Room description should match", "A luxurious room", room.getDescription());
    }

    @Test
    public void testGetById_RoomDoesNotExist() throws Exception {
        // Arrange
        int roomId = 999;
        when(mockResultSet.next()).thenReturn(false);

        // Act
        Room room = roomDAO.getById(roomId);

        // Assert
        assertNull("Room should be null", room);
    }

    @Test
    public void testCreate_Success() throws Exception {
        // Arrange
        Room newRoom = new Room();
        newRoom.setType("Suite");
        newRoom.setNumber("201");
        newRoom.setPrice(new BigDecimal("250.00"));
        newRoom.setAvailability(true);
        newRoom.setDescription("A spacious suite");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        // Act
        int roomId = roomDAO.create(newRoom);

        // Assert
        assertTrue("Room ID should be positive", roomId > 0);
        verify(mockPreparedStatement).setString(1, newRoom.getType());
        verify(mockPreparedStatement).setString(2, newRoom.getNumber());
        verify(mockPreparedStatement).setBigDecimal(3, newRoom.getPrice());
        verify(mockPreparedStatement).setBoolean(4, newRoom.isAvailability());
        verify(mockPreparedStatement).setString(5, newRoom.getDescription());
    }

    @Test
    public void testCreate_Failure() throws Exception {
        // Arrange
        Room newRoom = new Room();
        newRoom.setType("Suite");
        newRoom.setNumber("201");
        newRoom.setPrice(new BigDecimal("250.00"));
        newRoom.setAvailability(true);
        newRoom.setDescription("A spacious suite");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        int roomId = roomDAO.create(newRoom);

        // Assert
        assertEquals("Room ID should be -1 on failure", -1, roomId);
    }

    @Test
    public void testGetAll() throws Exception {
        // Arrange
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First room
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getString("type")).thenReturn("Deluxe").thenReturn("Suite");
        when(mockResultSet.getString("number")).thenReturn("101").thenReturn("201");
        when(mockResultSet.getBigDecimal("price")).thenReturn(new BigDecimal("150.00")).thenReturn(new BigDecimal("250.00"));
        when(mockResultSet.getBoolean("availability")).thenReturn(true).thenReturn(true);
        when(mockResultSet.getString("description")).thenReturn("A luxurious room").thenReturn("A spacious suite");

        // Act
        List<Room> rooms = roomDAO.getAll();

        // Assert
        assertNotNull("Rooms list should not be null", rooms);
        assertEquals("Rooms list should have 2 items", 2, rooms.size());
        assertEquals("First room type should match", "Deluxe", rooms.get(0).getType());
        assertEquals("Second room type should match", "Suite", rooms.get(1).getType());
    }

    @Test
    public void testUpdate_Success() throws Exception {
        // Arrange
        Room room = new Room();
        room.setId(1);
        room.setType("Updated Suite");
        room.setNumber("301");
        room.setPrice(new BigDecimal("300.00"));
        room.setAvailability(true);
        room.setDescription("An updated suite");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = roomDAO.update(room);

        // Assert
        assertTrue("Update should return true on success", result);
        verify(mockPreparedStatement).setString(1, room.getType());
        verify(mockPreparedStatement).setString(2, room.getNumber());
        verify(mockPreparedStatement).setBigDecimal(3, room.getPrice());
        verify(mockPreparedStatement).setBoolean(4, room.isAvailability());
        verify(mockPreparedStatement).setString(5, room.getDescription());
        verify(mockPreparedStatement).setInt(7, room.getId());
    }

    @Test
    public void testUpdate_Failure() throws Exception {
        // Arrange
        Room room = new Room();
        room.setId(999);
        room.setType("Updated Suite");
        room.setNumber("301");
        room.setPrice(new BigDecimal("300.00"));
        room.setAvailability(true);
        room.setDescription("An updated suite");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = roomDAO.update(room);

        // Assert
        assertFalse("Update should return false on failure", result);
    }

    @Test
    public void testDelete_Success() throws Exception {
        // Arrange
        int roomId = 1;
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = roomDAO.delete(roomId);

        // Assert
        assertTrue("Delete should return true on success", result);
        verify(mockPreparedStatement).setInt(1, roomId);
    }

    @Test
    public void testDelete_Failure() throws Exception {
        // Arrange
        int roomId = 999;
        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = roomDAO.delete(roomId);

        // Assert
        assertFalse("Delete should return false on failure", result);
    }

    @Test
    public void testGetAllAvailable() throws Exception {
        // Arrange
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First room
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getString("type")).thenReturn("Deluxe").thenReturn("Suite");
        when(mockResultSet.getString("number")).thenReturn("101").thenReturn("201");
        when(mockResultSet.getBigDecimal("price")).thenReturn(new BigDecimal("150.00")).thenReturn(new BigDecimal("250.00"));
        when(mockResultSet.getBoolean("availability")).thenReturn(true).thenReturn(true);
        when(mockResultSet.getString("description")).thenReturn("A luxurious room").thenReturn("A spacious suite");

        // Act
        List<Room> rooms = roomDAO.getAllAvailable();

        // Assert
        assertNotNull("Rooms list should not be null", rooms);
        assertEquals("Rooms list should have 2 items", 2, rooms.size());
        assertEquals("First room type should match", "Deluxe", rooms.get(0).getType());
        assertEquals("Second room type should match", "Suite", rooms.get(1).getType());
    }

    @Test
    public void testGetAvailableByType() throws Exception {
        // Arrange
        String roomType = "Deluxe";
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);

        when(mockResultSet.getInt("id")).thenReturn(1);
        when(mockResultSet.getString("type")).thenReturn(roomType);
        when(mockResultSet.getString("number")).thenReturn("101");
        when(mockResultSet.getBigDecimal("price")).thenReturn(new BigDecimal("150.00"));
        when(mockResultSet.getBoolean("availability")).thenReturn(true);
        when(mockResultSet.getString("description")).thenReturn("A luxurious room");

        // Act
        List<Room> rooms = roomDAO.getAvailableByType(roomType);

        // Assert
        assertNotNull("Rooms list should not be null", rooms);
        assertEquals("Rooms list should have 1 item", 1, rooms.size());
        assertEquals("Room type should match", roomType, rooms.get(0).getType());
    }

    @Test
    public void testIsRoomAvailableForDates_Available() throws Exception {
        // Arrange
        int roomId = 1;
        Date checkInDate = Date.valueOf("2023-01-01");
        Date checkOutDate = Date.valueOf("2023-01-05");

        when(mockResultSet.next()).thenReturn(false);

        // Act
        boolean result = roomDAO.isRoomAvailableForDates(roomId, checkInDate, checkOutDate);

        // Assert
        assertTrue("Room should be available for the dates", result);
    }

    @Test
    public void testIsRoomAvailableForDates_NotAvailable() throws Exception {
        // Arrange
        int roomId = 1;
        Date checkInDate = Date.valueOf("2023-01-01");
        Date checkOutDate = Date.valueOf("2023-01-05");

        when(mockResultSet.next()).thenReturn(true);

        // Act
        boolean result = roomDAO.isRoomAvailableForDates(roomId, checkInDate, checkOutDate);

        // Assert
        assertFalse("Room should not be available for the dates", result);
    }

    @Test
    public void testSearchRooms() throws Exception {
        // Arrange
        String type = "Deluxe";
        BigDecimal minPrice = new BigDecimal("100.00");
        BigDecimal maxPrice = new BigDecimal("200.00");

        when(mockResultSet.next()).thenReturn(true).thenReturn(false);

        when(mockResultSet.getInt("id")).thenReturn(1);
        when(mockResultSet.getString("type")).thenReturn(type);
        when(mockResultSet.getString("number")).thenReturn("101");
        when(mockResultSet.getBigDecimal("price")).thenReturn(new BigDecimal("150.00"));
        when(mockResultSet.getBoolean("availability")).thenReturn(true);
        when(mockResultSet.getString("description")).thenReturn("A luxurious room");

        // Act
        List<Room> rooms = roomDAO.searchRooms(type, minPrice, maxPrice, null, null, true);

        // Assert
        assertNotNull("Rooms list should not be null", rooms);
        assertEquals("Rooms list should have 1 item", 1, rooms.size());
        assertEquals("Room type should match", type, rooms.get(0).getType());
    }
}
