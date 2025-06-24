# ALX Airbnb Database - Entity-Relationship Diagram Requirements

## Project Overview
This document outlines the Entity-Relationship Diagram (ERD) requirements for the ALX Airbnb Database project. The database is designed to support a comprehensive Airbnb-like application with robust functionality for users, properties, bookings, payments, reviews, and messaging.

## Core Entities and Attributes

### 1. User Entity
**Purpose**: Represents all users in the system (guests and hosts)

**Attributes**:
- `user_id` (Primary Key, UUID, NOT NULL)
- `first_name` (VARCHAR(50), NOT NULL)
- `last_name` (VARCHAR(50), NOT NULL)
- `email` (VARCHAR(100), UNIQUE, NOT NULL)
- `password_hash` (VARCHAR(255), NOT NULL)
- `phone_number` (VARCHAR(20), NULLABLE)
- `role` (ENUM: 'guest', 'host', 'admin', NOT NULL)
- `profile_picture` (TEXT, NULLABLE) - URL to profile image
- `date_of_birth` (DATE, NULLABLE)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE)

**Constraints**:
- Email must be unique across all users
- Role defines user permissions and capabilities
- Password should be securely hashed

### 2. Property Entity
**Purpose**: Represents rental properties listed on the platform

**Attributes**:
- `property_id` (Primary Key, UUID, NOT NULL)
- `host_id` (Foreign Key, UUID, NOT NULL) → References User(user_id)
- `name` (VARCHAR(100), NOT NULL)
- `description` (TEXT, NOT NULL)
- `location` (VARCHAR(255), NOT NULL)
- `latitude` (DECIMAL(10,8), NULLABLE)
- `longitude` (DECIMAL(11,8), NULLABLE)
- `pricepernight` (DECIMAL(10,2), NOT NULL)
- `max_guests` (INTEGER, NOT NULL)
- `bedrooms` (INTEGER, NOT NULL)
- `bathrooms` (INTEGER, NOT NULL)
- `property_type` (ENUM: 'apartment', 'house', 'villa', 'condo', 'studio', NOT NULL)
- `amenities` (JSON, NULLABLE) - Structured list of amenities
- `availability_status` (ENUM: 'available', 'unavailable', 'maintenance', DEFAULT 'available')
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE)

**Constraints**:
- Host must be a valid user with 'host' or 'admin' role
- Price per night must be positive
- Maximum guests, bedrooms, and bathrooms must be positive integers

### 3. Booking Entity
**Purpose**: Represents reservation transactions between guests and properties

**Attributes**:
- `booking_id` (Primary Key, UUID, NOT NULL)
- `property_id` (Foreign Key, UUID, NOT NULL) → References Property(property_id)
- `user_id` (Foreign Key, UUID, NOT NULL) → References User(user_id)
- `start_date` (DATE, NOT NULL)
- `end_date` (DATE, NOT NULL)
- `total_price` (DECIMAL(10,2), NOT NULL)
- `status` (ENUM: 'pending', 'confirmed', 'canceled', 'completed', DEFAULT 'pending')
- `guest_count` (INTEGER, NOT NULL)
- `special_requests` (TEXT, NULLABLE)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE)

**Constraints**:
- End date must be after start date
- Guest count cannot exceed property's max_guests
- Total price must be positive
- User must have 'guest' role for booking
- No overlapping confirmed bookings for the same property

### 4. Payment Entity
**Purpose**: Tracks financial transactions for bookings

**Attributes**:
- `payment_id` (Primary Key, UUID, NOT NULL)
- `booking_id` (Foreign Key, UUID, NOT NULL) → References Booking(booking_id)
- `amount` (DECIMAL(10,2), NOT NULL)
- `payment_date` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `payment_method` (ENUM: 'credit_card', 'debit_card', 'paypal', 'bank_transfer', NOT NULL)
- `payment_status` (ENUM: 'pending', 'completed', 'failed', 'refunded', DEFAULT 'pending')
- `transaction_id` (VARCHAR(100), UNIQUE, NULLABLE) - External payment processor ID
- `currency` (CHAR(3), DEFAULT 'USD') - ISO currency code
- `processing_fee` (DECIMAL(10,2), NULLABLE)
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)

**Constraints**:
- Amount must be positive
- One-to-one relationship with Booking
- Transaction ID should be unique when present

### 5. Review Entity
**Purpose**: Stores user reviews and ratings for properties and hosts

**Attributes**:
- `review_id` (Primary Key, UUID, NOT NULL)
- `property_id` (Foreign Key, UUID, NOT NULL) → References Property(property_id)
- `user_id` (Foreign Key, UUID, NOT NULL) → References User(user_id)
- `rating` (INTEGER, NOT NULL) - Scale 1-5
- `comment` (TEXT, NOT NULL)
- `review_type` (ENUM: 'property', 'host', 'guest', NOT NULL)
- `is_verified` (BOOLEAN, DEFAULT FALSE) - Verified booking review
- `helpful_count` (INTEGER, DEFAULT 0) - User helpfulness votes
- `created_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP)
- `updated_at` (TIMESTAMP, DEFAULT CURRENT_TIMESTAMP ON UPDATE)

**Constraints**:
- Rating must be between 1 and 5
- User must have completed booking to review property
- One review per user per booking

### 6. Message Entity
**Purpose**: Facilitates communication between users

**Attributes**:
- `message_id` (Primary Key, UUID, NOT NULL)
- `sender_id` (Foreign Key, UUID, NOT NULL) → References User(user_id)
- `recipient_i