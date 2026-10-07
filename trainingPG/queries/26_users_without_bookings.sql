SELECT u.name, u.email
FROM users AS u
LEFT JOIN bookings AS b
ON u.uid = b.guest_id
WHERE b.id IS NULL;