SELECT property_id, count(*) AS booking_count FROM bookings
GROUP BY property_id;