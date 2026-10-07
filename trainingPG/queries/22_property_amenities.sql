SELECT p.title, a.name
FROM properties AS p
INNER JOIN property_amenities AS pa
ON p.id = pa.property_id
INNER JOIN amenities AS a
ON pa.amenity_id = a.id
ORDER BY p.title ASC, a.name ASC;