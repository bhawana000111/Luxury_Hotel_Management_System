package com.hotel.controller;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import com.hotel.model.Booking;
import com.hotel.model.BookingDAO;
import com.hotel.model.Room;
import com.hotel.model.RoomDAO;
import com.hotel.util.SessionUtil;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.sql.Date;

/**
 * Unit tests for BookRoomController
 */
public class BookRoomControllerTest {

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
    private BookingDAO bookingDAO;

    private BookRoomController bookRoomController;
    private StringWriter stringWriter;
    private PrintWriter writer;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        bookRoomController = new BookRoomController();

        // Set up response writer
        stringWriter = new StringWriter();
        writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        // Set up request and session
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        // Set up DAOs
        bookRoomController.setRoomDAO(roomDAO);
        bookRoomController.setBookingDAO(bookingDAO);
    }

    @Test
    public void testDoGet_NotLoggedIn() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(null);

        // Act
        bookRoomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_LoggedIn_ValidRoom() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");

        Room room = new Room();
        room.setId(1);
        room.setType("Deluxe");
        room.setNumber("101");
        room.setPrice(new BigDecimal("150.00"));
        room.setAvailability(true);
        room.setDescription("A luxurious room");

        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        bookRoomController.doGet(request, response);

        // Assert
        verify(request).setAttribute("room", room);
        verify(request).getRequestDispatcher("/book_room.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_LoggedIn_InvalidRoom() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("999");

        when(roomDAO.getById(999)).thenReturn(null);

        // Act
        bookRoomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/rooms?error="));
    }

    @Test
    public void testDoGet_LoggedIn_UnavailableRoom() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");

        Room room = new Room();
        room.setId(1);
        room.setType("Deluxe");
        room.setNumber("101");
        room.setPrice(new BigDecimal("150.00"));
        room.setAvailability(false);
        room.setDescription("A luxurious room");

        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        bookRoomController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/rooms?error="));
    }

    @Test
    public void testDoPost_NotLoggedIn() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(null);

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoPost_LoggedIn_MissingParameters() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("dateFrom")).thenReturn(null);
        when(request.getParameter("dateTo")).thenReturn("2023-01-05");

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/rooms?error="));
    }

    @Test
    public void testDoPost_LoggedIn_InvalidDates() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("dateFrom")).thenReturn("2023-01-05");
        when(request.getParameter("dateTo")).thenReturn("2023-01-01");

        Room room = new Room();
        room.setId(1);
        room.setAvailability(true);

        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/room?id=1&error="));
    }

    @Test
    public void testDoPost_LoggedIn_RoomNotAvailable() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("dateFrom")).thenReturn("2023-01-01");
        when(request.getParameter("dateTo")).thenReturn("2023-01-05");

        Room room = new Room();
        room.setId(1);
        room.setAvailability(false);

        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/rooms?error="));
    }

    @Test
    public void testDoPost_LoggedIn_RoomNotAvailableForDates() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("dateFrom")).thenReturn("2023-01-01");
        when(request.getParameter("dateTo")).thenReturn("2023-01-05");

        Room room = new Room();
        room.setId(1);
        room.setAvailability(true);

        when(roomDAO.getById(1)).thenReturn(room);
        when(roomDAO.isRoomAvailableForDates(1, Date.valueOf("2023-01-01"), Date.valueOf("2023-01-05"))).thenReturn(false);

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/room?id=1&error="));
    }

    @Test
    public void testDoPost_LoggedIn_Success() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("dateFrom")).thenReturn("2023-01-01");
        when(request.getParameter("dateTo")).thenReturn("2023-01-05");

        Room room = new Room();
        room.setId(1);
        room.setAvailability(true);

        when(roomDAO.getById(1)).thenReturn(room);
        when(roomDAO.isRoomAvailableForDates(1, Date.valueOf("2023-01-01"), Date.valueOf("2023-01-05"))).thenReturn(true);
        when(bookingDAO.create(any(Booking.class))).thenReturn(1);

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(bookingDAO).create(any(Booking.class));
        verify(response).sendRedirect(contains("/bookings?message="));
    }

    @Test
    public void testDoPost_LoggedIn_BookingCreationFailed() throws ServletException, IOException {
        // Arrange
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("roomId")).thenReturn("1");
        when(request.getParameter("dateFrom")).thenReturn("2023-01-01");
        when(request.getParameter("dateTo")).thenReturn("2023-01-05");

        Room room = new Room();
        room.setId(1);
        room.setAvailability(true);

        when(roomDAO.getById(1)).thenReturn(room);
        when(roomDAO.isRoomAvailableForDates(1, Date.valueOf("2023-01-01"), Date.valueOf("2023-01-05"))).thenReturn(true);
        when(bookingDAO.create(any(Booking.class))).thenReturn(-1);

        // Act
        bookRoomController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/room?id=1&error="));
    }
}
