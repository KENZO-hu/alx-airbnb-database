INSERT INTO User (user_id, first_name, last_name, email, password_hash, phone_number, role, profile_picture, date_of_birth, created_at) VALUES
-- Admin Users
('550e8400-e29b-41d4-a716-446655440001', 'Alice', 'Johnson', 'alice.admin@airbnb.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0101', 'admin', 'https://example.com/profiles/alice.jpg', '1985-03-15', '2024-01-01 10:00:00'),

-- Host Users
('550e8400-e29b-41d4-a716-446655440002', 'Robert', 'Smith', 'robert.smith@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0102', 'host', 'https://example.com/profiles/robert.jpg', '1980-07-22', '2024-01-02 09:15:00'),
('550e8400-e29b-41d4-a716-446655440003', 'Maria', 'Garcia', 'maria.garcia@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0103', 'host', 'https://example.com/profiles/maria.jpg', '1978-11-30', '2024-01-03 11:30:00'),
('550e8400-e29b-41d4-a716-446655440004', 'James', 'Wilson', 'james.wilson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0104', 'host', 'https://example.com/profiles/james.jpg', '1975-09-12', '2024-01-04 14:20:00'),
('550e8400-e29b-41d4-a716-446655440005', 'Sarah', 'Brown', 'sarah.brown@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0105', 'host', 'https://example.com/profiles/sarah.jpg', '1982-05-18', '2024-01-05 16:45:00'),
('550e8400-e29b-41d4-a716-446655440006', 'David', 'Lee', 'david.lee@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0106', 'host', 'https://example.com/profiles/david.jpg', '1987-12-08', '2024-01-06 08:30:00'),

-- Guest Users
('550e8400-e29b-41d4-a716-446655440007', 'Emma', 'Davis', 'emma.davis@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0107', 'guest', 'https://example.com/profiles/emma.jpg', '1990-02-14', '2024-01-07 12:00:00'),
('550e8400-e29b-41d4-a716-446655440008', 'Michael', 'Taylor', 'michael.taylor@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0108', 'guest', 'https://example.com/profiles/michael.jpg', '1988-08-25', '2024-01-08 15:30:00'),
('550e8400-e29b-41d4-a716-446655440009', 'Jennifer', 'Anderson', 'jennifer.anderson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0109', 'guest', 'https://example.com/profiles/jennifer.jpg', '1992-06-10', '2024-01-09 09:45:00'),
('550e8400-e29b-41d4-a716-446655440010', 'Christopher', 'Martinez', 'chris.martinez@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0110', 'guest', 'https://example.com/profiles/chris.jpg', '1986-04-03', '2024-01-10 13:15:00'),
('550e8400-e29b-41d4-a716-446655440011', 'Jessica', 'Thompson', 'jessica.thompson@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0111', 'guest', 'https://example.com/profiles/jessica.jpg', '1994-01-20', '2024-01-11 10:30:00'),
('550e8400-e29b-41d4-a716-446655440012', 'Daniel', 'White', 'daniel.white@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0112', 'guest', 'https://example.com/profiles/daniel.jpg', '1991-10-15', '2024-01-12 14:45:00'),
('550e8400-e29b-41d4-a716-446655440013', 'Ashley', 'Harris', 'ashley.harris@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0113', 'guest', 'https://example.com/profiles/ashley.jpg', '1989-07-28', '2024-01-13 11:20:00'),
('550e8400-e29b-41d4-a716-446655440014', 'Matthew', 'Clark', 'matthew.clark@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0114', 'guest', 'https://example.com/profiles/matthew.jpg', '1993-03-05', '2024-01-14 16:10:00'),
('550e8400-e29b-41d4-a716-446655440015', 'Amanda', 'Lewis', 'amanda.lewis@email.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LeOKVyKXQqJ7L7mGW', '+1-555-0115', 'guest', 'https://example.com/profiles/amanda.jpg', '1987-12-18', '2024-01-15 12:55:00');
-- =============================================================================
-- SEED PROPERTY DATA
-- =============================================================================

INSERT INTO Property (property_id, host_id, name, description, location, latitude, longitude, pricepernight, max_guests, bedrooms, bathrooms, property_type, amenities, availability_status, created_at) VALUES

-- Robert Smith's Properties
('650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440002', 'Cozy Manhattan Studio', 'Modern studio apartment in the heart of Manhattan. Perfect for business travelers and couples. Walking distance to Central Park and subway stations.', 'New York, NY, USA', 40.7831, -73.9712, 150.00, 2, 0, 1, 'studio', '{"wifi": true, "kitchen": true, "air_conditioning": true, "elevator": true, "doorman": true, "gym": false, "pool": false, "parking": false, "pet_friendly": false, "smoking_allowed": false}', 'available', '2024-01-16 10:00:00'),

('650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440002', 'Brooklyn Heights Loft', 'Spacious loft with stunning views of Manhattan skyline. Industrial design with modern amenities. Great for families and groups.', 'Brooklyn, NY, USA', 40.6962, -73.9926, 220.00, 6, 2, 2, 'loft', '{"wifi": true, "kitchen": true, "air_conditioning": true, "heating": true, "washer_dryer": true, "dishwasher": true, "microwave": true, "coffee_maker": true, "tv": true, "workspace": true}', 'available', '2024-01-17 11:30:00'),

-- Maria Garcia's Properties
('650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440003', 'Miami Beach Condo', 'Luxury beachfront condo with ocean views. Private balcony, pool access, and steps from the beach. Perfect for vacation rentals.', 'Miami Beach, FL, USA', 25.7907, -80.1300, 180.00, 4, 2, 2, 'condo', '{"wifi": true, "kitchen": true, "air_conditioning": true, "pool": true, "beach_access": true, "balcony": true, "ocean_view": true, "parking": true, "gym": true, "concierge": true}', 'available', '2024-01-18 09:15:00'),

('650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440003', 'Coral Gables Villa', 'Elegant Mediterranean-style villa with private pool and garden. Quiet residential area, perfect for families and luxury getaways.', 'Coral Gables, FL, USA', 25.7463, -80.2586, 350.00, 8, 4, 3, 'villa', '{"wifi": true, "kitchen": true, "air_conditioning": true, "pool": true, "garden": true, "parking": true, "bbq_grill": true, "outdoor_dining": true, "fireplace": true, "wine_fridge": true}', 'available', '2024-01-19 14:20:00'),

-- James Wilson's Properties
('650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440004', 'San Francisco Victorian', 'Charming Victorian house in Pacific Heights. Historic charm with modern updates. Close to Golden Gate Park and downtown.', 'San Francisco, CA, USA', 37.7749, -122.4194, 280.00, 6, 3, 2, 'house', '{"wifi": true, "kitchen": true, "heating": true, "fireplace": true, "garden": true, "parking": true, "washer_dryer": true, "dishwasher": true, "workspace": true, "pet_friendly": true}', 'available', '2024-01-20 16:45:00'),

('650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440004', 'Napa Valley Vineyard Cottage', 'Romantic cottage surrounded by vineyards. Perfect for wine enthusiasts and couples seeking a peaceful retreat.', 'Napa Valley, CA, USA', 38.2975, -122.2869, 320.00, 4, 2, 2, 'house', '{"wifi": true, "kitchen": true, "fireplace": true, "garden": true, "parking": true, "hot_tub": true, "wine_tasting": true, "vineyard_view": true, "bbq_grill": true, "outdoor_seating": true}', 'available', '2024-01-21 12:30:00'),

-- Sarah Brown's Properties
('650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440005', 'Austin Music District Apartment', 'Hip apartment in the heart of Austin music scene. Walking distance to live music venues, restaurants, and nightlife.', 'Austin, TX, USA', 30.2672, -97.7431, 130.00, 4, 2, 1, 'apartment', '{"wifi": true, "kitchen": true, "air_conditioning": true, "balcony": true, "parking": true, "music_room": true, "sound_system": true, "workspace": true, "pet_friendly": true, "bike_storage": true}', 'available', '2024-01-22 08:45:00'),

('650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440005', 'Lake Travis Lakehouse', 'Stunning lakehouse with private dock and water activities. Perfect for groups and families seeking outdoor adventures.', 'Lake Travis, TX, USA', 30.3394, -97.9000, 400.00, 10, 5, 4, 'house', '{"wifi": true, "kitchen": true, "air_conditioning": true, "lake_access": true, "dock": true, "kayaks": true, "bbq_grill": true, "fire_pit": true, "outdoor_dining": true, "parking": true}', 'available', '2024-01-23 15:20:00'),

-- David Lee's Properties
('650e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440006', 'Seattle Capitol Hill Townhouse', 'Modern townhouse in trendy Capitol Hill neighborhood. Close to coffee shops, restaurants, and cultural attractions.', 'Seattle, WA, USA', 47.6062, -122.3321, 200.00, 6, 3, 2, 'townhouse', '{"wifi": true, "kitchen": true, "heating": true, "fireplace": true, "parking": true, "washer_dryer": true, "dishwasher": true, "workspace": true, "coffee_maker": true, "bookshelf": true}', 'available', '2024-01-24 10:10:00'),

('650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440006', 'Pike Place Market Loft', 'Industrial loft overlooking Pike Place Market. Unique location with market access and waterfront views.', 'Seattle, WA, USA', 47.6089, -122.3403, 190.00, 4, 1, 1, 'loft', '{"wifi": true, "kitchen": true, "heating": true, "market_view": true, "water_view": true, "elevator": true, "workspace": true, "coffee_maker": true, "sound_system": true, "art_studio": true}', 'available', '2024-01-25 13:35:00');

-- =============================================================================
-- SEED BOOKING DATA
-- =============================================================================

INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status, guest_count, special_requests, booking_reference, created_at) VALUES

-- Completed Bookings (Past dates for realistic data)
('750e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440007', '2024-02-01', '2024-02-05', 600.00, 'completed', 2, 'Late check-in requested', 'ABB2024000001', '2024-01-25 09:30:00'),

('750e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008', '2024-02-10', '2024-02-17', 1260.00, 'completed', 4, 'Beach chairs and umbrellas needed', 'ABB2024000002', '2024-02-01 14:20:00'),

('750e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440009', '2024-02-15', '2024-02-20', 1400.00, 'completed', 6, 'Vegetarian welcome basket', 'ABB2024000003', '2024-02-05 11:45:00'),

('750e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440010', '2024-03-01', '2024-03-05', 520.00, 'completed', 3, 'Concert tickets recommendations', 'ABB2024000004', '2024-02-20 16:30:00'),

('750e8400-e29b-41d4-a716-446655440005', '650e8400-e29b-41d4-a716-446655440002', '550e8400-e29b-41d4-a716-446655440011', '2024-03-10', '2024-03-15', 1100.00, 'completed', 5, 'Baby crib needed', 'ABB2024000005', '2024-02-25 10:15:00'),

-- Confirmed Bookings (Future dates)
('750e8400-e29b-41d4-a716-446655440006', '650e8400-e29b-41d4-a716-446655440004', '550e8400-e29b-41d4-a716-446655440012', '2024-07-01', '2024-07-08', 2450.00, 'confirmed', 8, 'Pool heating requested', 'ABB2024000006', '2024-06-15 13:20:00'),

('750e8400-e29b-41d4-a716-446655440007', '650e8400-e29b-41d4-a716-446655440006', '550e8400-e29b-41d4-a716-446655440013', '2024-07-15', '2024-07-20', 1600.00, 'confirmed', 4, 'Wine tour booking assistance', 'ABB2024000007', '2024-06-20 15:45:00'),

('750e8400-e29b-41d4-a716-446655440008', '650e8400-e29b-41d4-a716-446655440008', '550e8400-e29b-41d4-a716-446655440014', '2024-08-01', '2024-08-05', 1600.00, 'confirmed', 8, 'Boat rental information', 'ABB2024000008', '2024-07-10 12:30:00'),

('750e8400-e29b-41d4-a716-446655440009', '650e8400-e29b-41d4-a716-446655440009', '550e8400-e29b-41d4-a716-446655440015', '2024-08-10', '2024-08-14', 800.00, 'confirmed', 4, 'Coffee shop recommendations', 'ABB2024000009', '2024-07-25 09:10:00'),

-- Pending Bookings
('750e8400-e29b-41d4-a716-446655440010', '650e8400-e29b-41d4-a716-446655440010', '550e8400-e29b-41d4-a716-446655440007', '2024-09-01', '2024-09-04', 570.00, 'pending', 2, 'Market tour interest', 'ABB2024000010', '2024-08-20 14:25:00'),

-- Canceled Booking
('750e8400-e29b-41d4-a716-446655440011', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440008', '2024-04-01', '2024-04-05', 600.00, 'canceled', 2, 'Travel plans changed', 'ABB2024000011', '2024-03-15 11:20:00');

-- =============================================================================
-- SEED PAYMENT DATA
-- =============================================================================

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, payment_status, transaction_id, currency, processing_fee, payment_gateway, created_at) VALUES

-- Completed Payments
('850e8400-e29b-41d4-a716-446655440001', '750e8400-e29b-41d4-a716-446655440001', 600.00, '2024-01-25 09:45:00', 'credit_card', 'completed', 'TXN_001_2024_STRIPE', 'USD', 18.00, 'Stripe', '2024-01-25 09:45:00'),

('850e8400-e29b-41d4-a716-446655440002', '750e8400-e29b-41d4-a716-446655440002', 1260.00, '2024-02-01 14:35:00', 'credit_card', 'completed', 'TXN_002_2024_STRIPE', 'USD', 37.80, 'Stripe', '2024-02-01 14:35:00'),

('850e8400-e29b-41d4-a716-446655440003', '750e8400-e29b-41d4-a716-446655440003', 1400.00, '2024-02-05 12:00:00', 'paypal', 'completed', 'TXN_003_2024_PAYPAL', 'USD', 42.00, 'PayPal', '2024-02-05 12:00:00'),

('850e8400-e29b-41d4-a716-446655440004', '750e8400-e29b-41d4-a716-446655440004', 520.00, '2024-02-20 16:45:00', 'debit_card', 'completed', 'TXN_004_2024_STRIPE', 'USD', 15.60, 'Stripe', '2024-02-20 16:45:00'),

('850e8400-e29b-41d4-a716-446655440005', '750e8400-e29b-41d4-a716-446655440005', 1100.00, '2024-02-25 10:30:00', 'credit_card', 'completed', 'TXN_005_2024_STRIPE', 'USD', 33.00, 'Stripe', '2024-02-25 10:30:00'),

('850e8400-e29b-41d4-a716-446655440006', '750e8400-e29b-41d4-a716-446655440006', 2450.00, '2024-06-15 13:35:00', 'bank_transfer', 'completed', 'TXN_006_2024_WISE', 'USD', 24.50, 'Wise', '2024-06-15 13:35:00'),

('850e8400-e29b-41d4-a716-446655440007', '750e8400-e29b-41d4-a716-446655440007', 1600.00, '2024-06-20 16:00:00', 'credit_card', 'completed', 'TXN_007_2024_STRIPE', 'USD', 48.00, 'Stripe', '2024-06-20 16:00:00'),

('850e8400-e29b-41d4-a716-446655440008', '750e8400-e29b-41d4-a716-446655440008', 1600.00, '2024-07-10 12:45:00', 'digital_wallet', 'completed', 'TXN_008_2024_APPLE', 'USD', 32.00, 'Apple Pay', '2024-07-10 12:45:00'),

('850e8400-e29b-41d4-a716-446655440009', '750e8400-e29b-41d4-a716-446655440009', 800.00, '2024-07-25 09:25:00', 'paypal', 'completed', 'TXN_009_2024_PAYPAL', 'USD', 24.00, 'PayPal', '2024-07-25 09:25:00'),

-- Pending Payment
('850e8400-e29b-41d4-a716-446655440010', '750e8400-e29b-41d4-a716-446655440010', 570.00, '2024-08-20 14:40:00', 'credit_card', 'pending', 'TXN_010_2024_STRIPE', 'USD', 17.10, 'Stripe', '2024-08-20 14:40:00'),

-- Refunded Payment
('850e8400-e29b-41d4-a716-446655440011', '750e8400-e29b-41d4-a716-446655440011', 600.00, '2024-03-15 11:35:00', 'credit_card', 'refunded', 'TXN_011_2024_STRIPE', 'USD', 18.00, 'Stripe', '2024-03-15 11:35:00');

-- =============================================================================
-- SEED REVIEW DATA
-- =============================================================================

INSERT INTO Review (review_id, property_id, user_id, booking_id, rating, comment, review_type, is_verified, helpful_count, response_from_host, created_at) VALUES

-- Property Reviews (Verified from completed bookings)
('950e8400-e29b-41d4-a716-446655440001', '650e8400-e29b-41d4-a716-446655440001', '550e8400-e29b-41d4-a716-446655440007', '750e8400-e29b-41d4-a716-446655440001', 5, 'Amazing location in Manhattan! The studio was clean, modern, and had everything we needed. Robert was very responsive and helpful. Walking distance to Central Park and great restaurants. Highly recommend!', 'property', TRUE, 12, 'Thank you Emma! So glad you enjoyed your stay. You are welcome back anytime!', '2024-02-08 10:30:00'),

('950e8400-e29b-41d4-a716-446655440002', '650e8400-e29b-41d4-a716-446655440003', '550e8400-e29b-41d4-a716-446655440008', '750e8400-e29b-41d4-a716-446655440002', 5, 'Perfect beachfront location! The condo was spacious and beautifully decorated. The ocean view from the balcony was breathtaking. Pool area was great for relaxation. Maria provided excellent local recommendations.', 'property', TRUE, 8, 'Thank you Michael! Hope to host you again soon!', '2024-02-20 14:15:00'),

('950e8400-e29b-41d4-a716-446655440003', '650e8400-e29b-41d4-a716-446655440005', '550e8400-e29b-41d4-a716-446655440009', '750e8400-e29b-41d4-a716-446655440003', 4, 'Beautiful Victorian house with so much character! Great location near Golden Gate Park. The house was well-maintained and had all modern amenities. Only minor issue was street parking, but overall excellent experience.', 'property', TRUE, 6, 'Thanks Jennifer! We are working on improving parking options for our guests.', '2024-02-25 16:45:00'),

('950e8400-e29b-41d4-a716-446655440004', '650e8400-e29b-41d4-a716-446655440007', '550e8400-e29b-41d4-a716-446655440010', '750e8400-e29b-41d4-a716-446655440004', 5, 'beutifaul vectorian house that u have all the thing in it'),