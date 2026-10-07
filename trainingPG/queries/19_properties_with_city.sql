SELECT p.title, u.name, u.email
FROM properties AS p
LEFT JOIN users AS u
ON p.owner_id = u.uid;