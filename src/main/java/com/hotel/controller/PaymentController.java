package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.model.BookingDAO;
import com.hotel.model.Payment;
import com.hotel.model.PaymentDAO;
import com.hotel.model.Room;
import com.hotel.model.RoomDAO;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Controller for payment-related operations
 */
@WebServlet(name = "PaymentController", urlPatterns = {
    "/payment", "/processPayment", "/paymentSuccess", "/paymentCancel",
    "/admin/payments", "/admin/payment"
})
public class PaymentController extends HttpServlet {

    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;

    @Override
    public void init() {
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
    }

    /**
     * Set the PaymentDAO (for testing)
     * @param paymentDAO The PaymentDAO to use
     */
    public void setPaymentDAO(PaymentDAO paymentDAO) {
        this.paymentDAO = paymentDAO;
    }

    /**
     * Set the BookingDAO (for testing)
     * @param bookingDAO The BookingDAO to use
     */
    public void setBookingDAO(BookingDAO bookingDAO) {
        this.bookingDAO = bookingDAO;
    }

    /**
     * Set the RoomDAO (for testing)
     * @param roomDAO The RoomDAO to use
     */
    public void setRoomDAO(RoomDAO roomDAO) {
        this.roomDAO = roomDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/payment":
                showPaymentForm(request, response);
                break;
            case "/paymentSuccess":
                handlePaymentSuccess(request, response);
                break;
            case "/paymentCancel":
                handlePaymentCancel(request, response);
                break;
            case "/admin/payments":
                listPayments(request, response);
                break;
            case "/admin/payment":
                showPaymentDetails(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/processPayment":
                processPayment(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    /**
     * Show payment form
     */
    private void showPaymentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");

        if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                Booking booking = bookingDAO.getById(bookingId);

                if (booking != null) {
                    // Check if the booking belongs to the logged-in user
                    int userId = SessionUtil.getLoggedInUserId(request);
                    if (booking.getUserId() != userId && !SessionUtil.isAdmin(request)) {
                        response.sendRedirect(request.getContextPath() + "/bookings?error=Unauthorized access");
                        return;
                    }

                    // Check if payment already exists
                    Payment existingPayment = paymentDAO.getByBookingId(bookingId);
                    if (existingPayment != null && "COMPLETED".equals(existingPayment.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "/booking?id=" + bookingId + "&message=Payment already completed");
                        return;
                    }

                    // Calculate total amount
                    Room room = roomDAO.getById(booking.getRoomId());
                    LocalDate checkIn = booking.getDateFrom().toLocalDate();
                    LocalDate checkOut = booking.getDateTo().toLocalDate();
                    long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                    BigDecimal totalAmount = room.getPrice().multiply(BigDecimal.valueOf(nights));

                    request.setAttribute("booking", booking);
                    request.setAttribute("room", room);
                    request.setAttribute("nights", nights);
                    request.setAttribute("totalAmount", totalAmount);

                    request.getRequestDispatcher("/payment.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/bookings?error=Invalid booking");
    }

    /**
     * Process payment
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String bookingIdParam = request.getParameter("bookingId");
        String amountParam = request.getParameter("amount");
        String paymentMethod = request.getParameter("paymentMethod");

        if (bookingIdParam != null && !bookingIdParam.trim().isEmpty() &&
            amountParam != null && !amountParam.trim().isEmpty() &&
            paymentMethod != null && !paymentMethod.trim().isEmpty()) {

            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                BigDecimal amount = new BigDecimal(amountParam);

                Booking booking = bookingDAO.getById(bookingId);

                if (booking != null) {
                    // Check if the booking belongs to the logged-in user
                    int userId = SessionUtil.getLoggedInUserId(request);
                    if (booking.getUserId() != userId && !SessionUtil.isAdmin(request)) {
                        response.sendRedirect(request.getContextPath() + "/bookings?error=Unauthorized access");
                        return;
                    }

                    // Check if payment already exists
                    Payment existingPayment = paymentDAO.getByBookingId(bookingId);
                    if (existingPayment != null) {
                        if ("COMPLETED".equals(existingPayment.getStatus())) {
                            response.sendRedirect(request.getContextPath() + "/booking?id=" + bookingId + "&message=Payment already completed");
                            return;
                        }

                        // Update existing payment
                        existingPayment.setAmount(amount);
                        existingPayment.setPaymentMethod(paymentMethod);
                        existingPayment.setStatus("PENDING");

                        boolean updated = paymentDAO.update(existingPayment);

                        if (updated) {
                            // Simulate payment processing
                            boolean processed = paymentDAO.processPayment(existingPayment);

                            if (processed) {
                                // Update booking status
                                booking.setStatus("CONFIRMED");
                                bookingDAO.update(booking);

                                response.sendRedirect(request.getContextPath() + "/paymentSuccess?id=" + existingPayment.getId());
                            } else {
                                response.sendRedirect(request.getContextPath() + "/paymentCancel?id=" + existingPayment.getId());
                            }
                        } else {
                            response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId + "&error=Payment update failed");
                        }
                    } else {
                        // Create new payment
                        Payment payment = new Payment(bookingId, amount, paymentMethod);

                        int paymentId = paymentDAO.create(payment);

                        if (paymentId > 0) {
                            payment.setId(paymentId);

                            // Simulate payment processing
                            boolean processed = paymentDAO.processPayment(payment);

                            if (processed) {
                                // Update booking status
                                booking.setStatus("CONFIRMED");
                                bookingDAO.update(booking);

                                response.sendRedirect(request.getContextPath() + "/paymentSuccess?id=" + paymentId);
                            } else {
                                response.sendRedirect(request.getContextPath() + "/paymentCancel?id=" + paymentId);
                            }
                        } else {
                            response.sendRedirect(request.getContextPath() + "/payment?bookingId=" + bookingId + "&error=Payment creation failed");
                        }
                    }
                } else {
                    response.sendRedirect(request.getContextPath() + "/bookings?error=Invalid booking");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/bookings?error=Invalid parameters");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/bookings?error=Missing parameters");
        }
    }

    /**
     * Handle payment success
     */
    private void handlePaymentSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int paymentId = Integer.parseInt(idParam);
                Payment payment = paymentDAO.getById(paymentId);

                if (payment != null) {
                    Booking booking = bookingDAO.getById(payment.getBookingId());
                    Room room = roomDAO.getById(booking.getRoomId());

                    request.setAttribute("payment", payment);
                    request.setAttribute("booking", booking);
                    request.setAttribute("room", room);

                    request.getRequestDispatcher("/payment_success.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/bookings?error=Invalid payment");
    }

    /**
     * Handle payment cancel
     */
    private void handlePaymentCancel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int paymentId = Integer.parseInt(idParam);
                Payment payment = paymentDAO.getById(paymentId);

                if (payment != null) {
                    Booking booking = bookingDAO.getById(payment.getBookingId());

                    request.setAttribute("payment", payment);
                    request.setAttribute("booking", booking);

                    request.getRequestDispatcher("/payment_cancel.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/bookings?error=Invalid payment");
    }

    /**
     * List all payments (admin only)
     */
    private void listPayments(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        java.util.List<Payment> payments = paymentDAO.getAll();
        request.setAttribute("payments", payments);

        // Get total revenue
        BigDecimal totalRevenue = paymentDAO.getTotalRevenue();
        request.setAttribute("totalRevenue", totalRevenue);

        request.getRequestDispatcher("/admin/payments.jsp").forward(request, response);
    }

    /**
     * Show payment details (admin only)
     */
    private void showPaymentDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int paymentId = Integer.parseInt(idParam);
                Payment payment = paymentDAO.getById(paymentId);

                if (payment != null) {
                    Booking booking = bookingDAO.getById(payment.getBookingId());
                    Room room = roomDAO.getById(booking.getRoomId());

                    request.setAttribute("payment", payment);
                    request.setAttribute("booking", booking);
                    request.setAttribute("room", room);

                    request.getRequestDispatcher("/admin/payment_details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/payments?error=Invalid payment");
    }
}
