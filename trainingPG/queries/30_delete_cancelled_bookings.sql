BEGIN;

DELETE FROM bookings
WHERE status = 'cancelled'
RETURNING id, status;

ROLLBACK;