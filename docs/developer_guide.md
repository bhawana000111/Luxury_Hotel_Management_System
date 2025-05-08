# Luxury Hotel Management System - Developer Guide

## Table of Contents
1. [Introduction](#introduction)
2. [System Architecture](#system-architecture)
3. [Development Environment Setup](#development-environment-setup)
4. [Project Structure](#project-structure)
5. [Database Schema](#database-schema)
6. [Key Components](#key-components)
7. [API Documentation](#api-documentation)
8. [Testing](#testing)
9. [Deployment](#deployment)
10. [Performance Optimization](#performance-optimization)
11. [Security Considerations](#security-considerations)
12. [Troubleshooting](#troubleshooting)

## Introduction

The Luxury Hotel Management System is a web-based application built using Java (JSP/Servlets), JDBC, and MySQL. It follows the Model-View-Controller (MVC) architecture to provide a clean separation of concerns and maintainable codebase.

This guide is intended for developers who need to understand, modify, or extend the system. It provides detailed information about the system architecture, components, and development practices.

## System Architecture

The system follows the MVC (Model-View-Controller) architecture:

- **Model**: Java classes that represent the business entities and data access objects (DAOs) that handle database operations.
- **View**: JSP pages that render the user interface.
- **Controller**: Servlet classes that handle HTTP requests, process user input, and coordinate the model and view components.

### High-Level Architecture Diagram

```
+----------------+     +----------------+     +----------------+
|                |     |                |     |                |
|  Client        |     |  Web Server    |     |  Database      |
|  (Browser)     |<--->|  (Tomcat)      |<--->|  (MySQL)       |
|                |     |                |     |                |
+----------------+     +----------------+     +----------------+
                           |
                           | Contains
                           v
+----------------+     +----------------+     +----------------+
|                |     |                |     |                |
|  Controllers   |<--->|  Models        |<--->|  DAOs          |
|  (Servlets)    |     |  (Java Classes)|     |  (Data Access) |
|                |     |                |     |                |
+----------------+     +----------------+     +----------------+
        |
        | Renders
        v
+----------------+
|                |
|  Views         |
|  (JSP Pages)   |
|                |
+----------------+
```

## Development Environment Setup

### Prerequisites
- JDK 11 or higher
- Apache Tomcat 9 or higher
- MySQL 8.0 or higher
- Maven 3.6 or higher
- IntelliJ IDEA or Eclipse IDE

### Setting Up the Development Environment

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/luxury-hotel-management.git
   cd luxury-hotel-management
   ```

2. **Database Setup**
   ```sql
   CREATE DATABASE hotel_db;
   CREATE USER 'hotel_user'@'localhost' IDENTIFIED BY 'hotel_password';
   GRANT ALL PRIVILEGES ON hotel_db.* TO 'hotel_user'@'localhost';
   FLUSH PRIVILEGES;
   ```

3. **Import the Project**
   - For IntelliJ IDEA:
     - Go to File > Open
     - Select the project directory
     - Choose "Open as Project"
   
   - For Eclipse:
     - Go to File > Import
     - Select "Existing Maven Projects"
     - Browse to the project directory
     - Click Finish

4. **Configure Tomcat**
   - For IntelliJ IDEA:
     - Go to Run > Edit Configurations
     - Click the + button and select Tomcat Server > Local
     - Configure the Tomcat server
     - In the Deployment tab, add the artifact
   
   - For Eclipse:
     - Go to Window > Preferences > Server > Runtime Environments
     - Add a new Tomcat server
     - Right-click on the project and select Run As > Run on Server

5. **Run the Application**
   - Start the Tomcat server
   - Access the application at http://localhost:8080/Luxury_HotelManagementSystem/

## Project Structure

```
Luxury_HotelManagementSystem/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/
│   │   │       └── hotel/
│   │   │           ├── controller/    # Servlet controllers
│   │   │           ├── model/         # Business entities and DAOs
│   │   │           └── util/          # Utility classes
│   │   ├── resources/                 # Configuration files
│   │   └── webapp/
│   │       ├── admin/                 # Admin portal JSPs
│   │       ├── assets/                # CSS, JS, images
│   │       ├── partials/              # Reusable JSP components
│   │       ├── WEB-INF/               # Web configuration
│   │       └── *.jsp                  # Main JSP pages
│   └── test/
│       └── java/
│           └── com/
│               └── hotel/
│                   ├── controller/    # Controller tests
│                   ├── model/         # Model tests
│                   └── util/          # Utility tests
├── docs/                              # Documentation
├── pom.xml                            # Maven configuration
└── README.md                          # Project overview
```

## Database Schema

The database schema consists of the following tables:

### Users Table
```sql
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    role ENUM('USER', 'ADMIN') DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Rooms Table
```sql
CREATE TABLE rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    number VARCHAR(20) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    description TEXT,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Bookings Table
```sql
CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    special_requests TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (room_id) REFERENCES rooms(id)
);
```

### Payments Table
```sql
CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100),
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED') DEFAULT 'PENDING',
    payment_date TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
```

### Feedback Table
```sql
CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    booking_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
```

### Events Table
```sql
CREATE TABLE events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(100) NOT NULL,
    description TEXT,
    date DATE NOT NULL,
    time TIME NOT NULL,
    location VARCHAR(100) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

### Staff Table
```sql
CREATE TABLE staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## Key Components

### Model Layer

#### Entity Classes
- **User**: Represents a user of the system (guest or admin)
- **Room**: Represents a hotel room
- **Booking**: Represents a room booking
- **Payment**: Represents a payment for a booking
- **Feedback**: Represents guest feedback
- **Event**: Represents a hotel event
- **Staff**: Represents a hotel staff member

#### Data Access Objects (DAOs)
- **UserDAO**: Handles database operations for users
- **RoomDAO**: Handles database operations for rooms
- **BookingDAO**: Handles database operations for bookings
- **PaymentDAO**: Handles database operations for payments
- **FeedbackDAO**: Handles database operations for feedback
- **EventDAO**: Handles database operations for events
- **StaffDAO**: Handles database operations for staff

### Controller Layer

#### User Controllers
- **UserController**: Handles user registration, login, and profile management
- **AdminUserController**: Handles admin operations on users

#### Room Controllers
- **RoomController**: Handles room listing and details
- **AdminRoomController**: Handles admin operations on rooms

#### Booking Controllers
- **BookRoomController**: Handles room booking process
- **BookingController**: Handles booking management
- **AdminBookingController**: Handles admin operations on bookings

#### Payment Controllers
- **PaymentController**: Handles payment processing
- **AdminPaymentController**: Handles admin operations on payments

#### Other Controllers
- **FeedbackController**: Handles feedback submission and management
- **EventController**: Handles event listing and details
- **StaffController**: Handles staff management

### Utility Layer

- **DBConnection**: Manages database connections
- **SessionUtil**: Manages user sessions
- **FileUploadUtil**: Handles file uploads
- **PasswordHasher**: Handles password hashing and verification
- **EmailService**: Handles email notifications
- **CacheUtil**: Handles caching for performance optimization

### View Layer

#### Guest Portal
- **index.jsp**: Home page
- **rooms.jsp**: Room listing page
- **room_details.jsp**: Room details page
- **book_room.jsp**: Room booking page
- **bookings.jsp**: User bookings page
- **booking_details.jsp**: Booking details page
- **payment.jsp**: Payment page
- **profile.jsp**: User profile page

#### Admin Portal
- **admin/dashboard.jsp**: Admin dashboard
- **admin/users.jsp**: User management page
- **admin/rooms.jsp**: Room management page
- **admin/bookings.jsp**: Booking management page
- **admin/payments.jsp**: Payment management page
- **admin/events.jsp**: Event management page
- **admin/staff.jsp**: Staff management page
- **admin/feedback.jsp**: Feedback management page

## API Documentation

### User API

#### Register User
- **URL**: `/register`
- **Method**: POST
- **Parameters**:
  - `name`: User's full name
  - `email`: User's email address
  - `password`: User's password
  - `confirmPassword`: Password confirmation
- **Response**: Redirects to login page with success message

#### Login User
- **URL**: `/login`
- **Method**: POST
- **Parameters**:
  - `email`: User's email address
  - `password`: User's password
- **Response**: Redirects to home page on success, login page with error on failure

#### Update Profile
- **URL**: `/updateProfile`
- **Method**: POST
- **Parameters**:
  - `name`: User's full name
  - `email`: User's email address
  - `profileImage`: User's profile image (optional)
- **Response**: Redirects to profile page with success message

### Room API

#### Get All Rooms
- **URL**: `/rooms`
- **Method**: GET
- **Parameters**:
  - `type`: Room type (optional)
  - `minPrice`: Minimum price (optional)
  - `maxPrice`: Maximum price (optional)
  - `checkIn`: Check-in date (optional)
  - `checkOut`: Check-out date (optional)
- **Response**: Renders rooms.jsp with room list

#### Get Room Details
- **URL**: `/room`
- **Method**: GET
- **Parameters**:
  - `id`: Room ID
- **Response**: Renders room_details.jsp with room details

### Booking API

#### Book Room
- **URL**: `/bookRoom`
- **Method**: POST
- **Parameters**:
  - `roomId`: Room ID
  - `dateFrom`: Check-in date
  - `dateTo`: Check-out date
  - `specialRequests`: Special requests (optional)
- **Response**: Redirects to payment page

#### Get User Bookings
- **URL**: `/bookings`
- **Method**: GET
- **Response**: Renders bookings.jsp with user's bookings

#### Get Booking Details
- **URL**: `/booking`
- **Method**: GET
- **Parameters**:
  - `id`: Booking ID
- **Response**: Renders booking_details.jsp with booking details

### Payment API

#### Process Payment
- **URL**: `/processPayment`
- **Method**: POST
- **Parameters**:
  - `bookingId`: Booking ID
  - `amount`: Payment amount
  - `paymentMethod`: Payment method
- **Response**: Redirects to payment success page on success, payment cancel page on failure

## Testing

### Unit Testing

The project uses JUnit and Mockito for unit testing. The tests are organized in the same package structure as the main code.

#### Running Tests
```bash
mvn test
```

#### Test Coverage
```bash
mvn jacoco:report
```

The coverage report will be generated in `target/site/jacoco/index.html`.

### Integration Testing

Integration tests ensure that different components of the system work together correctly.

#### Running Integration Tests
```bash
mvn verify
```

### End-to-End Testing

End-to-end tests simulate user interactions with the system to ensure that the entire workflow functions correctly.

#### Running End-to-End Tests
```bash
mvn verify -P e2e-tests
```

## Deployment

### Prerequisites
- JDK 11 or higher
- Apache Tomcat 9 or higher
- MySQL 8.0 or higher

### Deployment Steps

1. **Build the WAR file**
   ```bash
   mvn clean package
   ```

2. **Deploy to Tomcat**
   - Copy the WAR file from `target/Luxury_HotelManagementSystem.war` to Tomcat's `webapps` directory
   - Start Tomcat
   - Access the application at http://localhost:8080/Luxury_HotelManagementSystem/

3. **Database Setup**
   - Create the database and user as described in the Development Environment Setup section
   - Run the SQL scripts to create the tables

## Performance Optimization

### Caching

The system uses a custom caching mechanism to improve performance. The `CacheUtil` class provides methods for caching frequently accessed data.

```java
// Example: Caching room data
String cacheKey = "room_" + roomId;
Room cachedRoom = (Room) CacheUtil.get(cacheKey);

if (cachedRoom == null) {
    // Fetch from database
    Room room = roomDAO.getById(roomId);
    
    // Cache the result
    CacheUtil.put(cacheKey, room);
    
    return room;
} else {
    return cachedRoom;
}
```

### Database Optimization

- Use indexes on frequently queried columns
- Use connection pooling to reduce database connection overhead
- Optimize SQL queries to minimize database load

### Front-End Optimization

- Minify CSS and JavaScript files
- Optimize images
- Use browser caching
- Implement lazy loading for images

## Security Considerations

### Authentication and Authorization

- User authentication is handled by the `UserController`
- Session management is handled by the `SessionUtil` class
- Role-based access control is implemented to restrict access to admin features

### Password Security

- Passwords are hashed using the `PasswordHasher` class
- The system uses a secure hashing algorithm with salt to protect passwords

### Input Validation

- All user input is validated on both client and server sides
- The system uses prepared statements to prevent SQL injection

### CSRF Protection

- The system implements CSRF tokens to prevent cross-site request forgery attacks

### XSS Protection

- User input is sanitized to prevent cross-site scripting attacks

## Troubleshooting

### Common Issues

#### Database Connection Issues
- Check database credentials in `DBConnection.java`
- Ensure MySQL server is running
- Verify that the database and user exist with the correct permissions

#### Deployment Issues
- Check Tomcat logs for errors
- Ensure the WAR file is correctly deployed
- Verify that the application context path is correct

#### Performance Issues
- Check database query performance
- Monitor server resource usage
- Optimize slow queries
- Implement caching for frequently accessed data

### Logging

The system uses Log4j for logging. The log files are located in:
- Development: `logs/hotel.log`
- Production: `/var/log/tomcat/hotel.log`

### Debugging

- Set the log level to DEBUG in `log4j.properties` for more detailed logs
- Use the browser developer tools to debug front-end issues
- Use a database profiler to identify slow queries
