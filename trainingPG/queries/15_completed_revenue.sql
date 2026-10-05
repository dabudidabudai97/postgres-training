SELECT sum(total_amount) AS completed_revenue FROM bookings
WHERE status = 'completed';