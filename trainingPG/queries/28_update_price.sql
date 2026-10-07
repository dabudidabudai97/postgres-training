BEGIN;

SELECT id, price_per_night FROM properties
WHERE id = 7;

UPDATE properties 
SET price_per_night = price_per_night + (price_per_night * 0.1)
WHERE id = 7
RETURNING id, price_per_night;

ROLLBACK;