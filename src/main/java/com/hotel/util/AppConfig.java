package com.hotel.util;

/**
 * Application configuration
 */
public class AppConfig {
    
    private static final String BASE_URL = "http://localhost:8080/Luxury_HotelManagementSystem";
    
    /**
     * Get the base URL of the application
     * @return The base URL
     */
    public static String getBaseUrl() {
        return BASE_URL;
    }
}
