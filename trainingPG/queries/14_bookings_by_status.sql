SELECT status, count(status) AS count FROM bookings
GROUP BY status
ORDER BY count DESC;