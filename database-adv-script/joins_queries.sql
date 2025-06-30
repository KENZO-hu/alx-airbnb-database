-- ALX Airbnb Database - Complex Queries with Joins
-- File: joins_queries.sql


-- =============================================================================
-- Task 0: Write Complex Queries with Joins
-- =============================================================================
-- 1 inner join
SELECT
b.booking_id , 
b.property_id, 
b.start_date , 
b.end_date ,
b.total_price , 
b.status , 
u.user_id, 
u.first_name , 
u.last_name , 
u.email ,
u.phone_number 
from
    booking b 
INNER join
    User u on b.user_id = u.user_id
ORDER BY
    b.created_at DESC; 
-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews
-- This query returns all properties, even those without reviews
SELECT 
   p.property_id , 
   p.host_id , 
   p.name As property_name , 
   p.description , 
   P.location ,
   p.pricepernight ,
   r.review_id , 
   r.rating , 
   r.comment ,
   r.created_at as review_date 
from
   property P
LEFT JOIN 
   Review r on p.property_id = r.property_id
ORDER BY 
   p.property_id , r.created_at DESC ; 
-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user
-- This query returns all users and all bookings, showing orphaned records on both sides
SELECT 
  u.user_id , 
  u.first_name,
  u.last_name,
  u.email,
  u.role , 
  b.booking_id,
  b.property_id,
  b.start_date,
  b.end_date,
  b.total_price,
  b.status,
  b.created_at As booking_created 
from
    user u 
FULL OUTER JOIN 
    Booking b on u.user_id =  b.user_id
ORDER BY
    u.user_id , b.created_at DESC ;
-- =============================================================================
-- Additional Analysis Queries (Optional Enhancement)
-- =============================================================================

-- Query to count bookings per user (using INNER JOIN)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_price) AS total_spent
FROM 
    User u
INNER JOIN 
    Booking b ON u.user_id = b.user_id
GROUP BY 
    u.user_id, u.first_name, u.last_name
ORDER BY 
    total_bookings DESC;

-- Query to show properties with their average ratings (using LEFT JOIN)
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    COUNT(r.review_id) AS total_reviews,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM 
    Property p
LEFT JOIN 
    Review r ON p.property_id = r.property_id
GROUP BY 
    p.property_id, p.name, p.location, p.pricepernight
ORDER BY 
    average_rating DESC NULLS LAST;

-- Query to identify users without bookings and bookings without users (using FULL OUTER JOIN)
SELECT 
    CASE 
        WHEN u.user_id IS NULL THEN 'Orphaned Booking'
        WHEN b.booking_id IS NULL THEN 'User Without Booking'
        ELSE 'Matched Record'
    END AS record_type,
    u.user_id,
    u.first_name,
    u.last_name,
    b.booking_id,
    b.total_price
FROM 
    User u
FULL OUTER JOIN 
    Booking b ON u.user_id = b.user_id
WHERE 
    u.user_id IS NULL OR b.booking_id IS NULL
ORDER BY 
    record_type, u.user_id, b.booking_id;
