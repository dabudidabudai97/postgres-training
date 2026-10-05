SELECT title, price_per_night FROM properties
WHERE is_active
ORDER BY price_per_night DESC
LIMIT 3;