# Index Performance Analysis Report

## Objective
Identify high-usage columns in User, Booking, and Property tables and create appropriate indexes to improve query performance.

## High-Usage Columns Analysis

### User Table
- **user_id**: Primary key, frequently used in JOINs with Booking and Property tables
- **email**: Used for user authentication and lookups
- **created_at**: Used for filtering users by registration date
- **phone_number**: Used for contact lookups

### Booking Table
- **booking_id**: Primary key, used in JOINs with Payment and other tables
- **user_id**: Foreign key, frequently used in JOINs with User table
- **property_id**: Foreign key, frequently used in JOINs with Property table
- **start_date**: Used in date range queries and WHERE clauses
- **end_date**: Used in date range queries and WHERE clauses
- **status**: Used for filtering bookings by status (confirmed, pending, cancelled)
- **created_at**: Used for filtering bookings by creation date

### Property Table
- **property_id**: Primary key, frequently used in JOINs
- **host_id**: Foreign key to User table, used for host-related queries
- **location**: Used for geographical searches
- **pricepernight**: Used in price range filtering and ORDER BY clauses
- **created_at**: Used for filtering properties by listing date

## Recommended Indexes

### User Table Indexes
```sql
-- Index on email for authentication queries
CREATE INDEX idx_user_email ON User(email);

-- Index on created_at for date-based filtering
CREATE INDEX idx_user_created_at ON User(created_at);

-- Index on phone_number for contact lookups
CREATE INDEX idx_user_phone ON User(phone_number);
```

### Booking Table Indexes
```sql
-- Composite index on user_id and status for user booking queries
CREATE INDEX idx_booking_user_status ON Booking(user_id, status);

-- Composite index on property_id and dates for property availability queries
CREATE INDEX idx_booking_property_dates ON Booking(property_id, start_date, end_date);

-- Index on start_date for date range queries
CREATE INDEX idx_booking_start_date ON Booking(start_date);

-- Index on end_date for date range queries
CREATE INDEX idx_booking_end_date ON Booking(end_date);

-- Index on status for filtering by booking status
CREATE INDEX idx_booking_status ON Booking(status);

-- Index on created_at for booking creation date queries
CREATE INDEX idx_booking_created_at ON Booking(created_at);
```

### Property Table Indexes
```sql
-- Index on host_id for host-related queries
CREATE INDEX idx_property_host_id ON Property(host_id);

-- Index on location for geographical searches
CREATE INDEX idx_property_location ON Property(location);

-- Index on pricepernight for price-based filtering and sorting
CREATE INDEX idx_property_price ON Property(pricepernight);

-- Composite index on location and price for combined searches
CREATE INDEX idx_property_location_price ON Property(location, pricepernight);

-- Index on created_at for property listing date queries
CREATE INDEX idx_property_created_at ON Property(created_at);
```

## Performance Testing Methodology

### Before Index Creation
1. Run EXPLAIN ANALYZE on sample queries
2. Record execution time and query plan
3. Note table scans and join costs

### After Index Creation
1. Re-run the same queries with EXPLAIN ANALYZE
2. Compare execution times
3. Verify index usage in query plans

## Sample Test Queries

### Query 1: Find user bookings with property details
```sql
EXPLAIN ANALYZE
SELECT u.first_name, u.last_name, b.start_date, b.end_date, p.name as property_name
FROM User u
JOIN Booking b ON u.user_id = b.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
AND b.start_date >= '2024-01-01';
```

### Query 2: Find properties in specific location with price range
```sql
EXPLAIN ANALYZE
SELECT *
FROM Property
WHERE location = 'New York'
AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight ASC;
```

### Query 3: User activity analysis
```sql
EXPLAIN ANALYZE
SELECT u.email, COUNT(b.booking_id) as booking_count
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
WHERE u.created_at >= '2023-01-01'
GROUP BY u.user_id, u.email
HAVING COUNT(b.booking_id) > 2;
```

## Expected Performance Improvements

### Index Benefits
- **Faster JOINs**: Foreign key indexes will speed up table joins
- **Efficient Filtering**: WHERE clause conditions will use indexes instead of full table scans
- **Improved Sorting**: ORDER BY operations will benefit from indexed columns
- **Reduced I/O**: Less disk reads due to index-based lookups

### Typical Improvements Expected
- Query execution time reduction: 60-90%
- Reduced CPU usage for database operations
- Lower memory consumption for query processing
- Improved concurrent user performance

## Monitoring and Maintenance

### Regular Index Maintenance
- Monitor index usage with database statistics
- Rebuild indexes periodically for optimal performance
- Remove unused indexes to reduce storage overhead
- Update statistics regularly for query optimizer

### Performance Monitoring Queries
```sql
-- Check index usage statistics
SHOW INDEX FROM User;
SHOW INDEX FROM Booking;
SHOW INDEX FROM Property;

-- Monitor query performance
EXPLAIN FORMAT=JSON SELECT ...;
```

## Conclusion

The implementation of these strategic indexes should significantly improve query performance across the Airbnb database. The composite indexes are particularly valuable for common query patterns that filter on multiple columns simultaneously. Regular monitoring and maintenance of these indexes will ensure sustained performance improvements as the database grows.