SELECT p.id, p.title
FROM properties AS p
LEFT JOIN bookings AS b
ON p.id = b.property_id
WHERE p.is_active
AND b.id IS NULL;