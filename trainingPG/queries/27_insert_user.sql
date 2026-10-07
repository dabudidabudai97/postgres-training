BEGIN;

INSERT INTO users (name, email) 
VALUES ('Дмитрий Димитриев', 'dimitrievdima97@gmail.com')
RETURNING *;

ROLLBACK;