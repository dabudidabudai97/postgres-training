# PostgreSQL training

Небольшой Go-сервис для практики работы с PostgreSQL.

Основное учебное задание: [сервис аренды жилья](RENTAL_SQL_TASK.md). В нём есть
готовая схема с 500 сгенерированными бронированиями и 30 независимых карточек с
короткими SQL-упражнениями. Каждую карточку можно выдавать и выполнять отдельно.

Запуск базы и применение Goose-миграций:

```bash
docker compose up --build -d postgres migrate
```

Запуск всего приложения:

```bash
docker compose up --build
```

Проверка состояния миграций:

```bash
docker compose run --rm migrate status
```
