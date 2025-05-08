-- Create the database
CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    role ENUM('ADMIN', 'USER') DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (email)
);

-- Rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    number VARCHAR(20) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    availability BOOLEAN DEFAULT TRUE,
    description TEXT,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_room_type (type),
    INDEX idx_room_availability (availability)
);

-- Bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE,
    INDEX idx_booking_status (status),
    INDEX idx_booking_dates (date_from, date_to)
);

-- Billing table
CREATE TABLE IF NOT EXISTS billing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    paid_on TIMESTAMP NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    status ENUM('PENDING', 'PAID', 'REFUNDED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE,
    INDEX idx_billing_status (status)
);

-- Staff table
CREATE TABLE IF NOT EXISTS staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_staff_role (role)
);

-- Feedback table
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_feedback_rating (rating)
);

-- Blog table
CREATE TABLE IF NOT EXISTS blog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_path VARCHAR(255),
    video_url VARCHAR(255),
    author VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_blog_created (created_at)
);

-- Events table
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    date DATE NOT NULL,
    location VARCHAR(255) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_event_date (date)
);

-- Insert admin user (password: admin123)
INSERT INTO users (name, email, password, role) 
VALUES ('Admin User', 'admin@luxuryhotel.com', '$2a$10$hKDVYxLefVHV/vtuPhWD3OigtRyOykRLDdUAp80Z1crSoS1lFqaFS', 'ADMIN');

-- Insert sample room types
INSERT INTO rooms (type, number, price, availability, description, image_path) VALUES
('Standard', '101', 100.00, true, 'Comfortable standard room with a queen-size bed.', 'standard_room.jpg'),
('Deluxe', '201', 150.00, true, 'Spacious deluxe room with a king-size bed and city view.', 'deluxe_room.jpg'),
('Suite', '301', 250.00, true, 'Luxury suite with separate living area and panoramic views.', 'suite_room.jpg'),
('Executive', '401', 300.00, true, 'Executive suite with premium amenities and butler service.', 'executive_room.jpg'),
('Presidential', '501', 500.00, true, 'Our finest accommodation with multiple rooms and exclusive services.', 'presidential_room.jpg');

-- Insert sample staff members
INSERT INTO staff (name, role, email, phone, image_path) VALUES
('John Smith', 'General Manager', 'john.smith@luxuryhotel.com', '+1234567890', 'john_smith.jpg'),
('Emily Johnson', 'Front Desk Manager', 'emily.johnson@luxuryhotel.com', '+1234567891', 'emily_johnson.jpg'),
('Michael Brown', 'Executive Chef', 'michael.brown@luxuryhotel.com', '+1234567892', 'michael_brown.jpg'),
('Sarah Davis', 'Housekeeping Manager', 'sarah.davis@luxuryhotel.com', '+1234567893', 'sarah_davis.jpg'),
('Robert Wilson', 'Concierge', 'robert.wilson@luxuryhotel.com', '+1234567894', 'robert_wilson.jpg');

-- Insert sample blog posts
INSERT INTO blog (title, content, image_path, author) VALUES
('Welcome to Luxury Hotel', 'We are delighted to welcome you to our newly renovated Luxury Hotel. Experience the epitome of luxury and comfort during your stay with us.', 'welcome_post.jpg', 'Admin User'),
('Summer Special Offers', 'Enjoy our special summer packages with 20% off on all room types. Book now to avail this limited-time offer.', 'summer_offer.jpg', 'Admin User'),
('Meet Our Executive Chef', 'We are proud to introduce our new Executive Chef, Michael Brown, who brings 15 years of international culinary experience to our hotel.', 'chef_intro.jpg', 'Admin User');

-- Insert sample events
INSERT INTO events (event_name, description, date, location, image_path) VALUES
('New Year Gala', 'Join us for an unforgettable New Year celebration with live music, gourmet dinner, and fireworks.', '2023-12-31', 'Grand Ballroom', 'new_year_gala.jpg'),
('Wedding Showcase', 'Explore our wedding venues and packages at this special event designed for couples planning their big day.', '2023-06-15', 'Garden Terrace', 'wedding_showcase.jpg'),
('Wine Tasting Evening', 'Sample premium wines from around the world paired with delicious appetizers prepared by our chef.', '2023-07-20', 'Wine Cellar', 'wine_tasting.jpg');
