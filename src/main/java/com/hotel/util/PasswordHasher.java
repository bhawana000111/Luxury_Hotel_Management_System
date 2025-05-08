package com.hotel.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Utility class for password hashing and verification
 */
public class PasswordHasher {

    /**
     * Hash a password using BCrypt
     * @param password The plain text password
     * @return The hashed password
     */
    public static String hashPassword(String password) {
        System.out.println("Hashing password...");
        try {
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt());
            System.out.println("Password hashed successfully: " + hashed.substring(0, 10) + "...");
            return hashed;
        } catch (Exception e) {
            System.out.println("Error hashing password: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Verify a password against a hashed password
     * @param password The plain text password
     * @param hashedPassword The hashed password
     * @return True if the password matches, false otherwise
     */
    public static boolean checkPassword(String password, String hashedPassword) {
        System.out.println("Checking password...");
        try {
            boolean result = BCrypt.checkpw(password, hashedPassword);
            System.out.println("Password check result: " + result);
            return result;
        } catch (Exception e) {
            System.out.println("Error checking password: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
