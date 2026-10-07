SELECT b.id, u.name, b.check_in, b.check_out
FROM bookings AS b
LEFT JOIN users AS u
ON b.guest_id = u.uid;