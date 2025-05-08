package com.hotel.model;

import com.hotel.util.CacheUtil;
import com.hotel.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * Data Access Object for Room entity
 */
public class RoomDAO {

    /**
     * Create a new room
     * @param room The room to create
     * @return The ID of the created room, or -1 if creation failed
     */
    public int create(Room room) {
        String sql = "INSERT INTO rooms (type, number, price, availability, description, image_path) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            stmt.setString(1, room.getType());
            stmt.setString(2, room.getNumber());
            stmt.setBigDecimal(3, room.getPrice());
            stmt.setBoolean(4, room.isAvailability());
            stmt.setString(5, room.getDescription());
            stmt.setString(6, room.getImagePath());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                } else {
                    return -1;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     * Get a room by ID
     * @param id The room ID
     * @return The room, or null if not found
     */
    public Room getById(int id) {
        // Check cache first
        String cacheKey = "room_" + id;
        Room cachedRoom = (Room) CacheUtil.get(cacheKey);

        if (cachedRoom != null) {
            return cachedRoom;
        }

        // If not in cache, get from database
        String sql = "SELECT * FROM rooms WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Room room = mapResultSetToRoom(rs);

                    // Cache the result
                    CacheUtil.put(cacheKey, room);

                    return room;
                } else {
                    return null;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Get all rooms
     * @return A list of all rooms
     */
    public List<Room> getAll() {
        String sql = "SELECT * FROM rooms ORDER BY type, number";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Get all available rooms
     * @return A list of all available rooms
     */
    public List<Room> getAllAvailable() {
        // Check cache first
        String cacheKey = "rooms_available";
        List<Room> cachedRooms = (List<Room>) CacheUtil.get(cacheKey);

        if (cachedRooms != null) {
            return cachedRooms;
        }

        // If not in cache, get from database
        String sql = "SELECT * FROM rooms WHERE availability = TRUE ORDER BY type, number";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }

            // Cache the result (shorter expiration time since availability changes frequently)
            CacheUtil.put(cacheKey, rooms, 60); // 1 minute cache

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Get available rooms by type
     * @param type The room type
     * @return A list of available rooms of the specified type
     */
    public List<Room> getAvailableByType(String type) {
        String sql = "SELECT * FROM rooms WHERE availability = TRUE AND type = ? ORDER BY number";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, type);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Get all room types
     * @return A list of distinct room types
     */
    public List<String> getAllTypes() {
        String sql = "SELECT DISTINCT type FROM rooms ORDER BY type";
        List<String> types = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                types.add(rs.getString("type"));
            }

            return types;
        } catch (SQLException e) {
            e.printStackTrace();
            return types;
        }
    }

    /**
     * Update a room
     * @param room The room to update
     * @return True if the update was successful, false otherwise
     */
    public boolean update(Room room) {
        String sql = "UPDATE rooms SET type = ?, number = ?, price = ?, availability = ?, " +
                     "description = ?, image_path = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, room.getType());
            stmt.setString(2, room.getNumber());
            stmt.setBigDecimal(3, room.getPrice());
            stmt.setBoolean(4, room.isAvailability());
            stmt.setString(5, room.getDescription());
            stmt.setString(6, room.getImagePath());
            stmt.setInt(7, room.getId());

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                // Invalidate cache
                CacheUtil.remove("room_" + room.getId());
                CacheUtil.remove("rooms_available");
                CacheUtil.remove("rooms_all");
                CacheUtil.remove("room_types");
                CacheUtil.remove("price_range");

                return true;
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Delete a room
     * @param id The ID of the room to delete
     * @return True if the deletion was successful, false otherwise
     */
    public boolean delete(int id) {
        String sql = "DELETE FROM rooms WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            int affectedRows = stmt.executeUpdate();

            if (affectedRows > 0) {
                // Invalidate cache
                CacheUtil.remove("room_" + id);
                CacheUtil.remove("rooms_available");
                CacheUtil.remove("rooms_all");
                CacheUtil.remove("room_types");
                CacheUtil.remove("price_range");

                return true;
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a room number is already in use
     * @param number The room number to check
     * @return True if the room number is already in use, false otherwise
     */
    public boolean isRoomNumberInUse(String number) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE number = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, number);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Check if a room number is already in use by another room
     * @param number The room number to check
     * @param id The ID of the room to exclude from the check
     * @return True if the room number is already in use by another room, false otherwise
     */
    public boolean isRoomNumberInUseByAnother(String number, int id) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE number = ? AND id != ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, number);
            stmt.setInt(2, id);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Get featured rooms for the homepage
     * @param limit The maximum number of rooms to return
     * @return A list of featured rooms
     */
    public List<Room> getFeaturedRooms(int limit) {
        String sql = "SELECT * FROM rooms WHERE availability = TRUE ORDER BY price DESC LIMIT ?";
        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Check if a room is available for a specific date range
     * @param roomId The room ID
     * @param checkInDate The check-in date
     * @param checkOutDate The check-out date
     * @return True if the room is available, false otherwise
     */
    public boolean isRoomAvailableForDates(int roomId, Date checkInDate, Date checkOutDate) {
        String sql = "SELECT COUNT(*) FROM bookings " +
                     "WHERE room_id = ? AND status != 'CANCELLED' AND " +
                     "((date_from <= ? AND date_to >= ?) OR " +
                     "(date_from <= ? AND date_to >= ?) OR " +
                     "(date_from >= ? AND date_to <= ?))";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomId);
            stmt.setDate(2, checkInDate);
            stmt.setDate(3, checkInDate);
            stmt.setDate(4, checkOutDate);
            stmt.setDate(5, checkOutDate);
            stmt.setDate(6, checkInDate);
            stmt.setDate(7, checkOutDate);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }

            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Search for rooms with advanced filtering
     * @param type The room type (optional)
     * @param minPrice The minimum price (optional)
     * @param maxPrice The maximum price (optional)
     * @param checkInDate The check-in date (optional)
     * @param checkOutDate The check-out date (optional)
     * @param onlyAvailable Whether to only include available rooms
     * @return A list of rooms matching the criteria
     */
    public List<Room> searchRooms(String type, BigDecimal minPrice, BigDecimal maxPrice,
                                 Date checkInDate, Date checkOutDate, boolean onlyAvailable) {

        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM rooms WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Add type filter
        if (type != null && !type.trim().isEmpty()) {
            sqlBuilder.append(" AND type = ?");
            params.add(type);
        }

        // Add price range filter
        if (minPrice != null) {
            sqlBuilder.append(" AND price >= ?");
            params.add(minPrice);
        }

        if (maxPrice != null) {
            sqlBuilder.append(" AND price <= ?");
            params.add(maxPrice);
        }

        // Add availability filter
        if (onlyAvailable) {
            sqlBuilder.append(" AND availability = TRUE");
        }

        sqlBuilder.append(" ORDER BY type, number");

        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sqlBuilder.toString())) {

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    stmt.setString(i + 1, (String) param);
                } else if (param instanceof BigDecimal) {
                    stmt.setBigDecimal(i + 1, (BigDecimal) param);
                } else if (param instanceof Boolean) {
                    stmt.setBoolean(i + 1, (Boolean) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Room room = mapResultSetToRoom(rs);

                    // Check date availability if dates are provided
                    if (checkInDate != null && checkOutDate != null) {
                        if (isRoomAvailableForDates(room.getId(), checkInDate, checkOutDate)) {
                            rooms.add(room);
                        }
                    } else {
                        rooms.add(room);
                    }
                }
            }

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Get rooms available for a specific date range
     * @param checkInDate The check-in date
     * @param checkOutDate The check-out date
     * @return A list of available rooms for the date range
     */
    public List<Room> getAvailableRoomsForDates(Date checkInDate, Date checkOutDate) {
        String sql = "SELECT r.* FROM rooms r WHERE r.availability = TRUE " +
                     "AND r.id NOT IN (SELECT b.room_id FROM bookings b " +
                     "WHERE b.status != 'CANCELLED' AND " +
                     "((b.date_from <= ? AND b.date_to >= ?) OR " +
                     "(b.date_from <= ? AND b.date_to >= ?) OR " +
                     "(b.date_from >= ? AND b.date_to <= ?))) " +
                     "ORDER BY r.type, r.number";

        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setDate(1, checkInDate);
            stmt.setDate(2, checkInDate);
            stmt.setDate(3, checkOutDate);
            stmt.setDate(4, checkOutDate);
            stmt.setDate(5, checkInDate);
            stmt.setDate(6, checkOutDate);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Get rooms available for a specific date range by type
     * @param type The room type
     * @param checkInDate The check-in date
     * @param checkOutDate The check-out date
     * @return A list of available rooms of the specified type for the date range
     */
    public List<Room> getAvailableRoomsForDatesByType(String type, Date checkInDate, Date checkOutDate) {
        String sql = "SELECT r.* FROM rooms r WHERE r.availability = TRUE AND r.type = ? " +
                     "AND r.id NOT IN (SELECT b.room_id FROM bookings b " +
                     "WHERE b.status != 'CANCELLED' AND " +
                     "((b.date_from <= ? AND b.date_to >= ?) OR " +
                     "(b.date_from <= ? AND b.date_to >= ?) OR " +
                     "(b.date_from >= ? AND b.date_to <= ?))) " +
                     "ORDER BY r.number";

        List<Room> rooms = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, type);
            stmt.setDate(2, checkInDate);
            stmt.setDate(3, checkInDate);
            stmt.setDate(4, checkOutDate);
            stmt.setDate(5, checkOutDate);
            stmt.setDate(6, checkInDate);
            stmt.setDate(7, checkOutDate);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }

            return rooms;
        } catch (SQLException e) {
            e.printStackTrace();
            return rooms;
        }
    }

    /**
     * Get the price range of all rooms
     * @return An array with the minimum and maximum prices
     */
    public BigDecimal[] getPriceRange() {
        String sql = "SELECT MIN(price) as min_price, MAX(price) as max_price FROM rooms";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                BigDecimal minPrice = rs.getBigDecimal("min_price");
                BigDecimal maxPrice = rs.getBigDecimal("max_price");

                return new BigDecimal[] { minPrice, maxPrice };
            }

            return new BigDecimal[] { BigDecimal.ZERO, BigDecimal.ZERO };
        } catch (SQLException e) {
            e.printStackTrace();
            return new BigDecimal[] { BigDecimal.ZERO, BigDecimal.ZERO };
        }
    }

    /**
     * Map a ResultSet to a Room object
     * @param rs The ResultSet
     * @return The Room object
     * @throws SQLException If a database access error occurs
     */
    private Room mapResultSetToRoom(ResultSet rs) throws SQLException {
        Room room = new Room();
        room.setId(rs.getInt("id"));
        room.setType(rs.getString("type"));
        room.setNumber(rs.getString("number"));
        room.setPrice(rs.getBigDecimal("price"));
        room.setAvailability(rs.getBoolean("availability"));
        room.setDescription(rs.getString("description"));
        room.setImagePath(rs.getString("image_path"));
        room.setCreatedAt(rs.getTimestamp("created_at"));
        room.setUpdatedAt(rs.getTimestamp("updated_at"));

        return room;
    }
}