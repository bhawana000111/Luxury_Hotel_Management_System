package com.hotel.util;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

/**
 * Utility class for handling file uploads
 */
public class FileUploadUtil {
    
    private static final String UPLOAD_DIRECTORY = "assets";
    
    /**
     * Upload a file to the server
     * @param request The HttpServletRequest
     * @param partName The name of the file part in the form
     * @param subDirectory The subdirectory to save the file in (e.g., "images", "videos")
     * @return The path to the saved file, relative to the webapp directory
     * @throws IOException If an I/O error occurs
     * @throws ServletException If a servlet error occurs
     */
    public static String uploadFile(HttpServletRequest request, String partName, String subDirectory) 
            throws IOException, ServletException {
        
        Part filePart = request.getPart(partName);
        if (filePart == null || filePart.getSize() <= 0) {
            return null;
        }
        
        // Validate file type
        String fileName = getSubmittedFileName(filePart);
        String fileExtension = getFileExtension(fileName);
        
        if (!isValidFileType(fileExtension, subDirectory)) {
            throw new IllegalArgumentException("Invalid file type. Only " + 
                    (subDirectory.equals("images") ? "JPG, JPEG, PNG" : "MP4, WEBM") + 
                    " files are allowed.");
        }
        
        // Generate unique file name
        String uniqueFileName = UUID.randomUUID().toString() + "." + fileExtension;
        
        // Create directory if it doesn't exist
        String uploadPath = request.getServletContext().getRealPath("") + 
                File.separator + UPLOAD_DIRECTORY + 
                File.separator + subDirectory;
        
        Path directory = Paths.get(uploadPath);
        if (!Files.exists(directory)) {
            Files.createDirectories(directory);
        }
        
        // Save the file
        filePart.write(uploadPath + File.separator + uniqueFileName);
        
        // Return the relative path
        return UPLOAD_DIRECTORY + "/" + subDirectory + "/" + uniqueFileName;
    }
    
    /**
     * Get the submitted file name from a Part
     * @param part The Part containing the file
     * @return The file name
     */
    private static String getSubmittedFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                return item.substring(item.indexOf("=") + 2, item.length() - 1);
            }
        }
        
        return "";
    }
    
    /**
     * Get the file extension from a file name
     * @param fileName The file name
     * @return The file extension
     */
    private static String getFileExtension(String fileName) {
        if (fileName == null || fileName.isEmpty() || !fileName.contains(".")) {
            return "";
        }
        
        return fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
    }
    
    /**
     * Check if the file type is valid for the given subdirectory
     * @param fileExtension The file extension
     * @param subDirectory The subdirectory
     * @return True if the file type is valid, false otherwise
     */
    private static boolean isValidFileType(String fileExtension, String subDirectory) {
        if (subDirectory.equals("images")) {
            return fileExtension.equals("jpg") || 
                   fileExtension.equals("jpeg") || 
                   fileExtension.equals("png");
        } else if (subDirectory.equals("videos")) {
            return fileExtension.equals("mp4") || 
                   fileExtension.equals("webm");
        }
        
        return false;
    }
}
