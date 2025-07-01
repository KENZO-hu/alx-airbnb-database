-- Partitioning Large Tables - Booking Table Partitioning
-- This script demonstrates partitioning the Booking table based on start_date

-- First, let's assume we have an existing Booking table structure
-- We'll need to recreate it with partitioning

-- Step 1: Create a backup of existing data (if table exists)
-- CREATE TABLE booking_backup AS SELECT * FROM Booking;

-- Step 2: Drop the existing table (uncomment if needed)
-- DROP TABLE IF EXISTS Booking;

-- Step 3: Create the partitioned Booking table
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Foreign key constraints
    FOREIGN KEY (property_id) REFERENCES Property(property_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE
) PARTITION BY RANGE (start_date);

-- Step 4: Create partitions for different date ranges
-- Partition for bookings in 2023
CREATE TABLE booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

-- Partition for bookings in 2024
CREATE TABLE booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

-- Partition for bookings in 2025
CREATE TABLE booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Partition for future bookings (2026 and beyond)
CREATE TABLE booking_future PARTITION OF Booking
    FOR VALUES FROM ('2026-01-01') TO (MAXVALUE);

-- Step 5: Create indexes on partitioned table for better performance
CREATE INDEX idx_booking_user_id ON Booking (user_id);
CREATE INDEX idx_booking_property_id ON Booking (property_id);
CREATE INDEX idx_booking_status ON Booking (status);
CREATE INDEX idx_booking_date_range ON Booking (start_date, end_date);

-- Step 6: Insert sample data to test partitioning (optional)
INSERT INTO Booking (property_id, user_id, start_date, end_date, total_price, status) VALUES
    (gen_random_uuid(), gen_random_uuid(), '2023-06-15', '2023-06-20', 500.00, 'confirmed'),
    (gen_random_uuid(), gen_random_uuid(), '2024-03-10', '2024-03-15', 750.00, 'confirmed'),
    (gen_random_uuid(), gen_random_uuid(), '2025-07-01', '2025-07-07', 900.00, 'pending'),
    (gen_random_uuid(), gen_random_uuid(), '2025-12-20', '2025-12-25', 1200.00, 'confirmed');

-- Step 7: Performance test queries
-- Query 1: Fetch bookings for a specific date range (should use partition pruning)
EXPLAIN (ANALYZE, BUFFERS) 
SELECT * FROM Booking 
WHERE start_date >= '2024-01-01' AND start_date < '2025-01-01';

-- Query 2: Fetch bookings for a specific month
EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) FROM Booking 
WHERE start_date >= '2024-06-01' AND start_date < '2024-07-01';

-- Query 3: Fetch recent bookings (should primarily hit recent partitions)
EXPLAIN (ANALYZE, BUFFERS)
SELECT b.booking_id, b.start_date, b.end_date, b.total_price, b.status
FROM Booking b
WHERE b.start_date >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY b.start_date DESC;

-- Step 8: Show partition information
SELECT 
    schemaname,
    tablename,
    attname,
    n_distinct,
    correlation
FROM pg_stats 
WHERE tablename LIKE 'booking%';

-- Query to show partition details
SELECT 
    pt.schemaname,
    pt.tablename as partition_name,
    pg_size_pretty(pg_total_relation_size(pt.schemaname||'.'||pt.tablename)) as size
FROM pg_tables pt
WHERE pt.tablename LIKE 'booking%'
ORDER BY pt.tablename;