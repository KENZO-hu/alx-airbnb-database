-- Database Index Creation Script for Airbnb-like Platform
-- This script creates recommended indexes to improve query performance

-- USER TABLE INDEXES
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_created_at ON User(created_at);
CREATE INDEX idx_user_phone ON User(phone_number);

-- BOOKING TABLE INDEXES
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);
CREATE INDEX idx_booking_start_date ON Booking(start_date);
CREATE INDEX idx_booking_end_date ON Booking(end_date);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_booking_created_at ON Booking(created_at);

-- PROPERTY TABLE INDEXES
CREATE INDEX idx_property_host_id ON Property(host_id);
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_property_price ON Property(pricepernight);
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);
CREATE INDEX idx_property_created_at ON Property(created_at);

-- COMPOSITE INDEXES FOR COMMON QUERY PATTERNS
-- For frequent searches combining location, price, and availability
CREATE INDEX idx_property_search ON Property(location, pricepernight, created_at);

-- For user booking history queries with date filters
CREATE INDEX idx_user_booking_history ON Booking(user_id, status, start_date);

-- For host property management queries
CREATE INDEX idx_host_properties ON Property(host_id, created_at);

-- For admin analytics queries
CREATE INDEX idx_booking_analytics ON Booking(created_at, status, property_id);

-- FOREIGN KEY INDEXES (if not automatically created)
-- These are often created automatically when foreign keys are defined, but explicit creation ensures they exist
CREATE INDEX fk_booking_user ON Booking(user_id);
CREATE INDEX fk_booking_property ON Booking(property_id);
CREATE INDEX fk_property_host ON Property(host_id);

-- OPTIONAL: FULL-TEXT INDEXES if text search is needed
-- CREATE FULLTEXT INDEX idx_property_description ON Property(description);
-- CREATE FULLTEXT INDEX idx_user_review ON Review(comments);

-- Index creation statements with additional options for production environments
-- CREATE INDEX CONCURRENTLY idx_user_email ON User(email); -- PostgreSQL
-- CREATE ONLINE INDEX idx_user_email ON User(email); -- MySQL