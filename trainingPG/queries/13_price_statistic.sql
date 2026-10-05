SELECT min(price_per_night) AS min_price,
max(price_per_night) AS max_price,
round(avg(price_per_night), 2) AS avg_price
FROM properties
WHERE is_active;