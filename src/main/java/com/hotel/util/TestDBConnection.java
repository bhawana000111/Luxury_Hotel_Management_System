package com.hotel.util;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Test class for database connection
 */
public class TestDBConnection {
    
    public static void main(String[] args) {
        try {
            System.out.println("Testing database connection...");
            Connection conn = DBConnection.getConnection();
            System.out.println("Connection successful!");
            DBConnection.closeConnection(conn);
        } catch (SQLException e) {
            System.err.println("Connection failed: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
