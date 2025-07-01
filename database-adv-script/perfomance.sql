-- Performance Query Script for Airbnb Database
-- Task 4: Optimize Complex Queries

-- =====================================================
-- INITIAL COMPLEX QUERY (BEFORE OPTIMIZATION)
-- =====================================================

-- Initial query that retrieves all bookings with user details, property details, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status as booking_status,
    
    -- User details
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    u.phone_number,
    u.role,
    u.created_at as user_created_at,
    
    -- Property details
    p.property_id,
    p.host_id,
    p.name as property_name,
    p.description as property_description,
    p.location,
    p.pricepernight,
    p.created_at as property_created_at,
    p.updated_at as property_updated_at,
    
    -- Host details (joining User table again for host information)
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    h.email as host_email,
    h.phone_number as host_phone,
    
    -- Payment details
    pay.payment_id,
    pay.amount as payment_amount,
    pay.payment_date,
    pay.payment_method,
    
    -- Additional calculated fields
    DATEDIFF(b.end_date, b.start_date) as booking_duration,
    (b.total_price / DATEDIFF(b.end_date, b.start_date)) as avg_daily_rate
    
FROM Booking b
    -- Join with User table for booking user details
    JOIN User u ON b.user_id = u.user_id
    
    -- Join with Property table for property details
    JOIN Property p ON b.property_id = p.property_id
    
    -- Join with User table again for host details
    JOIN User h ON p.host_id = h.user_id
    
    -- Left join with Payment table (a booking might not have payment yet)
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id

-- Optional WHERE conditions for filtering
WHERE b.created_at >= '2023-01-01'
    AND b.status IN ('confirmed', 'completed', 'pending')
    AND p.location IS NOT NULL
    
-- Order by booking creation date (most recent first)
ORDER BY b.created_at DESC, b.booking_id ASC;

-- =====================================================
-- PERFORMANCE ANALYSIS COMMANDS
-- =====================================================

-- Use EXPLAIN to analyze the query execution plan
EXPLAIN 
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status as booking_status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name as property_name,
    p.location,
    p.pricepernight,
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    pay.payment_id,
    pay.amount as payment_amount,
    pay.payment_method
FROM Booking b
    JOIN User u ON b.user_id = u.user_id
    JOIN Property p ON b.property_id = p.property_id
    JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id
WHERE b.created_at >= '2023-01-01'
    AND b.status IN ('confirmed', 'completed', 'pending')
ORDER BY b.created_at DESC;

-- =====================================================
-- OPTIMIZED QUERY VERSION 1 (REDUCED COLUMNS)
-- =====================================================

-- Optimized version: Select only necessary columns and improve joins
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    -- Essential user details only
    u.first_name,
    u.last_name,
    u.email,
    
    -- Essential property details only
    p.name as property_name,
    p.location,
    p.pricepernight,
    
    -- Essential host details only
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    
    -- Payment summary
    pay.amount as payment_amount,
    pay.payment_method
    
FROM Booking b
    INNER JOIN User u ON b.user_id = u.user_id
    INNER JOIN Property p ON b.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON b.booking_id = pay.booking_id

WHERE b.created_at >= '2023-01-01'
    AND b.status IN ('confirmed', 'completed')  -- Reduced status options
    
ORDER BY b.created_at DESC
LIMIT 1000;  -- Added limit for better performance

-- =====================================================
-- OPTIMIZED QUERY VERSION 2 (WITH SUBQUERY)
-- =====================================================

-- Further optimized version using subquery to pre-filter bookings
SELECT 
    filtered_bookings.booking_id,
    filtered_bookings.start_date,
    filtered_bookings.end_date,
    filtered_bookings.total_price,
    filtered_bookings.status,
    
    u.first_name,
    u.last_name,
    u.email,
    
    p.name as property_name,
    p.location,
    p.pricepernight,
    
    h.first_name as host_first_name,
    h.last_name as host_last_name,
    
    pay.amount as payment_amount,
    pay.payment_method
    
FROM (
    -- Subquery to pre-filter and limit bookings
    SELECT booking_id, user_id, property_id, start_date, end_date, 
           total_price, status, created_at
    FROM Booking 
    WHERE created_at >= '2023-01-01'
        AND status IN ('confirmed', 'completed')
    ORDER BY created_at DESC
    LIMIT 1000
) filtered_bookings

    INNER JOIN User u ON filtered_bookings.user_id = u.user_id
    INNER JOIN Property p ON filtered_bookings.property_id = p.property_id
    INNER JOIN User h ON p.host_id = h.user_id
    LEFT JOIN Payment pay ON filtered_bookings.booking_id = pay.booking_id

ORDER BY filtered_bookings.created_at DESC;

-- =====================================================
-- OPTIMIZED QUERY VERSION 3 (INDEXED APPROACH)
-- =====================================================

-- Optimized version leveraging indexes created in Task 3
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.total_price,
    b.status,
    
    u.first_name,
    u.last_name,
    u.email,
    
    p.name as property_name,
    p.location,
    p.pricepernight,
    
    h.first_name as host_first_name,
    h.last_name as host_last_name
    
FROM Booking b
    -- Use indexes: idx_booking_user_status, idx_booking_created_at
    INNER JOIN User u ON b.user_id = u.user_id
    
    -- Use index: idx_property_host_id
    INNER JOIN Property p ON b.property_id = p.property_id
    
    -- Use index: primary key on user_id
    INNER JOIN User h ON p.host_id = h.user_id

WHERE b.status = 'confirmed'  -- Use idx_booking_status
    AND b.created_at >= '2023-01-01'  -- Use idx_booking_created_at
    
ORDER BY b.created_at DESC  -- Benefit from idx_booking_created_at
LIMIT 500;

-- =====================================================
-- PAYMENT DETAILS SEPARATE QUERY (OPTIONAL)
-- =====================================================

-- If payment details are needed, fetch them separately to avoid LEFT JOIN overhead
SELECT 
    p.booking_id,
    p.payment_id,
    p.amount,
    p.payment_date,
    p.payment_method
FROM Payment p
WHERE p.booking_id IN (
    SELECT b.booking_id 
    FROM Booking b
    WHERE b.status = 'confirmed'
        AND b.created_at >= '2023-01-01'
    ORDER BY b.created_at DESC
    LIMIT 500
);

-- =====================================================
-- PERFORMANCE COMPARISON QUERIES
-- =====================================================

-- Query to compare execution time before optimization
SET @start_time = NOW(6);
-- [Run original complex query here]
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as execution_time_microseconds;

-- Query to compare execution time after optimization
SET @start_time = NOW(6);
-- [Run optimized query here]
SET @end_time = NOW(6);
SELECT TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) as optimized_execution_time_microseconds;