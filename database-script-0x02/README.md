# Airbnb-like Platform Database Seed

This README provides documentation for the seed SQL file that populates a database for an Airbnb-like platform with sample data.

## Overview

The seed SQL file contains comprehensive sample data for a vacation rental platform, including:

- User accounts (admins, hosts, and guests)
- Property listings with detailed information
- Booking records with various statuses
- Payment transactions
- Property reviews

## Database Structure

The seed data populates the following tables:

1. **User** - Platform users with different roles (admin, host, guest)
2. **Property** - Rental properties with detailed attributes
3. **Booking** - Reservation records
4. **Payment** - Transaction records
5. **Review** - Guest reviews of properties

## Data Characteristics

### Users
- 1 admin user
- 5 host users
- 9 guest users
- Each user has complete profile information including:
  - Name, email, phone
  - Profile picture
  - Date of birth
  - Account creation timestamp

### Properties
- 10 diverse properties across different locations (NY, FL, CA, TX, WA)
- Various property types (studio, loft, condo, villa, house, apartment, townhouse)
- Detailed amenities for each property
- Geolocation coordinates (latitude/longitude)
- Pricing and capacity information

### Bookings
- 11 booking records with different statuses:
  - 5 completed bookings
  - 4 confirmed (future) bookings
  - 1 pending booking
  - 1 canceled booking
- Each booking includes:
  - Dates, pricing, guest count
  - Special requests
  - Unique booking reference

### Payments
- 9 completed payments
- 1 pending payment
- 1 refunded payment
- Various payment methods (credit card, PayPal, bank transfer, etc.)
- Transaction details including fees and gateway information

### Reviews
- 4 verified property reviews (with host responses)
- 1 incomplete review (appears to be cut off in the sample)

## Usage

To use this seed data:

1. Ensure your database schema matches the expected table structure
2. Execute the SQL file against your database
3. The data will be inserted with appropriate relationships between tables

## Notes

- All data is synthetic and for demonstration purposes only
- UUIDs are used for all primary keys
- Timestamps are included for most records
- The data represents a realistic snapshot of an operational vacation rental platform

## Sample Queries

Here are some example queries you could run against this data:

```sql
-- Find all available properties in New York
SELECT * FROM Property 
WHERE location LIKE '%New York%' 
AND availability_status = 'available';

-- Get all completed bookings with guest information
SELECT b.booking_reference, u.first_name, u.last_name, p.name AS property_name
FROM Booking b
JOIN User u ON b.user_id = u.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'completed';

-- Calculate total revenue from completed payments
SELECT SUM(amount) AS total_revenue FROM Payment 
WHERE payment_status = 'completed';
```