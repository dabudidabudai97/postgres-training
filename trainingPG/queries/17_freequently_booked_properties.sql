SELECT property_id, count(*) FROM bookings
WHERE status != 'cancelled'
GROUP BY property_id
HAVING count(*) > 1;