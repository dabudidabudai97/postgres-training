-- +goose Up

-- This migration creates exactly 500 synthetic bookings. Supporting users,
-- properties, amenity links, payments and reviews are generated as well.

WITH generated AS (
    SELECT generate_series(1, 100) AS n
)
INSERT INTO users (uid, name, email, created_at)
SELECT
    uuid_generate_v5(uuid_ns_url(), 'postgres-training-fake-user-' || n),
    (ARRAY[
        'Алексей', 'Алина', 'Андрей', 'Валерия', 'Виктор',
        'Дарья', 'Евгений', 'Екатерина', 'Иван', 'Ирина',
        'Кирилл', 'Мария', 'Максим', 'Наталья', 'Никита',
        'Ольга', 'Павел', 'Полина', 'Роман', 'София'
    ])[1 + ((n - 1) % 20)]
    || ' ' ||
    (ARRAY[
        'Иванов', 'Петров', 'Смирнов', 'Кузнецов', 'Попов',
        'Васильев', 'Соколов', 'Михайлов', 'Новиков', 'Фёдоров'
    ])[1 + (((n - 1) / 20) % 10)],
    'fake.' || lpad(n::text, 3, '0') || '@rental.test',
    TIMESTAMPTZ '2024-01-01 09:00:00+03' + n * INTERVAL '1 day'
FROM generated
ON CONFLICT DO NOTHING;

WITH generated AS (
    SELECT generate_series(1, 120) AS n
)
INSERT INTO properties (
    owner_id,
    city_id,
    title,
    description,
    address,
    room_count,
    max_guests,
    price_per_night,
    is_active,
    created_at
)
SELECT
    uuid_generate_v5(
        uuid_ns_url(),
        'postgres-training-fake-user-' || (1 + ((n - 1) % 30))
    ),
    (
        SELECT id
        FROM cities
        WHERE name = CASE ((n - 1) % 3)
            WHEN 0 THEN 'Москва'
            WHEN 1 THEN 'Санкт-Петербург'
            ELSE 'Казань'
        END
        AND country = 'Россия'
    ),
    'Учебное жильё #' || lpad(n::text, 3, '0'),
    'Сгенерировано миграцией 00003',
    'Учебная улица, дом ' || n,
    1 + ((n - 1) % 4),
    2 + ((n - 1) % 5),
    2000.00 + ((n - 1) % 25) * 350.00,
    n % 10 <> 0,
    TIMESTAMPTZ '2024-02-01 10:00:00+03' + n * INTERVAL '1 day'
FROM generated
ON CONFLICT DO NOTHING;

WITH generated AS (
    SELECT
        n,
        slot
    FROM generate_series(1, 120) AS numbers(n)
    CROSS JOIN generate_series(0, 2) AS slots(slot)
)
INSERT INTO property_amenities (property_id, amenity_id)
SELECT
    p.id,
    1 + (((g.n - 1) + g.slot * 2) % 7)
FROM generated g
JOIN properties p
    ON p.title = 'Учебное жильё #' || lpad(g.n::text, 3, '0')
   AND p.description = 'Сгенерировано миграцией 00003'
ON CONFLICT DO NOTHING;

WITH generated AS (
    SELECT
        n,
        1 + (((n - 1) * 37) % 120) AS property_number,
        31 + (((n - 1) * 13) % 70) AS guest_number,
        ((n - 1) * 29) % 730 AS check_in_offset,
        1 + (((n - 1) * 7) % 10) AS nights,
        (((n - 1) * 17) + ((n - 1) / 120) * 3) % 10 AS status_number
    FROM generate_series(1, 500) AS numbers(n)
),
prepared AS (
    SELECT
        n,
        property_number,
        guest_number,
        DATE '2024-01-01' + check_in_offset AS check_in,
        nights,
        CASE
            WHEN status_number = 0 THEN 'pending'
            WHEN status_number IN (1, 2) THEN 'cancelled'
            WHEN status_number IN (3, 4, 5) THEN 'confirmed'
            ELSE 'completed'
        END AS status
    FROM generated
)
INSERT INTO bookings (
    property_id,
    guest_id,
    check_in,
    check_out,
    guests_count,
    status,
    total_amount,
    created_at
)
SELECT
    p.id,
    uuid_generate_v5(
        uuid_ns_url(),
        'postgres-training-fake-user-' || prepared.guest_number
    ),
    prepared.check_in,
    prepared.check_in + prepared.nights,
    1 + ((prepared.n - 1) % 2),
    prepared.status,
    p.price_per_night * prepared.nights,
    prepared.check_in::TIMESTAMP
        - (7 + ((prepared.n - 1) % 45)) * INTERVAL '1 day'
FROM prepared
JOIN properties p
    ON p.title = 'Учебное жильё #'
        || lpad(prepared.property_number::text, 3, '0')
   AND p.description = 'Сгенерировано миграцией 00003';

INSERT INTO payments (booking_id, amount, status, paid_at)
SELECT
    b.id,
    b.total_amount,
    CASE WHEN b.status = 'pending' THEN 'pending' ELSE 'succeeded' END,
    CASE
        WHEN b.status = 'pending' THEN NULL
        ELSE b.created_at + INTERVAL '5 minutes'
    END
FROM bookings b
JOIN properties p ON p.id = b.property_id
WHERE p.description = 'Сгенерировано миграцией 00003'
  AND b.status <> 'cancelled';

INSERT INTO reviews (booking_id, rating, comment, created_at)
SELECT
    b.id,
    1 + (b.id % 5),
    (ARRAY[
        'Всё понравилось',
        'Чисто и уютно',
        'Удобное расположение',
        'Хороший хозяин',
        'Приедем ещё раз'
    ])[1 + (b.id % 5)],
    b.check_out::TIMESTAMP + INTERVAL '12 hours'
FROM bookings b
JOIN properties p ON p.id = b.property_id
WHERE p.description = 'Сгенерировано миграцией 00003'
  AND b.status = 'completed';

-- +goose Down

DELETE FROM reviews
WHERE booking_id IN (
    SELECT b.id
    FROM bookings b
    JOIN properties p ON p.id = b.property_id
    WHERE p.description = 'Сгенерировано миграцией 00003'
);

DELETE FROM payments
WHERE booking_id IN (
    SELECT b.id
    FROM bookings b
    JOIN properties p ON p.id = b.property_id
    WHERE p.description = 'Сгенерировано миграцией 00003'
);

DELETE FROM bookings
WHERE property_id IN (
    SELECT id
    FROM properties
    WHERE description = 'Сгенерировано миграцией 00003'
);

DELETE FROM property_amenities
WHERE property_id IN (
    SELECT id
    FROM properties
    WHERE description = 'Сгенерировано миграцией 00003'
);

DELETE FROM properties
WHERE description = 'Сгенерировано миграцией 00003';

DELETE FROM users
WHERE email LIKE 'fake.%@rental.test';
