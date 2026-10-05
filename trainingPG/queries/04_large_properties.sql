SELECT title, room_count, max_guests FROM properties
WHERE (is_active AND room_count >= 2 AND max_guests >= 4);