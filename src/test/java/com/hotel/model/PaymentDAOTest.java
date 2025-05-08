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
import java.sql.Timestamp;
import java.util.List;

import static org.mockito.Mockito.*;

/**
 * Unit tests for PaymentDAO
 */
public class PaymentDAOTest {

    @Mock
    private Connection mockConnection;

    @Mock
    private PreparedStatement mockPreparedStatement;

    @Mock
    private Statement mockStatement;

    @Mock
    private ResultSet mockResultSet;

    private PaymentDAO paymentDAO;

    @Before
    public void setUp() throws Exception {
        MockitoAnnotations.openMocks(this);
        paymentDAO = new PaymentDAO();

        // Mock database connection
        when(mockConnection.prepareStatement(anyString(), anyInt())).thenReturn(mockPreparedStatement);
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockConnection.createStatement()).thenReturn(mockStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockStatement.executeQuery(anyString())).thenReturn(mockResultSet);
    }

    @Test
    public void testGetById_PaymentExists() throws Exception {
        // Arrange
        int paymentId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("id")).thenReturn(paymentId);
        when(mockResultSet.getInt("booking_id")).thenReturn(1);
        when(mockResultSet.getBigDecimal("amount")).thenReturn(new BigDecimal("150.00"));
        when(mockResultSet.getString("payment_method")).thenReturn("CREDIT_CARD");
        when(mockResultSet.getString("transaction_id")).thenReturn("TXN123456");
        when(mockResultSet.getString("status")).thenReturn("COMPLETED");
        when(mockResultSet.getTimestamp("payment_date")).thenReturn(new Timestamp(System.currentTimeMillis()));
        when(mockResultSet.getString("booking_reference")).thenReturn("1");
        when(mockResultSet.getString("user_name")).thenReturn("John Doe");

        // Act
        Payment payment = paymentDAO.getById(paymentId);

        // Assert
        assertNotNull("Payment should not be null", payment);
        assertEquals("Payment ID should match", paymentId, payment.getId());
        assertEquals("Booking ID should match", 1, payment.getBookingId());
        assertEquals("Amount should match", new BigDecimal("150.00"), payment.getAmount());
        assertEquals("Payment method should match", "CREDIT_CARD", payment.getPaymentMethod());
        assertEquals("Transaction ID should match", "TXN123456", payment.getTransactionId());
        assertEquals("Status should match", "COMPLETED", payment.getStatus());
        assertNotNull("Payment date should not be null", payment.getPaymentDate());
        assertEquals("Booking reference should match", "1", payment.getBookingReference());
        assertEquals("User name should match", "John Doe", payment.getUserName());
    }

    @Test
    public void testGetById_PaymentDoesNotExist() throws Exception {
        // Arrange
        int paymentId = 999;
        when(mockResultSet.next()).thenReturn(false);

        // Act
        Payment payment = paymentDAO.getById(paymentId);

        // Assert
        assertNull("Payment should be null", payment);
    }

    @Test
    public void testCreate_Success() throws Exception {
        // Arrange
        Payment newPayment = new Payment();
        newPayment.setBookingId(1);
        newPayment.setAmount(new BigDecimal("150.00"));
        newPayment.setPaymentMethod("CREDIT_CARD");
        newPayment.setTransactionId("TXN123456");
        newPayment.setStatus("PENDING");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1);

        // Act
        int paymentId = paymentDAO.create(newPayment);

        // Assert
        assertTrue("Payment ID should be positive", paymentId > 0);
        verify(mockPreparedStatement).setInt(1, newPayment.getBookingId());
        verify(mockPreparedStatement).setBigDecimal(2, newPayment.getAmount());
        verify(mockPreparedStatement).setString(3, newPayment.getPaymentMethod());
        verify(mockPreparedStatement).setString(4, newPayment.getTransactionId());
        verify(mockPreparedStatement).setString(5, newPayment.getStatus());
    }

    @Test
    public void testCreate_Failure() throws Exception {
        // Arrange
        Payment newPayment = new Payment();
        newPayment.setBookingId(1);
        newPayment.setAmount(new BigDecimal("150.00"));
        newPayment.setPaymentMethod("CREDIT_CARD");
        newPayment.setTransactionId("TXN123456");
        newPayment.setStatus("PENDING");

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        int paymentId = paymentDAO.create(newPayment);

        // Assert
        assertEquals("Payment ID should be -1 on failure", -1, paymentId);
    }

    @Test
    public void testGetByBookingId_PaymentExists() throws Exception {
        // Arrange
        int bookingId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(false);
        when(mockResultSet.getInt("id")).thenReturn(1);
        when(mockResultSet.getInt("booking_id")).thenReturn(bookingId);
        when(mockResultSet.getBigDecimal("amount")).thenReturn(new BigDecimal("150.00"));
        when(mockResultSet.getString("payment_method")).thenReturn("CREDIT_CARD");
        when(mockResultSet.getString("transaction_id")).thenReturn("TXN123456");
        when(mockResultSet.getString("status")).thenReturn("COMPLETED");
        when(mockResultSet.getTimestamp("payment_date")).thenReturn(new Timestamp(System.currentTimeMillis()));
        when(mockResultSet.getString("booking_reference")).thenReturn("1");
        when(mockResultSet.getString("user_name")).thenReturn("John Doe");

        // Act
        Payment payment = paymentDAO.getByBookingId(bookingId);

        // Assert
        assertNotNull("Payment should not be null", payment);
        assertEquals("Booking ID should match", bookingId, payment.getBookingId());
    }

    @Test
    public void testGetByBookingId_PaymentDoesNotExist() throws Exception {
        // Arrange
        int bookingId = 999;
        when(mockResultSet.next()).thenReturn(false);

        // Act
        Payment payment = paymentDAO.getByBookingId(bookingId);

        // Assert
        assertNull("Payment should be null", payment);
    }

    @Test
    public void testGetAll() throws Exception {
        // Arrange
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First payment
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getInt("booking_id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getBigDecimal("amount")).thenReturn(new BigDecimal("150.00")).thenReturn(new BigDecimal("200.00"));
        when(mockResultSet.getString("payment_method")).thenReturn("CREDIT_CARD").thenReturn("PAYPAL");
        when(mockResultSet.getString("transaction_id")).thenReturn("TXN123456").thenReturn("TXN789012");
        when(mockResultSet.getString("status")).thenReturn("COMPLETED").thenReturn("PENDING");
        when(mockResultSet.getTimestamp("payment_date")).thenReturn(new Timestamp(System.currentTimeMillis())).thenReturn(null);
        when(mockResultSet.getString("booking_reference")).thenReturn("1").thenReturn("2");
        when(mockResultSet.getString("user_name")).thenReturn("John Doe").thenReturn("Jane Smith");

        // Act
        List<Payment> payments = paymentDAO.getAll();

        // Assert
        assertNotNull("Payments list should not be null", payments);
        assertEquals("Payments list should have 2 items", 2, payments.size());
        assertEquals("First payment status should match", "COMPLETED", payments.get(0).getStatus());
        assertEquals("Second payment status should match", "PENDING", payments.get(1).getStatus());
    }

    @Test
    public void testGetByUserId() throws Exception {
        // Arrange
        int userId = 1;
        when(mockResultSet.next()).thenReturn(true).thenReturn(true).thenReturn(false);

        // First payment
        when(mockResultSet.getInt("id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getInt("booking_id")).thenReturn(1).thenReturn(2);
        when(mockResultSet.getBigDecimal("amount")).thenReturn(new BigDecimal("150.00")).thenReturn(new BigDecimal("200.00"));
        when(mockResultSet.getString("payment_method")).thenReturn("CREDIT_CARD").thenReturn("PAYPAL");
        when(mockResultSet.getString("transaction_id")).thenReturn("TXN123456").thenReturn("TXN789012");
        when(mockResultSet.getString("status")).thenReturn("COMPLETED").thenReturn("PENDING");
        when(mockResultSet.getTimestamp("payment_date")).thenReturn(new Timestamp(System.currentTimeMillis())).thenReturn(null);
        when(mockResultSet.getString("booking_reference")).thenReturn("1").thenReturn("2");
        when(mockResultSet.getString("user_name")).thenReturn("John Doe").thenReturn("John Doe");

        // Act
        List<Payment> payments = paymentDAO.getByUserId(userId);

        // Assert
        assertNotNull("Payments list should not be null", payments);
        assertEquals("Payments list should have 2 items", 2, payments.size());
        assertEquals("First payment status should match", "COMPLETED", payments.get(0).getStatus());
        assertEquals("Second payment status should match", "PENDING", payments.get(1).getStatus());
    }

    @Test
    public void testUpdate_Success() throws Exception {
        // Arrange
        Payment payment = new Payment();
        payment.setId(1);
        payment.setAmount(new BigDecimal("150.00"));
        payment.setPaymentMethod("CREDIT_CARD");
        payment.setTransactionId("TXN123456");
        payment.setStatus("COMPLETED");
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = paymentDAO.update(payment);

        // Assert
        assertTrue("Update should return true on success", result);
        verify(mockPreparedStatement).setBigDecimal(1, payment.getAmount());
        verify(mockPreparedStatement).setString(2, payment.getPaymentMethod());
        verify(mockPreparedStatement).setString(3, payment.getTransactionId());
        verify(mockPreparedStatement).setString(4, payment.getStatus());
        verify(mockPreparedStatement).setTimestamp(5, payment.getPaymentDate());
        verify(mockPreparedStatement).setInt(6, payment.getId());
    }

    @Test
    public void testUpdate_Failure() throws Exception {
        // Arrange
        Payment payment = new Payment();
        payment.setId(999);
        payment.setAmount(new BigDecimal("150.00"));
        payment.setPaymentMethod("CREDIT_CARD");
        payment.setTransactionId("TXN123456");
        payment.setStatus("COMPLETED");
        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));

        when(mockPreparedStatement.executeUpdate()).thenReturn(0);

        // Act
        boolean result = paymentDAO.update(payment);

        // Assert
        assertFalse("Update should return false on failure", result);
    }

    @Test
    public void testProcessPayment_Success() throws Exception {
        // Arrange
        Payment payment = new Payment();
        payment.setId(1);
        payment.setBookingId(1);
        payment.setAmount(new BigDecimal("150.00"));
        payment.setPaymentMethod("CREDIT_CARD");
        payment.setStatus("PENDING");

        when(mockPreparedStatement.executeUpdate()).thenReturn(1);

        // Act
        boolean result = paymentDAO.processPayment(payment);

        // Assert
        assertTrue("Process payment should return true on success", result);
        assertEquals("Payment status should be COMPLETED", "COMPLETED", payment.getStatus());
        assertNotNull("Payment date should not be null", payment.getPaymentDate());
        assertNotNull("Transaction ID should not be null", payment.getTransactionId());
    }

    @Test
    public void testGetTotalRevenue() throws Exception {
        // Arrange
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getBigDecimal(1)).thenReturn(new BigDecimal("1000.00"));

        // Act
        BigDecimal totalRevenue = paymentDAO.getTotalRevenue();

        // Assert
        assertEquals("Total revenue should match", new BigDecimal("1000.00"), totalRevenue);
    }

    @Test
    public void testGetRevenueForPeriod() throws Exception {
        // Arrange
        Date startDate = Date.valueOf("2023-01-01");
        Date endDate = Date.valueOf("2023-01-31");

        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getBigDecimal(1)).thenReturn(new BigDecimal("500.00"));

        // Act
        BigDecimal revenue = paymentDAO.getRevenueForPeriod(startDate, endDate);

        // Assert
        assertEquals("Revenue for period should match", new BigDecimal("500.00"), revenue);
        verify(mockPreparedStatement).setDate(1, startDate);
        verify(mockPreparedStatement).setDate(2, endDate);
    }
}
