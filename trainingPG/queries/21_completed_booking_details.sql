SELECT b.id, p.title, u.name, b.check_in, b.check_out, b.total_amount
FROM bookings AS b
LEFT JOIN properties AS p
ON b.property_id = p.id
LEFT JOIN users AS u
ON b.guest_id = u.uid
WHERE b.status = 'completed';