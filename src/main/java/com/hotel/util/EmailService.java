package com.hotel.util;

import com.hotel.model.Booking;
import com.hotel.model.Payment;
import com.hotel.model.Room;
import com.hotel.model.User;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;
import java.text.SimpleDateFormat;

/**
 * Email service for sending notifications
 */
public class EmailService {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_USERNAME = "your-email@gmail.com"; // Replace with your email
    private static final String EMAIL_PASSWORD = "your-password"; // Replace with your password
    private static final String SENDER_NAME = "Luxury Hotel";

    /**
     * Send an email
     * @param to Recipient email address
     * @param subject Email subject
     * @param body Email body (HTML)
     * @return True if the email was sent successfully, false otherwise
     */
    public static boolean sendEmail(String to, String subject, String body) {
        try {
            // Set up mail server properties
            Properties properties = new Properties();
            properties.put("mail.smtp.host", SMTP_HOST);
            properties.put("mail.smtp.port", SMTP_PORT);
            properties.put("mail.smtp.auth", "true");
            properties.put("mail.smtp.starttls.enable", "true");

            // Create a session with authentication
            Session session = Session.getInstance(properties, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_USERNAME, EMAIL_PASSWORD);
                }
            });

            // Create a message
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_USERNAME, SENDER_NAME));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);

            // Set the HTML content
            message.setContent(body, "text/html; charset=utf-8");

            // Send the message
            Transport.send(message);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Send a booking confirmation email
     * @param user The user who made the booking
     * @param booking The booking details
     * @param room The room details
     * @return True if the email was sent successfully, false otherwise
     */
    public static boolean sendBookingConfirmation(User user, Booking booking, Room room) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        String checkIn = dateFormat.format(booking.getDateFrom());
        String checkOut = dateFormat.format(booking.getDateTo());

        String subject = "Booking Confirmation - Luxury Hotel";

        String body = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>"
                + "<div style='background-color: #1a1a1a; color: #fff; padding: 20px; text-align: center;'>"
                + "<h1>Luxury Hotel</h1>"
                + "</div>"
                + "<div style='padding: 20px; border: 1px solid #ddd;'>"
                + "<h2>Booking Confirmation</h2>"
                + "<p>Dear " + user.getName() + ",</p>"
                + "<p>Thank you for choosing Luxury Hotel. Your booking has been confirmed.</p>"
                + "<h3>Booking Details</h3>"
                + "<table style='width: 100%; border-collapse: collapse;'>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Booking ID:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + booking.getId() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Type:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getType() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Number:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getNumber() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-in Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkIn + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-out Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkOut + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Status:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + booking.getStatus() + "</td></tr>"
                + "</table>"
                + "<h3>Important Information</h3>"
                + "<ul>"
                + "<li>Check-in time: 2:00 PM</li>"
                + "<li>Check-out time: 12:00 PM</li>"
                + "<li>Please present a valid ID and the credit card used for booking upon check-in.</li>"
                + "<li>For any changes or cancellations, please contact us at least 24 hours before check-in.</li>"
                + "</ul>"
                + "<p>If you have any questions or need further assistance, please don't hesitate to contact us.</p>"
                + "<p>We look forward to welcoming you to Luxury Hotel!</p>"
                + "<p>Best regards,<br>The Luxury Hotel Team</p>"
                + "</div>"
                + "<div style='background-color: #f5f5f5; padding: 10px; text-align: center; font-size: 12px;'>"
                + "<p>This is an automated email. Please do not reply to this message.</p>"
                + "<p>© " + java.time.Year.now().getValue() + " Luxury Hotel. All rights reserved.</p>"
                + "</div>"
                + "</div>";

        return sendEmail(user.getEmail(), subject, body);
    }

    /**
     * Send a payment confirmation email
     * @param user The user who made the payment
     * @param booking The booking details
     * @param payment The payment details
     * @param room The room details
     * @return True if the email was sent successfully, false otherwise
     */
    public static boolean sendPaymentConfirmation(User user, Booking booking, Payment payment, Room room) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        String checkIn = dateFormat.format(booking.getDateFrom());
        String checkOut = dateFormat.format(booking.getDateTo());

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("MMMM dd, yyyy HH:mm:ss");
        String paymentDate = payment.getPaymentDate() != null ? dateTimeFormat.format(payment.getPaymentDate()) : "N/A";

        String subject = "Payment Confirmation - Luxury Hotel";

        String body = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>"
                + "<div style='background-color: #1a1a1a; color: #fff; padding: 20px; text-align: center;'>"
                + "<h1>Luxury Hotel</h1>"
                + "</div>"
                + "<div style='padding: 20px; border: 1px solid #ddd;'>"
                + "<h2>Payment Confirmation</h2>"
                + "<p>Dear " + user.getName() + ",</p>"
                + "<p>Thank you for your payment. Your booking is now confirmed.</p>"
                + "<h3>Payment Details</h3>"
                + "<table style='width: 100%; border-collapse: collapse;'>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Payment ID:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + payment.getId() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Amount:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>$" + payment.getAmount() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Payment Method:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + payment.getPaymentMethod() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Transaction ID:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + payment.getTransactionId() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Payment Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + paymentDate + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Status:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + payment.getStatus() + "</td></tr>"
                + "</table>"
                + "<h3>Booking Details</h3>"
                + "<table style='width: 100%; border-collapse: collapse;'>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Booking ID:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + booking.getId() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Type:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getType() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Number:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getNumber() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-in Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkIn + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-out Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkOut + "</td></tr>"
                + "</table>"
                + "<p>If you have any questions or need further assistance, please don't hesitate to contact us.</p>"
                + "<p>We look forward to welcoming you to Luxury Hotel!</p>"
                + "<p>Best regards,<br>The Luxury Hotel Team</p>"
                + "</div>"
                + "<div style='background-color: #f5f5f5; padding: 10px; text-align: center; font-size: 12px;'>"
                + "<p>This is an automated email. Please do not reply to this message.</p>"
                + "<p>© " + java.time.Year.now().getValue() + " Luxury Hotel. All rights reserved.</p>"
                + "</div>"
                + "</div>";

        return sendEmail(user.getEmail(), subject, body);
    }

    /**
     * Send a booking cancellation email
     * @param user The user who cancelled the booking
     * @param booking The booking details
     * @param room The room details
     * @return True if the email was sent successfully, false otherwise
     */
    public static boolean sendBookingCancellation(User user, Booking booking, Room room) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        String checkIn = dateFormat.format(booking.getDateFrom());
        String checkOut = dateFormat.format(booking.getDateTo());

        String subject = "Booking Cancellation - Luxury Hotel";

        String body = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>"
                + "<div style='background-color: #1a1a1a; color: #fff; padding: 20px; text-align: center;'>"
                + "<h1>Luxury Hotel</h1>"
                + "</div>"
                + "<div style='padding: 20px; border: 1px solid #ddd;'>"
                + "<h2>Booking Cancellation</h2>"
                + "<p>Dear " + user.getName() + ",</p>"
                + "<p>Your booking has been cancelled as requested.</p>"
                + "<h3>Booking Details</h3>"
                + "<table style='width: 100%; border-collapse: collapse;'>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Booking ID:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + booking.getId() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Type:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getType() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Number:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getNumber() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-in Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkIn + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-out Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkOut + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Status:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + booking.getStatus() + "</td></tr>"
                + "</table>"
                + "<p>If you have any questions or need further assistance, please don't hesitate to contact us.</p>"
                + "<p>We hope to welcome you to Luxury Hotel in the future.</p>"
                + "<p>Best regards,<br>The Luxury Hotel Team</p>"
                + "</div>"
                + "<div style='background-color: #f5f5f5; padding: 10px; text-align: center; font-size: 12px;'>"
                + "<p>This is an automated email. Please do not reply to this message.</p>"
                + "<p>© " + java.time.Year.now().getValue() + " Luxury Hotel. All rights reserved.</p>"
                + "</div>"
                + "</div>";

        return sendEmail(user.getEmail(), subject, body);
    }

    /**
     * Send a booking reminder email
     * @param user The user to remind
     * @param booking The booking details
     * @param room The room details
     * @return True if the email was sent successfully, false otherwise
     */
    public static boolean sendBookingReminder(User user, Booking booking, Room room) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM dd, yyyy");
        String checkIn = dateFormat.format(booking.getDateFrom());
        String checkOut = dateFormat.format(booking.getDateTo());

        String subject = "Your Upcoming Stay at Luxury Hotel";

        String body = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>"
                + "<div style='background-color: #1a1a1a; color: #fff; padding: 20px; text-align: center;'>"
                + "<h1>Luxury Hotel</h1>"
                + "</div>"
                + "<div style='padding: 20px; border: 1px solid #ddd;'>"
                + "<h2>Your Upcoming Stay</h2>"
                + "<p>Dear " + user.getName() + ",</p>"
                + "<p>We're looking forward to welcoming you to Luxury Hotel soon!</p>"
                + "<h3>Booking Details</h3>"
                + "<table style='width: 100%; border-collapse: collapse;'>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Booking ID:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + booking.getId() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Type:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getType() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Room Number:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + room.getNumber() + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-in Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkIn + "</td></tr>"
                + "<tr><td style='padding: 8px; border-bottom: 1px solid #ddd;'><strong>Check-out Date:</strong></td><td style='padding: 8px; border-bottom: 1px solid #ddd;'>" + checkOut + "</td></tr>"
                + "</table>"
                + "<h3>Important Information</h3>"
                + "<ul>"
                + "<li>Check-in time: 2:00 PM</li>"
                + "<li>Check-out time: 12:00 PM</li>"
                + "<li>Please present a valid ID and the credit card used for booking upon check-in.</li>"
                + "<li>For any changes or cancellations, please contact us at least 24 hours before check-in.</li>"
                + "</ul>"
                + "<h3>Hotel Amenities</h3>"
                + "<ul>"
                + "<li>24-hour front desk</li>"
                + "<li>Free Wi-Fi throughout the hotel</li>"
                + "<li>Swimming pool and fitness center (open from 6:00 AM to 10:00 PM)</li>"
                + "<li>Restaurant and bar (open from 7:00 AM to 11:00 PM)</li>"
                + "<li>Room service (available 24/7)</li>"
                + "</ul>"
                + "<p>If you have any questions or special requests before your arrival, please don't hesitate to contact us.</p>"
                + "<p>We look forward to making your stay at Luxury Hotel a memorable one!</p>"
                + "<p>Best regards,<br>The Luxury Hotel Team</p>"
                + "</div>"
                + "<div style='background-color: #f5f5f5; padding: 10px; text-align: center; font-size: 12px;'>"
                + "<p>This is an automated email. Please do not reply to this message.</p>"
                + "<p>© " + java.time.Year.now().getValue() + " Luxury Hotel. All rights reserved.</p>"
                + "</div>"
                + "</div>";

        return sendEmail(user.getEmail(), subject, body);
    }

    /**
     * Send a feedback request email
     * @param user The user to request feedback from
     * @param booking The booking details
     * @return True if the email was sent successfully, false otherwise
     */
    public static boolean sendFeedbackRequest(User user, Booking booking) {
        String subject = "How was your stay at Luxury Hotel?";

        String body = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;'>"
                + "<div style='background-color: #1a1a1a; color: #fff; padding: 20px; text-align: center;'>"
                + "<h1>Luxury Hotel</h1>"
                + "</div>"
                + "<div style='padding: 20px; border: 1px solid #ddd;'>"
                + "<h2>We Value Your Feedback</h2>"
                + "<p>Dear " + user.getName() + ",</p>"
                + "<p>Thank you for choosing Luxury Hotel for your recent stay. We hope you had a wonderful experience!</p>"
                + "<p>We would greatly appreciate it if you could take a few moments to share your feedback with us. Your opinions are valuable and help us improve our services.</p>"
                + "<div style='text-align: center; margin: 30px 0;'>"
                + "<a href='" + AppConfig.getBaseUrl() + "/feedback?bookingId=" + booking.getId() + "' style='background-color: #1a1a1a; color: #fff; padding: 12px 24px; text-decoration: none; border-radius: 4px; font-weight: bold;'>Share Your Feedback</a>"
                + "</div>"
                + "<p>If you have any questions or need further assistance, please don't hesitate to contact us.</p>"
                + "<p>We hope to welcome you back to Luxury Hotel soon!</p>"
                + "<p>Best regards,<br>The Luxury Hotel Team</p>"
                + "</div>"
                + "<div style='background-color: #f5f5f5; padding: 10px; text-align: center; font-size: 12px;'>"
                + "<p>This is an automated email. Please do not reply to this message.</p>"
                + "<p>© " + java.time.Year.now().getValue() + " Luxury Hotel. All rights reserved.</p>"
                + "</div>"
                + "</div>";

        return sendEmail(user.getEmail(), subject, body);
    }
}
