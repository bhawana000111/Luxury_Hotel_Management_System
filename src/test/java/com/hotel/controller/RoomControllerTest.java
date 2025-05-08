package com.hotel.controller;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import com.hotel.model.Room;
import com.hotel.model.RoomDAO;
import com.hotel.util.FileUploadUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

/**
 * Unit tests for RoomController
 */
public class RoomControllerTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher dispatcher;

    @Mock
    private RoomDAO roomDAO;

    @Mock
    private Part filePart;

    private RoomController roomController;
    private StringWriter stringWriter;
    private PrintWriter writer;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        roomController = new RoomController();

        // Set up response writer
        stringWriter = new StringWriter();
        writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        // Set up request and session
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        // Set up roomDAO
        roomController.setRoomDAO(roomDAO);
    }

    @Test
    public void testDoGet_Rooms() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/rooms");

        List<Room> rooms = new ArrayList<>();
        Room room1 = new Room();
        room1.setId(1);
        room1.setType("Deluxe");
        room1.setPrice(new BigDecimal("150.00"));
        room1.setAvailability(true);

        Room room2 = new Room();
        room2.setId(2);
        room2.setType("Suite");
        room2.setPrice(new BigDecimal("250.00"));
        room2.setAvailability(true);

        rooms.add(room1);
        rooms.add(room2);

        List<String> roomTypes = new ArrayList<>();
        roomTypes.add("Deluxe");
        roomTypes.add("Suite");

        BigDecimal[] priceRange = new BigDecimal[] { new BigDecimal("100.00"), new BigDecimal("300.00") };

        when(roomDAO.getAllAvailable()).thenReturn(rooms);
        when(roomDAO.getAllTypes()).thenReturn(roomTypes);
        when(roomDAO.getPriceRange()).thenReturn(priceRange);

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(request).setAttribute("rooms", rooms);
        verify(request).setAttribute("roomTypes", roomTypes);
        verify(request).setAttribute("minPriceRange", priceRange[0]);
        verify(request).setAttribute("maxPriceRange", priceRange[1]);
        verify(request).getRequestDispatcher("/rooms.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_RoomDetails() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/room");
        when(request.getParameter("id")).thenReturn("1");

        Room room = new Room();
        room.setId(1);
        room.setType("Deluxe");
        room.setNumber("101");
        room.setPrice(new BigDecimal("150.00"));
        room.setAvailability(true);
        room.setDescription("A luxurious room");

        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(request).setAttribute("room", room);
        verify(request).getRequestDispatcher("/room_details.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_RoomDetails_InvalidId() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/room");
        when(request.getParameter("id")).thenReturn("999");

        when(roomDAO.getById(999)).thenReturn(null);

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/rooms?error="));
    }

    @Test
    public void testDoGet_AdminRooms_NotAdmin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/rooms");
        when(session.getAttribute("userRole")).thenReturn("USER");

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_AdminRooms_Admin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/rooms");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");

        List<Room> rooms = new ArrayList<>();
        rooms.add(new Room());
        rooms.add(new Room());

        when(roomDAO.getAll()).thenReturn(rooms);

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(request).setAttribute("rooms", rooms);
        verify(request).getRequestDispatcher("/admin/rooms.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_AdminAddRoom_NotAdmin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/addRoom");
        when(session.getAttribute("userRole")).thenReturn("USER");

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_AdminAddRoom_Admin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/addRoom");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(request).getRequestDispatcher("/admin/add_room.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_AdminEditRoom_NotAdmin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/editRoom");
        when(session.getAttribute("userRole")).thenReturn("USER");

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_AdminEditRoom_Admin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/editRoom");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");
        when(request.getParameter("id")).thenReturn("1");

        Room room = new Room();
        room.setId(1);
        room.setType("Deluxe");
        room.setNumber("101");
        room.setPrice(new BigDecimal("150.00"));
        room.setAvailability(true);
        room.setDescription("A luxurious room");

        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        roomController.doGet(request, response);

        // Assert
        verify(request).setAttribute("room", room);
        verify(request).getRequestDispatcher("/admin/edit_room.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoPost_AdminAddRoom_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/addRoom");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");

        when(request.getParameter("type")).thenReturn("Deluxe");
        when(request.getParameter("number")).thenReturn("101");
        when(request.getParameter("price")).thenReturn("150.00");
        when(request.getParameter("availability")).thenReturn("true");
        when(request.getParameter("description")).thenReturn("A luxurious room");

        when(roomDAO.create(any(Room.class))).thenReturn(1);

        // Act
        roomController.doPost(request, response);

        // Assert
        verify(roomDAO).create(any(Room.class));
        verify(response).sendRedirect(contains("/admin/rooms?message="));
    }

    @Test
    public void testDoPost_AdminEditRoom_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/editRoom");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");

        when(request.getParameter("id")).thenReturn("1");
        when(request.getParameter("type")).thenReturn("Deluxe");
        when(request.getParameter("number")).thenReturn("101");
        when(request.getParameter("price")).thenReturn("150.00");
        when(request.getParameter("availability")).thenReturn("true");
        when(request.getParameter("description")).thenReturn("A luxurious room");

        Room room = new Room();
        room.setId(1);

        when(roomDAO.getById(1)).thenReturn(room);
        when(roomDAO.update(any(Room.class))).thenReturn(true);

        // Act
        roomController.doPost(request, response);

        // Assert
        verify(roomDAO).update(any(Room.class));
        verify(response).sendRedirect(contains("/admin/rooms?message="));
    }

    @Test
    public void testDoPost_AdminDeleteRoom_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/deleteRoom");
        when(session.getAttribute("userRole")).thenReturn("ADMIN");

        when(request.getParameter("id")).thenReturn("1");

        when(roomDAO.delete(1)).thenReturn(true);

        // Act
        roomController.doPost(request, response);

        // Assert
        verify(roomDAO).delete(1);
        verify(response).sendRedirect(contains("/admin/rooms?message="));
    }

    @Test
    public void testDoPost_SearchRooms() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/searchRooms");

        when(request.getParameter("type")).thenReturn("Deluxe");
        when(request.getParameter("checkIn")).thenReturn("2023-01-01");
        when(request.getParameter("checkOut")).thenReturn("2023-01-05");
        when(request.getParameter("minPrice")).thenReturn("100.00");
        when(request.getParameter("maxPrice")).thenReturn("200.00");

        List<Room> rooms = new ArrayList<>();
        Room room = new Room();
        room.setId(1);
        room.setType("Deluxe");
        room.setPrice(new BigDecimal("150.00"));
        room.setAvailability(true);
        rooms.add(room);

        when(roomDAO.searchRooms(eq("Deluxe"), any(BigDecimal.class), any(BigDecimal.class), any(Date.class), any(Date.class), eq(true)))
                .thenReturn(rooms);

        // Act
        roomController.doPost(request, response);

        // Assert
        verify(request).setAttribute("rooms", rooms);
        verify(request).getRequestDispatcher("/rooms.jsp");
        verify(dispatcher).forward(request, response);
    }
}
