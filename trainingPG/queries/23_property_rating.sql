SELECT p.title, round(avg(r.rating), 2), count(r.id)
FROM properties AS p
LEFT JOIN bookings AS b
ON p.id = b.property_id
LEFT JOIN reviews AS r
ON b.id = r.booking_id
WHERE p.is_active
GROUP BY p.id;