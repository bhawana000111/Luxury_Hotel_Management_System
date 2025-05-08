package com.hotel.controller;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import com.hotel.model.Booking;
import com.hotel.model.BookingDAO;
import com.hotel.model.Payment;
import com.hotel.model.PaymentDAO;
import com.hotel.model.Room;
import com.hotel.model.RoomDAO;

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
 * Unit tests for PaymentController
 */
public class PaymentControllerTest {

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private HttpSession session;

    @Mock
    private RequestDispatcher dispatcher;

    @Mock
    private PaymentDAO paymentDAO;

    @Mock
    private BookingDAO bookingDAO;

    @Mock
    private RoomDAO roomDAO;

    private PaymentController paymentController;
    private StringWriter stringWriter;
    private PrintWriter writer;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        paymentController = new PaymentController();

        // Set up response writer
        stringWriter = new StringWriter();
        writer = new PrintWriter(stringWriter);
        when(response.getWriter()).thenReturn(writer);

        // Set up request and session
        when(request.getSession()).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);

        // Set up DAOs
        paymentController.setPaymentDAO(paymentDAO);
        paymentController.setBookingDAO(bookingDAO);
        paymentController.setRoomDAO(roomDAO);
    }

    @Test
    public void testDoGet_Payment_NotLoggedIn() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/payment");
        when(session.getAttribute("userId")).thenReturn(null);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoGet_Payment_LoggedIn_ValidBooking() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/payment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("1");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(1);
        booking.setRoomId(1);
        booking.setDateFrom(Date.valueOf("2023-01-01"));
        booking.setDateTo(Date.valueOf("2023-01-05"));
        booking.setStatus("PENDING");

        Room room = new Room();
        room.setId(1);
        room.setType("Deluxe");
        room.setNumber("101");
        room.setPrice(new BigDecimal("150.00"));

        when(bookingDAO.getById(1)).thenReturn(booking);
        when(roomDAO.getById(1)).thenReturn(room);
        when(paymentDAO.getByBookingId(1)).thenReturn(null);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(request).setAttribute("booking", booking);
        verify(request).setAttribute("room", room);
        verify(request).setAttribute(eq("nights"), anyLong());
        verify(request).setAttribute(eq("totalAmount"), any(BigDecimal.class));
        verify(request).getRequestDispatcher("/payment.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_Payment_LoggedIn_InvalidBooking() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/payment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("999");

        when(bookingDAO.getById(999)).thenReturn(null);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/bookings?error="));
    }

    @Test
    public void testDoGet_Payment_LoggedIn_UnauthorizedBooking() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/payment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(session.getAttribute("userRole")).thenReturn("USER");
        when(request.getParameter("bookingId")).thenReturn("1");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(2); // Different user
        booking.setRoomId(1);
        booking.setStatus("PENDING");

        when(bookingDAO.getById(1)).thenReturn(booking);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/bookings?error="));
    }

    @Test
    public void testDoGet_Payment_LoggedIn_AlreadyPaid() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/payment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("1");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(1);
        booking.setRoomId(1);
        booking.setStatus("PENDING");

        Payment payment = new Payment();
        payment.setId(1);
        payment.setBookingId(1);
        payment.setStatus("COMPLETED");

        when(bookingDAO.getById(1)).thenReturn(booking);
        when(paymentDAO.getByBookingId(1)).thenReturn(payment);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/booking?id=1&message="));
    }

    @Test
    public void testDoGet_PaymentSuccess() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/paymentSuccess");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("id")).thenReturn("1");

        Payment payment = new Payment();
        payment.setId(1);
        payment.setBookingId(1);
        payment.setStatus("COMPLETED");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setRoomId(1);

        Room room = new Room();
        room.setId(1);

        when(paymentDAO.getById(1)).thenReturn(payment);
        when(bookingDAO.getById(1)).thenReturn(booking);
        when(roomDAO.getById(1)).thenReturn(room);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(request).setAttribute("payment", payment);
        verify(request).setAttribute("booking", booking);
        verify(request).setAttribute("room", room);
        verify(request).getRequestDispatcher("/payment_success.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_PaymentCancel() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/paymentCancel");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("id")).thenReturn("1");

        Payment payment = new Payment();
        payment.setId(1);
        payment.setBookingId(1);
        payment.setStatus("FAILED");

        Booking booking = new Booking();
        booking.setId(1);

        when(paymentDAO.getById(1)).thenReturn(payment);
        when(bookingDAO.getById(1)).thenReturn(booking);

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(request).setAttribute("payment", payment);
        verify(request).setAttribute("booking", booking);
        verify(request).getRequestDispatcher("/payment_cancel.jsp");
        verify(dispatcher).forward(request, response);
    }

    @Test
    public void testDoGet_AdminPayments_NotAdmin() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/admin/payments");
        when(session.getAttribute("userRole")).thenReturn("USER");

        // Act
        paymentController.doGet(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoPost_ProcessPayment_NotLoggedIn() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/processPayment");
        when(session.getAttribute("userId")).thenReturn(null);

        // Act
        paymentController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/login"));
    }

    @Test
    public void testDoPost_ProcessPayment_LoggedIn_MissingParameters() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/processPayment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("1");
        when(request.getParameter("amount")).thenReturn(null);
        when(request.getParameter("paymentMethod")).thenReturn("CREDIT_CARD");

        // Act
        paymentController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/bookings?error="));
    }

    @Test
    public void testDoPost_ProcessPayment_LoggedIn_InvalidBooking() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/processPayment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("999");
        when(request.getParameter("amount")).thenReturn("150.00");
        when(request.getParameter("paymentMethod")).thenReturn("CREDIT_CARD");

        when(bookingDAO.getById(999)).thenReturn(null);

        // Act
        paymentController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/bookings?error="));
    }

    @Test
    public void testDoPost_ProcessPayment_LoggedIn_UnauthorizedBooking() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/processPayment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(session.getAttribute("userRole")).thenReturn("USER");
        when(request.getParameter("bookingId")).thenReturn("1");
        when(request.getParameter("amount")).thenReturn("150.00");
        when(request.getParameter("paymentMethod")).thenReturn("CREDIT_CARD");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(2); // Different user

        when(bookingDAO.getById(1)).thenReturn(booking);

        // Act
        paymentController.doPost(request, response);

        // Assert
        verify(response).sendRedirect(contains("/bookings?error="));
    }

    @Test
    public void testDoPost_ProcessPayment_LoggedIn_NewPayment_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/processPayment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("1");
        when(request.getParameter("amount")).thenReturn("150.00");
        when(request.getParameter("paymentMethod")).thenReturn("CREDIT_CARD");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(1);

        when(bookingDAO.getById(1)).thenReturn(booking);
        when(paymentDAO.getByBookingId(1)).thenReturn(null);
        when(paymentDAO.create(any(Payment.class))).thenReturn(1);
        when(paymentDAO.processPayment(any(Payment.class))).thenReturn(true);
        when(bookingDAO.update(any(Booking.class))).thenReturn(true);

        // Act
        paymentController.doPost(request, response);

        // Assert
        verify(paymentDAO).create(any(Payment.class));
        verify(paymentDAO).processPayment(any(Payment.class));
        verify(bookingDAO).update(any(Booking.class));
        verify(response).sendRedirect(contains("/paymentSuccess?id="));
    }

    @Test
    public void testDoPost_ProcessPayment_LoggedIn_ExistingPayment_Success() throws ServletException, IOException {
        // Arrange
        when(request.getServletPath()).thenReturn("/processPayment");
        when(session.getAttribute("userId")).thenReturn(1);
        when(request.getParameter("bookingId")).thenReturn("1");
        when(request.getParameter("amount")).thenReturn("150.00");
        when(request.getParameter("paymentMethod")).thenReturn("CREDIT_CARD");

        Booking booking = new Booking();
        booking.setId(1);
        booking.setUserId(1);

        Payment existingPayment = new Payment();
        existingPayment.setId(1);
        existingPayment.setBookingId(1);
        existingPayment.setStatus("PENDING");

        when(bookingDAO.getById(1)).thenReturn(booking);
        when(paymentDAO.getByBookingId(1)).thenReturn(existingPayment);
        when(paymentDAO.update(any(Payment.class))).thenReturn(true);
        when(paymentDAO.processPayment(any(Payment.class))).thenReturn(true);
        when(bookingDAO.update(any(Booking.class))).thenReturn(true);

        // Act
        paymentController.doPost(request, response);

        // Assert
        verify(paymentDAO).update(any(Payment.class));
        verify(paymentDAO).processPayment(any(Payment.class));
        verify(bookingDAO).update(any(Booking.class));
        verify(response).sendRedirect(contains("/paymentSuccess?id="));
    }
}
