# ALX Airbnb Database Schema

## Overview
This directory contains the SQL Data Definition Language (DDL) scripts for creating the complete ALX Airbnb database schema. The schema is designed to support a full-featured Airbnb-like platform with users, properties, bookings, payments, reviews, and messaging functionality.

## Database Design Principles

### Normalization
- **Third Normal Form (3NF)** compliance ensures data integrity and eliminates redundancy
- **Referential integrity** maintained through foreign key constraints
- **Domain integrity** enforced with check constraints and ENUM types

### Performance Optimization
- **Strategic indexing** on frequently queried columns
- **Composite indexes** for complex query patterns
- **Optimized data types** to minimize storage overhead

### Security Features
- **Input validation** through check constraints
- **Data consistency** enforced by triggers
- **Role-based access** preparation for different user types

## Schema Components

### Core Tables

#### User Table
- **Purpose**: Central user management for guests, hosts, and admins
- **Key Features**: 
  - UUID primary keys for scalability
  - Email uniqueness constraint
  - Role-based user classification
  - Profile picture and metadata support

#### Property Table
- **Purpose**: Rental property listings with detailed specifications
- **Key Features**:
  - Geographic coordinates support
  - JSON amenities for flexible feature storage
  - Comprehensive property metadata
  - Host relationship management

#### Booking Table
- **Purpose**: Reservation management with status tracking
- **Key Features**:
  - Date validation and overlap prevention
  - Guest capacity validation
  - Unique booking reference generation
  - Special requests handling

#### Payment Table
- **Purpose**: Financial transaction tracking
- **Key Features**:
  - Multiple payment method support
  - Transaction ID tracking for external gateways
  - Processing fee calculation
  - Currency support for international transactions

#### Review Table
- **Purpose**: User feedback and rating system
- **Key Features**:
  - 5-star rating system
  - Verified review status
  - Host response capability
  - Helpfulness tracking

#### Message Table
- **Purpose**: User communication platform
- **Key Features**:
  - Thread-based messaging
  - Read status tracking
  - Property and booking context
  - Message type categorization

### Indexes and Performance

#### Primary Indexes
- **Unique constraints** on user emails and payment transaction IDs
- **Foreign key indexes** for relationship optimization
- **Composite indexes** for date range queries

#### Query Optimization
- **Property search** optimized with location, price, and capacity indexes
- **Booking queries** enhanced with date range composite indexes
- **User activity** tracking through timestamp indexes

### Constraints and Validation

#### Data Integrity
- **Email format validation** using regular expressions
- **Date range validation** for bookings and age restrictions
- **Numeric range validation** for ratings, prices, and capacities
- **Geographic coordinate validation** for property locations

#### Business Rules
- **Prevent double booking** through trigger validation
- **Guest capacity limits** enforced at booking creation
- **Review eligibility** verified through completed bookings
- **Payment amount validation** with processing fee limits

## Installation Instructions

### Prerequisites
- MySQL 8.0+ or MariaDB 10.5+
- Appropriate database permissions for schema creation
- UTF-8 character set support

### Deployment Steps

1. **Create Database**
   ```sql
   CREATE DATABASE alx_airbnb_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   USE alx_airbnb_db;
   ```

2. **Execute Schema Script**
   ```bash
   mysql -u username -p alx_airbnb_db < schema.sql
   ```

3. **Verify Installation**
   ```sql
   SHOW TABLES;
   SHOW INDEX FROM User;
   DESCRIBE Property;
   ```

### Configuration Options

#### UUID Support
- **MySQL 8.0+**: Built-in UUID() function
- **MariaDB**: May require UUID() function or alternative implementation
- **PostgreSQL**: Requires `uuid-ossp` extension

#### Storage Engine
- **InnoDB** recommended for transaction support and foreign keys
- **MyISAM** not recommended due to lack of referential integrity

## Usage Examples

### Basic Queries

#### Find Available Properties
```sql
SELECT * FROM PropertyListings 
WHERE availability_status = 'available' 
AND max_guests >= 4 
AND pricepernight <= 200;
```

#### Get Booking Details
```sql
SELECT * FROM BookingDetails 
WHERE booking_status = 'confirmed' 
AND start_date >= CURRENT_DATE;
```

#### User Reviews Summary
```sql
SELECT 
    property_id,
    AVG(rating) as avg_rating,
    COUNT(*) as review_count
FROM Review 
WHERE is_verified = TRUE
GROUP BY property_id;
```

### Advanced Operations

#### Property Search with Filters
```sql
SELECT p.*, AVG(r.rating) as rating
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location LIKE '%New York%'
AND p.pricepernight BETWEEN 100 AND 300
AND p.max_guests >= 2
GROUP BY p.property_id
HAVING rating >= 4.0 OR rating IS NULL
ORDER BY rating DESC, pricepernight ASC;
```

## Maintenance and Monitoring

### Regular Maintenance Tasks

#### Index Optimization
```sql
ANALYZE TABLE User, Property, Booking, Payment, Review, Message;
OPTIMIZE TABLE User, Property, Booking, Payment, Review, Message;
```

#### Constraint Validation
```sql
SELECT * FROM information_schema.TABLE_CONSTRAINTS 
WHERE TABLE_SCHEMA = 'alx_airbnb_db';
```

### Performance Monitoring

#### Query Performance
- Monitor slow query log for optimization opportunities
- Use EXPLAIN to analyze query execution plans
- Regular index usage analysis

#### Storage Management
- Monitor table sizes and growth patterns
- Archive old booking and payment records
- Regular backup and recovery testing

## Troubleshooting

### Common Issues

#### Foreign Key Constraints
- **Error**: Cannot add foreign key constraint
- **Solution**: Ensure referenced tables exist and have proper indexes

#### Data Type Mismatches
- **Error**: Incorrect data type for column
- **Solution**: Verify ENUM values and numeric ranges match application logic

#### Index Conflicts
- **Error**: Duplicate key constraint
- **