BEGIN;

INSERT INTO bookings (property_id, guest_id, check_in, check_out, guests_count, status, total_amount)
VALUES (7, '10000000-0000-0000-0000-000000000001', '2025-10-01', '2025-10-04', 2, 'pending', 27000)
RETURNING *;

ROLLBACK;