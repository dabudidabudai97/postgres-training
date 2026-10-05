# SQL-задачи: сервис аренды жилья

Каждая задача вынесена в отдельный Markdown-файл и выполняется независимо от
остальных. Можно выдать одну карточку, не показывая ученику весь набор.

Все задачи используют данные из Goose-миграций в `trainingPG/migrations`.
Миграция `00003_seed_500_fake_bookings.sql` создаёт ровно 500 дополнительных
бронирований вместе со связанными пользователями, жильём, платежами и отзывами.
Задачи на изменение данных требуют `ROLLBACK`, поэтому не влияют на последующие
упражнения.

## Запуск базы

```bash
docker compose up --build -d postgres migrate
docker compose exec postgres psql -U training_user -d training_db
```

Проверить, какие миграции применены:

```bash
docker compose run --rm migrate status
```

После всех миграций в базе будет 106 пользователей, 3 города, 127 объектов
жилья, 511 бронирований, 408 платежей и 206 отзывов. Из 511 броней ровно 500
созданы генератором, остальные 11 нужны как небольшой читаемый пример.

## Простые выборки

1. [Список пользователей](tasks/01-list-users.md)
2. [Активное жильё](tasks/02-active-properties.md)
3. [Недорогое жильё](tasks/03-affordable-properties.md)
4. [Жильё для большой компании](tasks/04-large-properties.md)
5. [Неактивные объявления](tasks/05-inactive-properties.md)
6. [Самое дорогое жильё](tasks/06-most-expensive.md)
7. [Завершённые бронирования](tasks/07-completed-bookings.md)
8. [Бронирования за июнь](tasks/08-june-bookings.md)
9. [Статусы бронирований](tasks/09-booking-statuses.md)
10. [Количество ночей](tasks/10-booking-nights.md)

## Агрегаты

11. [Количество объектов](tasks/11-property-count.md)
12. [Количество активных объектов](tasks/12-active-property-count.md)
13. [Статистика цен](tasks/13-price-statistics.md)
14. [Бронирования по статусам](tasks/14-bookings-by-status.md)
15. [Доход завершённых броней](tasks/15-completed-revenue.md)
16. [Брони по объектам](tasks/16-bookings-by-property.md)
17. [Часто бронируемое жильё](tasks/17-frequently-booked-properties.md)

## JOIN

18. [Жильё и города](tasks/18-properties-with-city.md)
19. [Жильё и владельцы](tasks/19-properties-with-owner.md)
20. [Брони и гости](tasks/20-bookings-with-guest.md)
21. [Подробности завершённых броней](tasks/21-completed-booking-details.md)
22. [Удобства в жилье](tasks/22-property-amenities.md)
23. [Рейтинг жилья](tasks/23-property-rating.md)
24. [Жильё без бронирований](tasks/24-properties-without-bookings.md)
25. [Брони конкретного пользователя](tasks/25-user-bookings.md)
26. [Пользователи без броней](tasks/26-users-without-bookings.md)

## Изменение данных

27. [Добавление пользователя](tasks/27-insert-user.md)
28. [Изменение цены](tasks/28-update-price.md)
29. [Добавление брони](tasks/29-insert-booking.md)
30. [Удаление отменённых броней](tasks/30-delete-cancelled-bookings.md)
