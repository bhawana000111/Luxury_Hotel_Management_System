-- Create database
CREATE DATABASE IF NOT EXISTS hotel_db;
USE hotel_db;

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id INT AUTO_INCREMENT PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    number VARCHAR(20) NOT NULL UNIQUE,
    price DECIMAL(10, 2) NOT NULL,
    availability BOOLEAN NOT NULL DEFAULT TRUE,
    description TEXT,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create bookings table
CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    date_from DATE NOT NULL,
    date_to DATE NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- Create billing table
CREATE TABLE IF NOT EXISTS billing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    paid_on TIMESTAMP NULL,
    payment_method VARCHAR(50),
    transaction_id VARCHAR(100),
    status ENUM('PENDING', 'PAID', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id) ON DELETE CASCADE
);

-- Create staff table
CREATE TABLE IF NOT EXISTS staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create feedback table
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    message TEXT NOT NULL,
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Create blog table
CREATE TABLE IF NOT EXISTS blog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    image_path VARCHAR(255),
    video_url VARCHAR(255),
    author VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create events table
CREATE TABLE IF NOT EXISTS events (
    id INT AUTO_INCREMENT PRIMARY KEY,
    event_name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    date DATE NOT NULL,
    location VARCHAR(100) NOT NULL,
    image_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert admin user
INSERT INTO users (name, email, password, role) VALUES 
('Admin User', 'admin@hotel.com', '$2a$12$ZlgRYBGQVF0U0zOQgiqJ2.Jqw3KOQ0Oi2H9Jn.LQSvXkqJIxTOIWW', 'ADMIN');
-- Password: admin123

-- Insert sample rooms
INSERT INTO rooms (type, number, price, availability, description, image_path) VALUES
('Standard', '101', 100.00, TRUE, 'Comfortable standard room with a queen-size bed.', 'assets/images/standard_room.jpg'),
('Standard', '102', 100.00, TRUE, 'Comfortable standard room with a queen-size bed.', 'assets/images/standard_room.jpg'),
('Deluxe', '201', 150.00, TRUE, 'Spacious deluxe room with a king-size bed and city view.', 'assets/images/deluxe_room.jpg'),
('Deluxe', '202', 150.00, TRUE, 'Spacious deluxe room with a king-size bed and city view.', 'assets/images/deluxe_room.jpg'),
('Suite', '301', 250.00, TRUE, 'Luxury suite with separate living area and panoramic views.', 'assets/images/suite_room.jpg'),
('Suite', '302', 250.00, TRUE, 'Luxury suite with separate living area and panoramic views.', 'assets/images/suite_room.jpg'),
('Executive', '401', 300.00, TRUE, 'Executive suite with premium amenities and butler service.', 'assets/images/executive_room.jpg'),
('Presidential', '501', 500.00, TRUE, 'Our finest accommodation with multiple rooms and exclusive services.', 'assets/images/presidential_room.jpg');

-- Insert sample staff
INSERT INTO staff (name, role, email, phone, image_path) VALUES
('John Smith', 'General Manager', 'john.smith@hotel.com', '+1 234 567 8901', 'assets/images/john_smith.jpg'),
('Emily Johnson', 'Front Desk Manager', 'emily.johnson@hotel.com', '+1 234 567 8902', 'assets/images/emily_johnson.jpg'),
('Michael Brown', 'Executive Chef', 'michael.brown@hotel.com', '+1 234 567 8903', 'assets/images/michael_brown.jpg'),
('Sarah Davis', 'Housekeeping Manager', 'sarah.davis@hotel.com', '+1 234 567 8904', 'assets/images/sarah_davis.jpg'),
('Robert Wilson', 'Concierge', 'robert.wilson@hotel.com', '+1 234 567 8905', 'assets/images/robert_wilson.jpg');

-- Insert sample blog posts
INSERT INTO blog (title, content, image_path, author) VALUES
('Welcome to Luxury Hotel', 'We are delighted to welcome you to our newly renovated Luxury Hotel. Experience the epitome of luxury and comfort during your stay with us. Our hotel offers a range of amenities and services designed to make your stay memorable.', 'assets/images/welcome_post.jpg', 'Admin User'),
('Summer Special Offers', 'Enjoy our special summer packages with 20% off on all room types. Book now to avail this limited-time offer. Valid for stays between June 1 and August 31, 2023.', 'assets/images/summer_offer.jpg', 'Admin User'),
('Meet Our Executive Chef', 'We are proud to introduce our new Executive Chef, Michael Brown, who brings 15 years of international culinary experience to our hotel. Chef Michael specializes in fusion cuisine, combining traditional flavors with modern techniques.', 'assets/images/chef_intro.jpg', 'Admin User');

-- Insert sample events
INSERT INTO events (event_name, description, date, location, image_path) VALUES
('New Year Gala', 'Join us for an unforgettable New Year celebration with live music, gourmet dinner, and fireworks.', '2023-12-31', 'Grand Ballroom', 'assets/images/new_year_gala.jpg'),
('Wedding Showcase', 'Explore our wedding venues and packages at this special event designed for couples planning their big day.', '2023-06-15', 'Garden Terrace', 'assets/images/wedding_showcase.jpg'),
('Wine Tasting Evening', 'Sample premium wines from around the world paired with delicious appetizers prepared by our chef.', '2023-07-20', 'Wine Cellar', 'assets/images/wine_tasting.jpg'),
('Jazz Night', 'Enjoy an evening of smooth jazz music with our resident jazz band while sipping on signature cocktails.', '2023-08-05', 'Lounge Bar', 'assets/images/jazz_night.jpg');

-- Create database user
CREATE USER IF NOT EXISTS 'hotel_user'@'localhost' IDENTIFIED BY 'hotel_password';
GRANT ALL PRIVILEGES ON hotel_db.* TO 'hotel_user'@'localhost';
FLUSH PRIVILEGES;
