package com.hotel.controller;

import com.hotel.model.Event;
import com.hotel.model.EventDAO;
import com.hotel.util.FileUploadUtil;
import com.hotel.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Controller for event-related operations
 */
@WebServlet(name = "EventController", urlPatterns = {
    "/events", "/event", "/admin/events", "/admin/addEvent", "/admin/editEvent", "/admin/deleteEvent"
})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 5 * 1024 * 1024,    // 5 MB
    maxRequestSize = 10 * 1024 * 1024 // 10 MB
)
public class EventController extends HttpServlet {
    
    private EventDAO eventDAO;
    
    @Override
    public void init() {
        eventDAO = new EventDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getServletPath();
        
        switch (action) {
            case "/events":
                listEvents(request, response);
                break;
            case "/event":
                showEvent(request, response);
                break;
            case "/admin/events":
                listEventsAdmin(request, response);
                break;
            case "/admin/addEvent":
                showAddEventForm(request, response);
                break;
            case "/admin/editEvent":
                showEditEventForm(request, response);
                break;
            case "/admin/deleteEvent":
                deleteEvent(request, response);
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
            case "/admin/addEvent":
                addEvent(request, response);
                break;
            case "/admin/editEvent":
                editEvent(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/index.jsp");
                break;
        }
    }
    
    /**
     * List all events for guests
     */
    private void listEvents(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String locationParam = request.getParameter("location");
        List<Event> events;
        
        if (locationParam != null && !locationParam.trim().isEmpty()) {
            events = eventDAO.getAllByLocation(locationParam);
            request.setAttribute("selectedLocation", locationParam);
        } else {
            events = eventDAO.getAllUpcoming();
        }
        
        request.setAttribute("events", events);
        request.getRequestDispatcher("/events.jsp").forward(request, response);
    }
    
    /**
     * Show a specific event
     */
    private void showEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int eventId = Integer.parseInt(idParam);
                Event event = eventDAO.getById(eventId);
                
                if (event != null) {
                    request.setAttribute("event", event);
                    request.getRequestDispatcher("/event_details.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/events?error=Event not found");
    }
    
    /**
     * List all events for admin
     */
    private void listEventsAdmin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String locationParam = request.getParameter("location");
        List<Event> events;
        
        if (locationParam != null && !locationParam.trim().isEmpty()) {
            events = eventDAO.getAllByLocation(locationParam);
            request.setAttribute("selectedLocation", locationParam);
        } else {
            events = eventDAO.getAll();
        }
        
        request.setAttribute("events", events);
        request.getRequestDispatcher("/admin/events.jsp").forward(request, response);
    }
    
    /**
     * Show add event form (admin only)
     */
    private void showAddEventForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
    }
    
    /**
     * Add a new event (admin only)
     */
    private void addEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String eventName = request.getParameter("eventName");
        String description = request.getParameter("description");
        String dateParam = request.getParameter("date");
        String location = request.getParameter("location");
        
        // Validate input
        if (eventName == null || eventName.trim().isEmpty() ||
            description == null || description.trim().isEmpty() ||
            dateParam == null || dateParam.trim().isEmpty() ||
            location == null || location.trim().isEmpty()) {
            
            request.setAttribute("error", "All fields are required");
            request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
            return;
        }
        
        try {
            Date date = Date.valueOf(dateParam);
            
            // Create event
            Event event = new Event(eventName, description, date, location);
            
            // Upload event image if provided
            try {
                String imagePath = FileUploadUtil.uploadFile(request, "eventImage", "images");
                if (imagePath != null) {
                    event.setImagePath(imagePath);
                }
            } catch (Exception e) {
                // Ignore if file upload fails
            }
            
            int eventId = eventDAO.create(event);
            
            if (eventId > 0) {
                response.sendRedirect(request.getContextPath() + 
                                     "/admin/events?message=Event added successfully");
            } else {
                request.setAttribute("error", "Failed to add event");
                request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Invalid date format");
            request.getRequestDispatcher("/admin/add_event.jsp").forward(request, response);
        }
    }
    
    /**
     * Show edit event form (admin only)
     */
    private void showEditEventForm(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int eventId = Integer.parseInt(idParam);
                Event event = eventDAO.getById(eventId);
                
                if (event != null) {
                    request.setAttribute("event", event);
                    request.getRequestDispatcher("/admin/edit_event.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/events?error=Event not found");
    }
    
    /**
     * Edit an event (admin only)
     */
    private void editEvent(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int eventId = Integer.parseInt(idParam);
                Event event = eventDAO.getById(eventId);
                
                if (event != null) {
                    String eventName = request.getParameter("eventName");
                    String description = request.getParameter("description");
                    String dateParam = request.getParameter("date");
                    String location = request.getParameter("location");
                    
                    // Validate input
                    if (eventName == null || eventName.trim().isEmpty() ||
                        description == null || description.trim().isEmpty() ||
                        dateParam == null || dateParam.trim().isEmpty() ||
                        location == null || location.trim().isEmpty()) {
                        
                        request.setAttribute("error", "All fields are required");
                        request.setAttribute("event", event);
                        request.getRequestDispatcher("/admin/edit_event.jsp").forward(request, response);
                        return;
                    }
                    
                    try {
                        Date date = Date.valueOf(dateParam);
                        
                        // Update event
                        event.setEventName(eventName);
                        event.setDescription(description);
                        event.setDate(date);
                        event.setLocation(location);
                        
                        // Upload event image if provided
                        try {
                            String imagePath = FileUploadUtil.uploadFile(request, "eventImage", "images");
                            if (imagePath != null) {
                                event.setImagePath(imagePath);
                            }
                        } catch (Exception e) {
                            // Ignore if file upload fails
                        }
                        
                        boolean updated = eventDAO.update(event);
                        
                        if (updated) {
                            response.sendRedirect(request.getContextPath() + 
                                                 "/admin/events?message=Event updated successfully");
                        } else {
                            request.setAttribute("error", "Failed to update event");
                            request.setAttribute("event", event);
                            request.getRequestDispatcher("/admin/edit_event.jsp").forward(request, response);
                        }
                    } catch (IllegalArgumentException e) {
                        request.setAttribute("error", "Invalid date format");
                        request.setAttribute("event", event);
                        request.getRequestDispatcher("/admin/edit_event.jsp").forward(request, response);
                    }
                    
                    return;
                }
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/events?error=Event not found");
    }
    
    /**
     * Delete an event (admin only)
     */
    private void deleteEvent(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        // Require admin
        if (!SessionUtil.requireAdmin(request, response)) {
            return;
        }
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int eventId = Integer.parseInt(idParam);
                boolean deleted = eventDAO.delete(eventId);
                
                if (deleted) {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/events?message=Event deleted successfully");
                } else {
                    response.sendRedirect(request.getContextPath() + 
                                         "/admin/events?error=Failed to delete event");
                }
                
                return;
            } catch (NumberFormatException e) {
                // Invalid ID, fall through to error
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/events?error=Event not found");
    }
}
