# Luxury Hotel Management System - Admin Panel Documentation

## Overview

The Luxury Hotel Management System includes a secure admin panel that is hidden from regular users. This document provides information on how to access and use the admin panel.

## Accessing the Admin Panel

The admin panel is accessible through a hidden URL that is not linked from the main website:

```
http://localhost:8080/Luxury_HotelManagementSystem_war_exploded/adminpanel
```

This URL is intentionally not linked from any public-facing page to enhance security.

## Admin Login Credentials

To access the admin panel, you need admin credentials. The default admin account is:

- **Email**: admin@luxuryhotel.com
- **Password**: admin123

These credentials are simple and not encrypted for easier access during development. In a production environment, you should implement proper password encryption.

## Admin Panel Features

The admin panel provides access to various management features:

1. **Dashboard**
   - Overview of hotel statistics
   - Recent bookings and user registrations

2. **User Management**
   - View all users
   - Add new users
   - Edit user details
   - Delete users

3. **Room Management**
   - View all rooms
   - Add new rooms
   - Edit room details
   - Delete rooms

4. **Booking Management**
   - View all bookings
   - Update booking status
   - Cancel bookings

5. **Payment Management**
   - View all payments
   - Process payments
   - Issue refunds

6. **Event Management**
   - Manage hotel events
   - Add new events
   - Edit event details
   - Delete events

7. **Blog Management**
   - Manage blog posts
   - Add new posts
   - Edit post content
   - Delete posts

8. **Feedback Management**
   - View customer feedback
   - Respond to feedback

9. **Settings**
   - Configure system settings
   - Manage email templates
   - Update hotel information

## Security Measures

The admin panel includes several security measures:

1. **Hidden URL**: The admin panel URL is not linked from any public page.
2. **Role-Based Access Control**: Only users with the ADMIN role can access the admin panel.
3. **Session Validation**: All admin pages validate the user's session and role.
4. **Automatic Logout**: Inactive sessions are automatically terminated after 30 minutes.

### Development Mode Security Note

In the current development mode:
- Admin credentials are simple and not encrypted for easier testing and development
- The system uses direct string comparison for admin authentication
- For production, it's recommended to implement proper password encryption using BCrypt or another secure hashing algorithm

## Troubleshooting

If you encounter issues accessing the admin panel:

1. Ensure you are using the correct URL.
2. Verify your admin credentials.
3. Clear your browser cache and cookies.
4. Check if the server is running properly.

## Support

For technical support or questions about the admin panel, please contact:

- **Email**: support@luxuryhotel.com
- **Phone**: +1 234 567 8900
