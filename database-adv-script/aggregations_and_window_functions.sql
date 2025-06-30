-- task 2 : Apply Aggregations and Window Functions --
-- 1. AGGREGATION QUERY : finf the total number of booking made by each user 
-- using count function and group by clause 
SELECT 
   u.user_id,
   u.first_name,
   u.last_name,
   u.email,
   COUNT(b.booking_id) AS total_bookings
from 
   user u 
LEFT JOIN 
   Booking b on u.user_id = b.user_id
GROUP BY 
   u.user_id , u.first_name , u.last_name , u.email
ORDER BY 
   total_bookings DESC , u.user_id;
-- Alternative version: Only users who have made bookings
SELECT 
   u.user_id , 
   u.first_name,
   u.last_name,
   u.email,
   COUNT(b.booking_id)AS total_bookings
FROM 
   User u 
INNER JOIN 
   booking b on u.user_id = b.user_id
GROUP BY 
   u.user_id , u.first_name , u.last_name , u.email
ORDER BY
   total_bookings DESC :
-- 2. WINDOW FUNCTIONS: Rank properties based on total number of bookings
-- Using ROW_NUMBER and RANK window functions

-- Using ROW_NUMBER (assigns unique sequential numbers)
SELECT 
   P.property_id,
   p.name AS property_name,
   p.host_id, 
   p.location,
   p.pricepernight,
   COUNT(b.booking_id) AS total_bookings ,
   ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id)DESC) AS row_number_rank
FROM
   property p 
LEFT JOIN 
   booking b on p.property_id = b.property_id
GROUP BY
   P.property_id , p.name , p.host_id , p.location , P.pricepernight
ORDER BY 
   p.property_id ,p.name , p.host_id , p.location , P.pricepernight
ORDER BY 
   total_bookings DESC ;
-- Using RANK (assigns same rank to ties, with gaps)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.host_id,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_position
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.host_id, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;
-- Combined query with both ROW_NUMBER and RANK
SELECT 
    p.property_id,
    p.name AS property_name,
    p.host_id,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS row_number_rank,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS rank_position,
    DENSE_RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS dense_rank_position
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
GROUP BY 
    p.property_id, p.name, p.host_id, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;

-- =============================================================================
-- Additional Advanced Aggregation and Window Function Examples
-- =============================================================================

-- 3. AGGREGATION: Monthly booking statistics
SELECT 
    EXTRACT(YEAR FROM b.start_date) AS booking_year,
    EXTRACT(MONTH FROM b.start_date) AS booking_month,
    COUNT(b.booking_id) AS total_bookings,
    COUNT(DISTINCT b.user_id) AS unique_users,
    COUNT(DISTINCT b.property_id) AS unique_properties,
    AVG(b.total_price) AS average_booking_value,
    SUM(b.total_price) AS total_revenue
FROM 
    Booking b
GROUP BY 
    EXTRACT(YEAR FROM b.start_date), 
    EXTRACT(MONTH FROM b.start_date)
ORDER BY 
    booking_year DESC, booking_month DESC;

-- 4. WINDOW FUNCTION: Running totals and moving averages
SELECT 
    b.booking_id,
    b.start_date,
    b.total_price,
    SUM(b.total_price) OVER (ORDER BY b.start_date) AS running_total_revenue,
    AVG(b.total_price) OVER (
        ORDER BY b.start_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_3_bookings,
    COUNT(b.booking_id) OVER (ORDER BY b.start_date) AS cumulative_booking_count
FROM 
    Booking b
ORDER BY 
    b.start_date;

-- 5. WINDOW FUNCTION: Partition by property to rank bookings within each property
SELECT 
    b.booking_id,
    b.property_id,
    p.name AS property_name,
    b.user_id,
    b.start_date,
    b.total_price,
    ROW_NUMBER() OVER (PARTITION BY b.property_id ORDER BY b.start_date) AS booking_sequence,
    RANK() OVER (PARTITION BY b.property_id ORDER BY b.total_price DESC) AS price_rank_in_property
FROM 
    Booking b
INNER JOIN 
    Property p ON b.property_id = p.property_id
ORDER BY 
    b.property_id, b.start_date;

-- 6. ADVANCED AGGREGATION: User booking patterns with window functions
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent,
    AVG(b.total_price) AS avg_booking_value,
    MIN(b.start_date) AS first_booking_date,
    MAX(b.start_date) AS last_booking_date,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_frequency_rank,
    RANK() OVER (ORDER BY SUM(b.total_price) DESC) AS total_spending_rank,
    NTILE(4) OVER (ORDER BY SUM(b.total_price) DESC) AS spending_quartile
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name
ORDER BY 
    total_bookings DESC;

-- 7. PROPERTY PERFORMANCE ANALYSIS: Multiple metrics with window functions
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(b.booking_id) AS total_bookings,
    COALESCE(AVG(r.rating), 0) AS avg_rating,
    COUNT(r.review_id) AS total_reviews,
    SUM(b.total_price) AS total_revenue,
    
    -- Window functions for ranking
    ROW_NUMBER() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_count_rank,
    RANK() OVER (ORDER BY COALESCE(AVG(r.rating), 0) DESC) AS rating_rank,
    RANK() OVER (ORDER BY SUM(b.total_price) DESC) AS revenue_rank,
    
    -- Performance percentiles
    PERCENT_RANK() OVER (ORDER BY COUNT(b.booking_id)) AS booking_percentile,
    PERCENT_RANK() OVER (ORDER BY COALESCE(AVG(r.rating), 0)) AS rating_percentile
FROM 
    Property p
LEFT JOIN 
    Booking b ON p.property_id = b.property_id
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    total_bookings DESC;

-- 8. TIME-BASED ANALYSIS: Booking trends with window functions
SELECT 
    DATE_TRUNC('month', b.start_date) AS booking_month,
    COUNT(b.booking_id) AS monthly_bookings,
    SUM(b.total_price) AS monthly_revenue,
    
    -- Year-over-year comparison using LAG
    LAG(COUNT(b.booking_id), 12) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS same_month_last_year_bookings,
    
    -- Month-over-month growth
    LAG(COUNT(b.booking_id), 1) OVER (ORDER BY DATE_TRUNC('month', b.start_date)) AS previous_month_bookings,
    
    -- Running 12-month average
    AVG(COUNT(b.booking_id)) OVER (
        ORDER BY DATE_TRUNC('month', b.start_date)
        ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
    ) AS rolling_12_month_avg
FROM 
    Booking b
GROUP BY 
    DATE_TRUNC('month', b.start_date)
ORDER BY 
    booking_month;

-- =============================================================================
-- Performance Analysis Queries
-- =============================================================================

-- Compare different window function approaches
EXPLAIN ANALYZE
SELECT 
    property_id,
    COUNT(*) AS booking_count,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_pos
FROM 
    Booking
GROUP BY 
    property_id
ORDER BY 
    booking_count DESC;
