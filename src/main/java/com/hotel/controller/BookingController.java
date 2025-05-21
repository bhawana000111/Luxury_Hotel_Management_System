package com.hotel.controller;

import com.hotel.model.*;
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
import java.util.List;

/**
 * Controller for booking-related operations
 */
@WebServlet(name = "BookingController", urlPatterns = {
    "/bookings", "/booking", "/cancelBooking",
    "/admin/bookings", "/admin/booking", "/admin/updateBooking"
})
public class BookingController extends HttpServlet {

    private BookingDAO bookingDAO;
    private RoomDAO roomDAO;
    private BillingDAO billingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
        roomDAO = new RoomDAO();
        billingDAO = new BillingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getServletPath();

        switch (action) {
            case "/bookings":
                listBookings(request, response);
                break;
            case "/booking":
                showBooking(request, response);
                break;
            case "/cancelBooking":
                cancelBooking(request, response);
                break;
            case "/admin/bookings":
                listBookingsAdmin(request, response);
                break;
            case "/admin/booking":
                showBookingAdmin(request, response);
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
            case "/admin/updateBooking":
                updateBooking(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    /**
     * List all bookings for the logged-in user
     */
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        int userId = SessionUtil.getLoggedInUserId(request);
        List<Booking> bookings = bookingDAO.getAllByUserId(userId);

        // Get billing information for each booking
        for (Booking booking : bookings) {
            Billing billing = billingDAO.getByBookingId(booking.getId());
            booking.setBilling(billing);
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/bookings.jsp").forward(request, response);
    }

    /**
     * Show a specific booking for the logged-in user
     */
    private void showBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(idParam);
                Booking booking = bookingDAO.getById(bookingId);

                if (booking != null) {
                    // Check if the booking belongs to the logged-in user
                    int userId = SessionUtil.getLoggedInUserId(request);
                    if (booking.getUserId() != userId && !SessionUtil.isAdmin(request)) {
                        response.sendRedirect(request.getContextPath() +
                                             "/bookings?error=Access denied");
                        return;
                    }

                    // Get billing information
                    Billing billing = billingDAO.getByBookingId(bookingId);

                    request.setAttribute("booking", booking);
                    request.setAttribute("billing", billing);
                    request.getRequestDispatcher("/booking_details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/bookings?error=Booking not found");
    }



    /**
     * Cancel a booking
     */
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(idParam);
                Booking booking = bookingDAO.getById(bookingId);

                if (booking != null) {
                    // Check if the booking belongs to the logged-in user
                    int userId = SessionUtil.getLoggedInUserId(request);
                    if (booking.getUserId() != userId && !SessionUtil.isAdmin(request)) {
                        response.sendRedirect(request.getContextPath() +
                                             "/bookings?error=Access denied");
                        return;
                    }

                    // Check if the booking can be cancelled
                    if (booking.getStatus().equals("CANCELLED") ||
                        booking.getStatus().equals("COMPLETED")) {

                        response.sendRedirect(request.getContextPath() +
                                             "/booking?id=" + bookingId +
                                             "&error=Booking cannot be cancelled");
                        return;
                    }

                    // Cancel booking
                    boolean updated = bookingDAO.updateStatus(bookingId, "CANCELLED");

                    if (updated) {
                        // Update billing status
                        Billing billing = billingDAO.getByBookingId(bookingId);
                        if (billing != null) {
                            billingDAO.updateStatus(billing.getId(), "REFUNDED", null);
                        }

                        response.sendRedirect(request.getContextPath() +
                                             "/booking?id=" + bookingId +
                                             "&message=Booking cancelled successfully");
                    } else {
                        response.sendRedirect(request.getContextPath() +
                                             "/booking?id=" + bookingId +
                                             "&error=Failed to cancel booking");
                    }

                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/bookings?error=Booking not found");
    }

    /**
     * List all bookings for admin
     */
    private void listBookingsAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String statusParam = request.getParameter("status");
        List<Booking> bookings;

        if (statusParam != null && !statusParam.trim().isEmpty()) {
            bookings = bookingDAO.getAllByStatus(statusParam);
            request.setAttribute("selectedStatus", statusParam);
        } else {
            bookings = bookingDAO.getAll();
        }

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/admin/bookings.jsp").forward(request, response);
    }

    /**
     * Show a specific booking for admin
     */
    private void showBookingAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int bookingId = Integer.parseInt(idParam);
                Booking booking = bookingDAO.getById(bookingId);

                if (booking != null) {
                    // Get billing information
                    Billing billing = billingDAO.getByBookingId(bookingId);

                    request.setAttribute("booking", booking);
                    request.setAttribute("billing", billing);
                    request.getRequestDispatcher("/admin/booking_details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings?error=Booking not found");
    }

    /**
     * Update booking status (admin only)
     */
    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");
        String status = request.getParameter("status");

        if (idParam != null && !idParam.trim().isEmpty() &&
            status != null && !status.trim().isEmpty()) {

            try {
                int bookingId = Integer.parseInt(idParam);
                Booking booking = bookingDAO.getById(bookingId);

                if (booking != null) {
                    // Update booking status
                    boolean updated = bookingDAO.updateStatus(bookingId, status);

                    if (updated) {
                        // Update billing status if needed
                        Billing billing = billingDAO.getByBookingId(bookingId);
                        if (billing != null) {
                            if (status.equals("CONFIRMED") &&
                                billing.getStatus().equals("PENDING")) {

                                billingDAO.updateStatus(billing.getId(), "PAID",
                                                       new java.sql.Timestamp(System.currentTimeMillis()));
                            } else if (status.equals("CANCELLED") &&
                                      !billing.getStatus().equals("REFUNDED")) {

                                billingDAO.updateStatus(billing.getId(), "REFUNDED", null);
                            }
                        }

                        response.sendRedirect(request.getContextPath() +
                                             "/admin/booking?id=" + bookingId +
                                             "&message=Booking status updated successfully");
                    } else {
                        response.sendRedirect(request.getContextPath() +
                                             "/admin/booking?id=" + bookingId +
                                             "&error=Failed to update booking status");
                    }

                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/bookings?error=Booking not found");
    }
}
