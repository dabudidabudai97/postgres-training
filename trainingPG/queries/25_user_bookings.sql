SELECT b.id, p.title, b.check_in, b.check_out, b.status
FROM bookings AS b
JOIN users AS u
ON b.guest_id = u.uid
JOIN properties AS p
ON b.property_id = p.id
WHERE u.email = 'elena@example.com';