SELECT title, price_per_night 
FROM properties
WHERE (is_active AND price_per_night <= 5000)
ORDER BY price_per_night ASC;
