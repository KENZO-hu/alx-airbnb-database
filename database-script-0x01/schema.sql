-- ALX Airbnb Database Schema
-- This script creates the complete database schema for the Airbnb-like application
-- Ensures 3NF compliance with proper constraints, indexes, and relationships

-- Create database (uncomment if needed)
-- CREATE DATABASE alx_airbnb_db;
-- USE alx_airbnb_db;

-- Enable UUID extension (for PostgreSQL)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =============================================================================
-- USER TABLE
-- =============================================================================
CREATE TABLE User (
    user_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20),
    role ENUM('guest', 'host', 'admin') NOT NULL DEFAULT 'guest',
    profile_picture TEXT,
    date_of_birth DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Constraints
    CONSTRAINT chk_email_format CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
    CONSTRAINT chk_phone_format CHECK (phone_number IS NULL OR phone_number REGEXP '^[+]?[0-9\s\-\(\)]{10,20}$'),
    CONSTRAINT chk_age_restriction CHECK (date_of_birth IS NULL OR date_of_birth <= DATE_SUB(CURRENT_DATE, INTERVAL 18 YEAR))
);

-- =============================================================================
-- PROPERTY TABLE
-- =============================================================================
CREATE TABLE Property (
    property_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    host_id CHAR(36) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR(255) NOT NULL,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8),
    pricepernight DECIMAL(10,2) NOT NULL,
    max_guests INTEGER NOT NULL,
    bedrooms INTEGER NOT NULL,
    bathrooms INTEGER NOT NULL,
    property_type ENUM('apartment', 'house', 'villa', 'condo', 'studio', 'townhouse', 'loft') NOT NULL,
    amenities JSON,
    availability_status ENUM('available', 'unavailable', 'maintenance') DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (host_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_price_positive CHECK (pricepernight > 0),
    CONSTRAINT chk_max_guests_positive CHECK (max_guests > 0 AND max_guests <= 50),
    CONSTRAINT chk_bedrooms_valid CHECK (bedrooms >= 0 AND bedrooms <= 20),
    CONSTRAINT chk_bathrooms_valid CHECK (bathrooms >= 0 AND bathrooms <= 20),
    CONSTRAINT chk_latitude_range CHECK (latitude IS NULL OR (latitude >= -90 AND latitude <= 90)),
    CONSTRAINT chk_longitude_range CHECK (longitude IS NULL OR (longitude >= -180 AND longitude <= 180))
);

-- =============================================================================
-- BOOKING TABLE
-- =============================================================================
CREATE TABLE Booking (
    booking_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled', 'completed', 'refunded') DEFAULT 'pending',
    guest_count INTEGER NOT NULL,
    special_requests TEXT,
    booking_reference VARCHAR(20) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_booking_dates CHECK (end_date > start_date),
    CONSTRAINT chk_booking_duration CHECK (DATEDIFF(end_date, start_date) <= 365),
    CONSTRAINT chk_guest_count_positive CHECK (guest_count > 0),
    CONSTRAINT chk_total_price_positive CHECK (total_price > 0),
    CONSTRAINT chk_future_booking CHECK (start_date >= CURRENT_DATE)
);

-- =============================================================================
-- PAYMENT TABLE
-- =============================================================================
CREATE TABLE Payment (
    payment_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    booking_id CHAR(36) UNIQUE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'debit_card', 'paypal', 'bank_transfer', 'digital_wallet') NOT NULL,
    payment_status ENUM('pending', 'completed', 'failed', 'refunded', 'partial_refund') DEFAULT 'pending',
    transaction_id VARCHAR(100) UNIQUE,
    currency CHAR(3) DEFAULT 'USD',
    processing_fee DECIMAL(10,2) DEFAULT 0.00,
    payment_gateway VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE CASCADE ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_payment_amount_positive CHECK (amount > 0),
    CONSTRAINT chk_processing_fee_valid CHECK (processing_fee >= 0 AND processing_fee <= amount * 0.1),
    CONSTRAINT chk_currency_format CHECK (currency REGEXP '^[A-Z]{3}$')
);

-- =============================================================================
-- REVIEW TABLE
-- =============================================================================
CREATE TABLE Review (
    review_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    property_id CHAR(36) NOT NULL,
    user_id CHAR(36) NOT NULL,
    booking_id CHAR(36),
    rating INTEGER NOT NULL,
    comment TEXT NOT NULL,
    review_type ENUM('property', 'host', 'guest') NOT NULL DEFAULT 'property',
    is_verified BOOLEAN DEFAULT FALSE,
    helpful_count INTEGER DEFAULT 0,
    response_from_host TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Foreign Key Constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_rating_range CHECK (rating >= 1 AND rating <= 5),
    CONSTRAINT chk_comment_length CHECK (CHAR_LENGTH(comment) >= 10 AND CHAR_LENGTH(comment) <= 2000),
    CONSTRAINT chk_helpful_count_valid CHECK (helpful_count >= 0),
    
    -- Unique Constraints
    UNIQUE KEY unique_user_property_review (user_id, property_id, booking_id)
);

-- =============================================================================
-- MESSAGE TABLE
-- =============================================================================
CREATE TABLE Message (
    message_id CHAR(36) PRIMARY KEY DEFAULT (UUID()),
    sender_id CHAR(36) NOT NULL,
    recipient_id CHAR(36) NOT NULL,
    property_id CHAR(36),
    booking_id CHAR(36),
    message_body TEXT NOT NULL,
    message_type ENUM('inquiry', 'booking_related', 'support', 'general') DEFAULT 'general',
    read_status BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    read_at TIMESTAMP NULL,
    
    -- Foreign Key Constraints
    FOREIGN KEY (sender_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (recipient_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id) ON DELETE SET NULL ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_different_users CHECK (sender_id != recipient_id),
    CONSTRAINT chk_message_length CHECK (CHAR_LENGTH(message_body) >= 1 AND CHAR_LENGTH(message_body) <= 5000)
);

-- =============================================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- =============================================================================

-- User table indexes
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_role ON User(role);
CREATE INDEX idx_user_created_at ON User(created_at);

-- Property table indexes
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_property_price_range ON Property(pricepernight);
CREATE INDEX idx_property_type ON Property(property_type);
CREATE INDEX idx_property_guests ON Property(max_guests);
CREATE INDEX idx_property_availability ON Property(availability_status);
CREATE INDEX idx_property_coordinates ON Property(latitude, longitude);

-- Booking table indexes
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_created_at ON Booking(created_at);
CREATE INDEX idx_booking_date_range ON Booking(start_date, end_date, property_id);

-- Payment table indexes
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
CREATE INDEX idx_payment_status ON Payment(payment_status);
CREATE INDEX idx_payment_method ON Payment(payment_method);
CREATE INDEX idx_payment_date ON Payment(payment_date);
CREATE INDEX idx_payment_transaction_id ON Payment(transaction_id);

-- Review table indexes
CREATE INDEX idx_review_property_id ON Review(property_id);
CREATE INDEX idx_review_user_id ON Review(user_id);
CREATE INDEX idx_review_rating ON Review(rating);
CREATE INDEX idx_review_created_at ON Review(created_at);
CREATE INDEX idx_review_verified ON Review(is_verified);

-- Message table indexes
CREATE INDEX idx_message_sender_id ON Message(sender_id);
CREATE INDEX idx_message_recipient_id ON Message(recipient_id);
CREATE INDEX idx_message_sent_at ON Message(sent_at);
CREATE INDEX idx_message_read_status ON Message(read_status);
CREATE INDEX idx_message_conversation ON Message(sender_id, recipient_id, sent_at);

-- =============================================================================
-- TRIGGERS FOR AUTOMATIC UPDATES
-- =============================================================================

-- Trigger to update booking reference
DELIMITER //
CREATE TRIGGER generate_booking_reference 
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    IF NEW.booking_reference IS NULL THEN
        SET NEW.booking_reference = CONCAT('ABB', YEAR(CURRENT_DATE), LPAD(FLOOR(RAND() * 999999), 6, '0'));
    END IF;
END//
DELIMITER ;

-- Trigger to validate guest count against property capacity
DELIMITER //
CREATE TRIGGER validate_guest_count 
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE max_capacity INT;
    SELECT max_guests INTO max_capacity FROM Property WHERE property_id = NEW.property_id;
    IF NEW.guest_count > max_capacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Guest count exceeds property capacity';
    END IF;
END//
DELIMITER ;

-- Trigger to prevent double booking
DELIMITER //
CREATE TRIGGER prevent_double_booking 
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
    DECLARE booking_count INT DEFAULT 0;
    SELECT COUNT(*) INTO booking_count 
    FROM Booking 
    WHERE property_id = NEW.property_id 
    AND status IN ('confirmed', 'pending')
    AND (
        (NEW.start_date BETWEEN start_date AND end_date) OR
        (NEW.end_date BETWEEN start_date AND end_date) OR
        (start_date BETWEEN NEW.start_date AND NEW.end_date)
    );
    
    IF booking_count > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Property is already booked for selected dates';
    END IF;
END//
DELIMITER ;

-- Trigger to update review verification status
DELIMITER //
CREATE TRIGGER verify_review_eligibility 
BEFORE INSERT ON Review
FOR EACH ROW
BEGIN
    DECLARE completed_booking_count INT DEFAULT 0;
    SELECT COUNT(*) INTO completed_booking_count
    FROM Booking 
    WHERE user_id = NEW.user_id 
    AND property_id = NEW.property_id 
    AND status = 'completed';
    
    IF completed_booking_count > 0 THEN
        SET NEW.is_verified = TRUE;
    END IF;
END//
DELIMITER ;

-- =============================================================================
-- VIEWS FOR COMMON QUERIES
-- =============================================================================

-- View for property listings with host information
CREATE VIEW PropertyListings AS
SELECT 
    p.property_id,
    p.name AS property_name,
    p.description,
    p.location,
    p.pricepernight,
    p.max_guests,
    p.bedrooms,
    p.bathrooms,
    p.property_type,
    p.availability_status,
    CONCAT(u.first_name, ' ', u.last_name) AS host_name,
    u.email AS host_email,
    u.phone_number AS host_phone,
    AVG(r.rating) AS average_rating,
    COUNT(r.review_id) AS review_count,
    p.created_at
FROM Property p
JOIN User u ON p.host_id = u.user_id
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.availability_status = 'available'
GROUP BY p.property_id, u.user_id;

-- View for booking details with payment information
CREATE VIEW BookingDetails AS
SELECT 
    b.booking_id,
    b.booking_reference,
    p.name AS property_name,
    p.location AS property_location,
    CONCAT(guest.first_name, ' ', guest.last_name) AS guest_name,
    CONCAT(host.first_name, ' ', host.last_name) AS host_name,
    b.start_date,
    b.end_date,
    DATEDIFF(b.end_date, b.start_date) AS nights,
    b.guest_count,
    b.total_price,
    b.status AS booking_status,
    pay.payment_status,
    pay.payment_method,
    pay.amount AS payment_amount,
    b.created_at AS booking_date
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
JOIN User guest ON b.user_id = guest.user_id
JOIN User host ON p.host_id = host.user_id
LEFT JOIN Payment pay ON b.booking_id = pay.booking_id;

-- =============================================================================
-- SECURITY AND PERFORMANCE OPTIMIZATIONS
-- =============================================================================

-- Create user roles (uncomment if using MySQL 8.0+)
-- CREATE ROLE 'airbnb_guest', 'airbnb_host', 'airbnb_admin';

-- Grant appropriate permissions
-- GRANT SELECT ON alx_airbnb_db.PropertyListings TO 'airbnb_guest';
-- GRANT SELECT, INSERT, UPDATE ON alx_airbnb_db.Booking TO 'airbnb_guest';
-- GRANT SELECT, INSERT, UPDATE ON alx_airbnb_db.Review TO 'airbnb_guest';

-- Additional performance configurations
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO';

-- =============================================================================
-- SCHEMA VALIDATION QUERIES
-- =============================================================================

-- Verify all tables are created
SELECT 
    TABLE_NAME,
    TABLE_TYPE,
    ENGINE,
    TABLE_ROWS,
    DATA_LENGTH,
    INDEX_LENGTH
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME;

-- Verify all indexes are created
SELECT 
    TABLE_NAME,
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE,
    INDEX_TYPE
FROM information_schema.STATISTICS 
WHERE TABLE_SCHEMA = DATABASE()
ORDER BY TABLE_NAME, INDEX_NAME, SEQ_IN_INDEX;

-- Verify foreign key constraints
SELECT 
    CONSTRAINT_NAME,
    TABLE_NAME,
    COLUMN_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_SCHEMA = DATABASE() 
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME;

-- End of schema creation script