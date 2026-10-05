SELECT id, check_in, check_out, total_amount FROM bookings
WHERE status = 'completed'
ORDER BY check_in DESC;