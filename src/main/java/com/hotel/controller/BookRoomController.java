package com.hotel.controller;

import com.hotel.model.Booking;
import com.hotel.model.BookingDAO;
import com.hotel.model.Room;
import com.hotel.model.RoomDAO;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

/**
 * Controller for booking rooms
 */
@WebServlet(name = "BookRoomController", urlPatterns = {"/bookRoom"})
public class BookRoomController extends HttpServlet {

    private RoomDAO roomDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
        bookingDAO = new BookingDAO();
    }

    /**
     * Set the RoomDAO (for testing)
     * @param roomDAO The RoomDAO to use
     */
    public void setRoomDAO(RoomDAO roomDAO) {
        this.roomDAO = roomDAO;
    }

    /**
     * Set the BookingDAO (for testing)
     * @param bookingDAO The BookingDAO to use
     */
    public void setBookingDAO(BookingDAO bookingDAO) {
        this.bookingDAO = bookingDAO;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String roomIdParam = request.getParameter("roomId");

        if (roomIdParam != null && !roomIdParam.trim().isEmpty()) {
            try {
                int roomId = Integer.parseInt(roomIdParam);
                Room room = roomDAO.getById(roomId);

                if (room != null && room.isAvailability()) {
                    request.setAttribute("room", room);
                    request.getRequestDispatcher("/book_room.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/rooms?error=Room not available for booking");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require login
        if (!SessionUtil.requireLogin(request, response)) {
            return;
        }

        String roomIdParam = request.getParameter("roomId");
        String dateFromParam = request.getParameter("dateFrom");
        String dateToParam = request.getParameter("dateTo");

        // Validate input
        if (roomIdParam == null || roomIdParam.trim().isEmpty() ||
            dateFromParam == null || dateFromParam.trim().isEmpty() ||
            dateToParam == null || dateToParam.trim().isEmpty()) {

            response.sendRedirect(request.getContextPath() +
                                 "/rooms?error=Invalid booking parameters");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdParam);
            Date dateFrom = Date.valueOf(dateFromParam);
            Date dateTo = Date.valueOf(dateToParam);

            // Validate dates
            LocalDate today = LocalDate.now();
            LocalDate checkInDate = dateFrom.toLocalDate();
            LocalDate checkOutDate = dateTo.toLocalDate();

            if (checkInDate.isBefore(today)) {
                response.sendRedirect(request.getContextPath() +
                                     "/room?id=" + roomId + "&error=Check-in date cannot be in the past");
                return;
            }

            if (checkOutDate.isBefore(checkInDate) || checkOutDate.equals(checkInDate)) {
                response.sendRedirect(request.getContextPath() +
                                     "/room?id=" + roomId + "&error=Check-out date must be after check-in date");
                return;
            }

            // Check if room is available for the selected dates
            Room room = roomDAO.getById(roomId);

            if (room == null || !room.isAvailability()) {
                response.sendRedirect(request.getContextPath() +
                                     "/rooms?error=Room not available for booking");
                return;
            }

            if (!roomDAO.isRoomAvailableForDates(roomId, dateFrom, dateTo)) {
                response.sendRedirect(request.getContextPath() +
                                     "/room?id=" + roomId + "&error=Room not available for the selected dates");
                return;
            }

            // Create booking
            int userId = SessionUtil.getLoggedInUserId(request);
            Booking booking = new Booking(userId, roomId, dateFrom, dateTo);

            int bookingId = bookingDAO.create(booking);

            if (bookingId > 0) {
                response.sendRedirect(request.getContextPath() +
                                     "/bookings?message=Booking successful");
            } else {
                response.sendRedirect(request.getContextPath() +
                                     "/room?id=" + roomId + "&error=Failed to create booking");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() +
                                 "/rooms?error=Invalid room ID");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() +
                                 "/rooms?error=Invalid date format");
        }
    }
}
