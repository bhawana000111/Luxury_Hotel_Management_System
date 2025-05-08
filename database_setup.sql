-- Hotel Management System Database Schema

USE hotel_db;

-- Users table for authentication
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'GUEST') NOT NULL,
    email VARCHAR(100) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Room types
CREATE TABLE room_types (
    type_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description TEXT,
    price_per_night DECIMAL(10, 2) NOT NULL,
    capacity INT NOT NULL
);

-- Rooms
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    type_id INT NOT NULL,
    status ENUM('AVAILABLE', 'OCCUPIED', 'MAINTENANCE') DEFAULT 'AVAILABLE',
    floor INT NOT NULL,
    FOREIGN KEY (type_id) REFERENCES room_types(type_id)
);

-- Bookings
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('CONFIRMED', 'CHECKED_IN', 'CHECKED_OUT', 'CANCELLED') DEFAULT 'CONFIRMED',
    total_amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('PENDING', 'PAID', 'REFUNDED') DEFAULT 'PENDING',
    special_requests TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- Payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('CREDIT_CARD', 'DEBIT_CARD', 'CASH', 'BANK_TRANSFER') NOT NULL,
    transaction_id VARCHAR(100),
    status ENUM('SUCCESSFUL', 'FAILED', 'PENDING') DEFAULT 'PENDING',
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Services
CREATE TABLE services (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- Service bookings
CREATE TABLE service_bookings (
    service_booking_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT DEFAULT 1,
    service_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('REQUESTED', 'COMPLETED', 'CANCELLED') DEFAULT 'REQUESTED',
    total_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- Reviews
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- Insert sample data for room types
INSERT INTO room_types (name, description, price_per_night, capacity) VALUES
('Standard', 'A comfortable room with basic amenities', 100.00, 2),
('Deluxe', 'A spacious room with premium amenities', 150.00, 2),
('Suite', 'A luxurious suite with separate living area', 250.00, 4),
('Executive', 'Top-tier room with exclusive benefits', 300.00, 2),
('Family', 'Spacious room suitable for families', 200.00, 6);

-- Insert sample rooms
INSERT INTO rooms (room_number, type_id, floor) VALUES
('101', 1, 1), ('102', 1, 1), ('103', 1, 1), ('104', 1, 1), ('105', 1, 1),
('201', 2, 2), ('202', 2, 2), ('203', 2, 2), ('204', 2, 2), ('205', 2, 2),
('301', 3, 3), ('302', 3, 3), ('303', 3, 3),
('401', 4, 4), ('402', 4, 4),
('501', 5, 5), ('502', 5, 5);

-- Insert sample services
INSERT INTO services (name, description, price) VALUES
('Room Service', 'Food and beverages delivered to your room', 15.00),
('Spa Treatment', 'Relaxing spa services', 80.00),
('Airport Shuttle', 'Transportation to/from airport', 50.00),
('Laundry', 'Cleaning and ironing services', 25.00),
('Breakfast', 'Breakfast buffet', 20.00);

-- Create admin user (password: admin123)
INSERT INTO users (username, password, role, email, full_name, phone) VALUES
('admin', 'admin123', 'ADMIN', 'admin@hotel.com', 'System Administrator', '123-456-7890');
