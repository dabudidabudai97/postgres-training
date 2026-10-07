SELECT p.title AS property_title, c.name AS city_name
FROM properties AS p
LEFT JOIN cities AS c 
ON p.city_id = c.id;