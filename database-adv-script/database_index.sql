-- Database Index Creation Script with Performance Measurement
-- This script measures query performance before and after index creation

-- 1. Create a log table to store performance results
CREATE TABLE IF NOT EXISTS index_performance_log (
    test_id SERIAL PRIMARY KEY,
    query_name VARCHAR(100),
    stage VARCHAR(20) CHECK (stage IN ('before', 'after')),
    execution_time_ms FLOAT,
    plan JSON,
    test_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Define test queries (using prepared statements to ensure consistency)
PREPARE user_bookings_query AS
SELECT u.first_name, u.last_name, b.start_date, b.end_date, p.name as property_name
FROM User u
JOIN Booking b ON u.user_id = b.user_id
JOIN Property p ON b.property_id = p.property_id
WHERE b.status = 'confirmed'
AND b.start_date >= '2024-01-01';

PREPARE property_search_query AS
SELECT *
FROM Property
WHERE location = 'New York'
AND pricepernight BETWEEN 100 AND 300
ORDER BY pricepernight ASC;

PREPARE user_activity_query AS
SELECT u.email, COUNT(b.booking_id) as booking_count
FROM User u
LEFT JOIN Booking b ON u.user_id = b.user_id
WHERE u.created_at >= '2023-01-01'
GROUP BY u.user_id, u.email
HAVING COUNT(b.booking_id) > 2;

-- 3. Run performance tests BEFORE index creation
DO $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    exec_plan JSON;
BEGIN
    -- Test Query 1: User Bookings
    start_time := clock_timestamp();
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) EXECUTE user_bookings_query' INTO exec_plan;
    end_time := clock_timestamp();
    
    INSERT INTO index_performance_log (query_name, stage, execution_time_ms, plan)
    VALUES ('user_bookings', 'before', 
            EXTRACT(EPOCH FROM (end_time - start_time)) * 1000,
            exec_plan);
    
    -- Test Query 2: Property Search
    start_time := clock_timestamp();
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) EXECUTE property_search_query' INTO exec_plan;
    end_time := clock_timestamp();
    
    INSERT INTO index_performance_log (query_name, stage, execution_time_ms, plan)
    VALUES ('property_search', 'before',
            EXTRACT(EPOCH FROM (end_time - start_time)) * 1000,
            exec_plan);
    
    -- Test Query 3: User Activity
    start_time := clock_timestamp();
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) EXECUTE user_activity_query' INTO exec_plan;
    end_time := clock_timestamp();
    
    INSERT INTO index_performance_log (query_name, stage, execution_time_ms, plan)
    VALUES ('user_activity', 'before',
            EXTRACT(EPOCH FROM (end_time - start_time)) * 1000,
            exec_plan);
END $$;

-- 4. Create indexes (same as previous version)
CREATE INDEX IF NOT EXISTS idx_user_email ON User(email);
CREATE INDEX IF NOT EXISTS idx_user_created_at ON User(created_at);
CREATE INDEX IF NOT EXISTS idx_user_phone ON User(phone_number);

CREATE INDEX IF NOT EXISTS idx_booking_user_status ON Booking(user_id, status);
CREATE INDEX IF NOT EXISTS idx_booking_property_dates ON Booking(property_id, start_date, end_date);
CREATE INDEX IF NOT EXISTS idx_booking_start_date ON Booking(start_date);
CREATE INDEX IF NOT EXISTS idx_booking_end_date ON Booking(end_date);
CREATE INDEX IF NOT EXISTS idx_booking_status ON Booking(status);
CREATE INDEX IF NOT EXISTS idx_booking_created_at ON Booking(created_at);

CREATE INDEX IF NOT EXISTS idx_property_host_id ON Property(host_id);
CREATE INDEX IF NOT EXISTS idx_property_location ON Property(location);
CREATE INDEX IF NOT EXISTS idx_property_price ON Property(pricepernight);
CREATE INDEX IF NOT EXISTS idx_property_location_price ON Property(location, pricepernight);
CREATE INDEX IF NOT EXISTS idx_property_created_at ON Property(created_at);

-- 5. Run performance tests AFTER index creation
DO $$
DECLARE
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    exec_plan JSON;
BEGIN
    -- Refresh statistics to ensure optimizer uses new indexes
    ANALYZE User;
    ANALYZE Booking;
    ANALYZE Property;
    
    -- Test Query 1: User Bookings
    start_time := clock_timestamp();
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) EXECUTE user_bookings_query' INTO exec_plan;
    end_time := clock_timestamp();
    
    INSERT INTO index_performance_log (query_name, stage, execution_time_ms, plan)
    VALUES ('user_bookings', 'after',
            EXTRACT(EPOCH FROM (end_time - start_time)) * 1000,
            exec_plan);
    
    -- Test Query 2: Property Search
    start_time := clock_timestamp();
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) EXECUTE property_search_query' INTO exec_plan;
    end_time := clock_timestamp();
    
    INSERT INTO index_performance_log (query_name, stage, execution_time_ms, plan)
    VALUES ('property_search', 'after',
            EXTRACT(EPOCH FROM (end_time - start_time)) * 1000,
            exec_plan);
    
    -- Test Query 3: User Activity
    start_time := clock_timestamp();
    EXECUTE 'EXPLAIN (ANALYZE, FORMAT JSON) EXECUTE user_activity_query' INTO exec_plan;
    end_time := clock_timestamp();
    
    INSERT INTO index_performance_log (query_name, stage, execution_time_ms, plan)
    VALUES ('user_activity', 'after',
            EXTRACT(EPOCH FROM (end_time - start_time)) * 1000,
            exec_plan);
END $$;

-- 6. Generate performance comparison report
SELECT 
    before.query_name,
    before.execution_time_ms AS before_ms,
    after.execution_time_ms AS after_ms,
    ROUND((before.execution_time_ms - after.execution_time_ms) / before.execution_time_ms * 100, 2) AS improvement_pct,
    before.plan AS before_plan,
    after.plan AS after_plan
FROM 
    (SELECT * FROM index_performance_log WHERE stage = 'before') before
JOIN 
    (SELECT * FROM index_performance_log WHERE stage = 'after') after
ON before.query_name = after.query_name;

-- Cleanup prepared statements
DEALLOCATE user_bookings_query;
DEALLOCATE property_search_query;
DEALLOCATE user_activity_query;
