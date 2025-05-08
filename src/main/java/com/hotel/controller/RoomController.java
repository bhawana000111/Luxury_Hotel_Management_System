package com.hotel.controller;

import com.hotel.model.Room;
import com.hotel.model.RoomDAO;
import com.hotel.util.FileUploadUtil;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

/**
 * Controller for room-related operations
 */
@WebServlet(name = "RoomController", urlPatterns = {
    "/rooms", "/room",
    "/admin/rooms", "/admin/addRoom", "/admin/editRoom", "/admin/deleteRoom"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,    // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class RoomController extends HttpServlet {

    private RoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new RoomDAO();
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
            case "/rooms":
                listRooms(request, response);
                break;
            case "/room":
                showRoom(request, response);
                break;
            case "/admin/rooms":
                listRoomsAdmin(request, response);
                break;
            case "/admin/addRoom":
                showAddRoomForm(request, response);
                break;
            case "/admin/editRoom":
                showEditRoomForm(request, response);
                break;
            case "/admin/deleteRoom":
                deleteRoom(request, response);
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
            case "/admin/addRoom":
                addRoom(request, response);
                break;
            case "/admin/editRoom":
                editRoom(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }

    /**
     * List all rooms for guests with advanced search
     */
    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get filter parameters
        String typeParam = request.getParameter("type");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String checkInParam = request.getParameter("checkIn");
        String checkOutParam = request.getParameter("checkOut");

        // Set attributes for form values
        request.setAttribute("selectedType", typeParam);
        request.setAttribute("minPrice", minPriceParam);
        request.setAttribute("maxPrice", maxPriceParam);
        request.setAttribute("checkIn", checkInParam);
        request.setAttribute("checkOut", checkOutParam);

        // Get all room types for the filter dropdown
        List<String> roomTypes = roomDAO.getAllTypes();
        request.setAttribute("roomTypes", roomTypes);

        // Get price range for the price slider
        BigDecimal[] priceRange = roomDAO.getPriceRange();
        request.setAttribute("minPriceRange", priceRange[0]);
        request.setAttribute("maxPriceRange", priceRange[1]);

        // Parse parameters
        BigDecimal minPrice = null;
        BigDecimal maxPrice = null;
        Date checkInDate = null;
        Date checkOutDate = null;

        if (minPriceParam != null && !minPriceParam.trim().isEmpty()) {
            try {
                minPrice = new BigDecimal(minPriceParam);
            } catch (NumberFormatException e) {
                // Ignore invalid format
            }
        }

        if (maxPriceParam != null && !maxPriceParam.trim().isEmpty()) {
            try {
                maxPrice = new BigDecimal(maxPriceParam);
            } catch (NumberFormatException e) {
                // Ignore invalid format
            }
        }

        if (checkInParam != null && !checkInParam.trim().isEmpty()) {
            try {
                checkInDate = Date.valueOf(checkInParam);
            } catch (IllegalArgumentException e) {
                // Ignore invalid format
            }
        }

        if (checkOutParam != null && !checkOutParam.trim().isEmpty()) {
            try {
                checkOutDate = Date.valueOf(checkOutParam);
            } catch (IllegalArgumentException e) {
                // Ignore invalid format
            }
        }

        // Perform search
        List<Room> rooms;

        if (checkInDate != null && checkOutDate != null) {
            // Date-based search
            if (typeParam != null && !typeParam.trim().isEmpty()) {
                rooms = roomDAO.getAvailableRoomsForDatesByType(typeParam, checkInDate, checkOutDate);
            } else {
                rooms = roomDAO.getAvailableRoomsForDates(checkInDate, checkOutDate);
            }

            // Apply price filters if needed
            if (minPrice != null || maxPrice != null) {
                final BigDecimal finalMinPrice = minPrice;
                final BigDecimal finalMaxPrice = maxPrice;
                rooms = rooms.stream()
                        .filter(room -> (finalMinPrice == null || room.getPrice().compareTo(finalMinPrice) >= 0) &&
                                       (finalMaxPrice == null || room.getPrice().compareTo(finalMaxPrice) <= 0))
                        .toList();
            }
        } else {
            // Advanced search without dates
            rooms = roomDAO.searchRooms(typeParam, minPrice, maxPrice, null, null, true);
        }

        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/rooms.jsp").forward(request, response);
    }

    /**
     * Show a specific room
     */
    private void showRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int roomId = Integer.parseInt(idParam);
                Room room = roomDAO.getById(roomId);

                if (room != null) {
                    request.setAttribute("room", room);
                    request.getRequestDispatcher("/room_details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/rooms?error=Room not found");
    }

    /**
     * List all rooms for admin
     */
    private void listRoomsAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String typeParam = request.getParameter("type");
        List<Room> rooms;

        if (typeParam != null && !typeParam.trim().isEmpty()) {
            // Filter rooms by type
            List<Room> allRooms = roomDAO.getAll();
            rooms = allRooms.stream()
                    .filter(room -> room.getType().equals(typeParam))
                    .toList();
            request.setAttribute("selectedType", typeParam);
        } else {
            rooms = roomDAO.getAll();
        }

        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/admin/rooms.jsp").forward(request, response);
    }

    /**
     * Show add room form (admin only)
     */
    private void showAddRoomForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        request.getRequestDispatcher("/admin/add_room.jsp").forward(request, response);
    }

    /**
     * Add a new room (admin only)
     */
    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String type = request.getParameter("type");
        String number = request.getParameter("number");
        String priceStr = request.getParameter("price");
        String availabilityStr = request.getParameter("availability");
        String description = request.getParameter("description");

        // Validate input
        if (type == null || type.trim().isEmpty() ||
            number == null || number.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty()) {

            request.setAttribute("error", "Type, number, and price are required");
            request.getRequestDispatcher("/admin/add_room.jsp").forward(request, response);
            return;
        }

        // Check if room number is already in use
        if (roomDAO.isRoomNumberInUse(number)) {
            request.setAttribute("error", "Room number is already in use");
            request.getRequestDispatcher("/admin/add_room.jsp").forward(request, response);
            return;
        }

        try {
            BigDecimal price = new BigDecimal(priceStr);
            boolean availability = availabilityStr != null && availabilityStr.equals("true");

            // Create room
            Room room = new Room(type, number, price, availability);
            room.setDescription(description);

            // Upload room image if provided
            try {
                String imagePath = FileUploadUtil.uploadFile(request, "roomImage", "images");
                if (imagePath != null) {
                    room.setImagePath(imagePath);
                }
            } catch (Exception e) {
                // Ignore if file upload fails
            }

            int roomId = roomDAO.create(room);

            if (roomId > 0) {
                response.sendRedirect(request.getContextPath() +
                                     "/admin/rooms?message=Room added successfully");
            } else {
                request.setAttribute("error", "Failed to add room");
                request.getRequestDispatcher("/admin/add_room.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid price format");
            request.getRequestDispatcher("/admin/add_room.jsp").forward(request, response);
        }
    }

    /**
     * Show edit room form (admin only)
     */
    private void showEditRoomForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int roomId = Integer.parseInt(idParam);
                Room room = roomDAO.getById(roomId);

                if (room != null) {
                    request.setAttribute("room", room);
                    request.getRequestDispatcher("/admin/edit_room.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/rooms?error=Room not found");
    }

    /**
     * Edit a room (admin only)
     */
    private void editRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int roomId = Integer.parseInt(idParam);
                Room room = roomDAO.getById(roomId);

                if (room != null) {
                    String type = request.getParameter("type");
                    String number = request.getParameter("number");
                    String priceStr = request.getParameter("price");
                    String availabilityStr = request.getParameter("availability");
                    String description = request.getParameter("description");

                    // Validate input
                    if (type == null || type.trim().isEmpty() ||
                        number == null || number.trim().isEmpty() ||
                        priceStr == null || priceStr.trim().isEmpty()) {

                        request.setAttribute("error", "Type, number, and price are required");
                        request.setAttribute("room", room);
                        request.getRequestDispatcher("/admin/edit_room.jsp").forward(request, response);
                        return;
                    }

                    // Check if room number is already in use by another room
                    if (roomDAO.isRoomNumberInUseByAnother(number, roomId)) {
                        request.setAttribute("error", "Room number is already in use by another room");
                        request.setAttribute("room", room);
                        request.getRequestDispatcher("/admin/edit_room.jsp").forward(request, response);
                        return;
                    }

                    try {
                        BigDecimal price = new BigDecimal(priceStr);
                        boolean availability = availabilityStr != null && availabilityStr.equals("true");

                        // Update room
                        room.setType(type);
                        room.setNumber(number);
                        room.setPrice(price);
                        room.setAvailability(availability);
                        room.setDescription(description);

                        // Upload room image if provided
                        try {
                            String imagePath = FileUploadUtil.uploadFile(request, "roomImage", "images");
                            if (imagePath != null) {
                                room.setImagePath(imagePath);
                            }
                        } catch (Exception e) {
                            // Ignore if file upload fails
                        }

                        boolean updated = roomDAO.update(room);

                        if (updated) {
                            response.sendRedirect(request.getContextPath() +
                                                 "/admin/rooms?message=Room updated successfully");
                        } else {
                            request.setAttribute("error", "Failed to update room");
                            request.setAttribute("room", room);
                            request.getRequestDispatcher("/admin/edit_room.jsp").forward(request, response);
                        }
                    } catch (NumberFormatException e) {
                        request.setAttribute("error", "Invalid price format");
                        request.setAttribute("room", room);
                        request.getRequestDispatcher("/admin/edit_room.jsp").forward(request, response);
                    }

                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/rooms?error=Room not found");
    }

    /**
     * Delete a room (admin only)
     */
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int roomId = Integer.parseInt(idParam);
                boolean deleted = roomDAO.delete(roomId);

                if (deleted) {
                    response.sendRedirect(request.getContextPath() +
                                         "/admin/rooms?message=Room deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() +
                                         "/admin/rooms?error=Failed to delete room");
                }

                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/rooms?error=Room not found");
    }
}
