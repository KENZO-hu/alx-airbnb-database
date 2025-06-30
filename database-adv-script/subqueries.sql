-- find all properties where the average rating is grater than 4.0
SELECT 
   p.property_id,
   p.name As property_name,
   p.host_id,
   p.location,
   p.pricepernight,
   P.description,
FROM
   property p
WHERE
   P.property_id IN (
    SELECT 
        r.property_id
    FROM
        Review r
    GROUP BY
        r.property_id
    HAVING
        AVG(r.rating)>4.0
   );
-- find users who have made more than three bookings 
SELECT 
     u.user_id,
     u.first_name,
     u.last_name,
     u.email,
     u.phone_number,
     u.role,
FROM 
   User u
where
   (SELECT COUNT(*)
   FROM booking b
   WHERE b.user_id = u.user_id) > 3 ;
   