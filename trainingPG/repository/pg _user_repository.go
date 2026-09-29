package repository

import (
	"context"
	"projectPG/model"

	"github.com/jackc/pgx/v5/pgxpool"
)

type pgUserRepository struct {
	DB *pgxpool.Pool
}

func NewUserRepository(db *pgxpool.Pool) model.UserRepository {
	return &pgUserRepository{
		DB: db,
	}
}

func (d *pgUserRepository) List(ctx context.Context) ([]model.User, error) {
	users := []model.User{}

	query := "SELECT * FROM users;"

	rows, err := d.DB.Query(ctx, query)
	if err != nil {
		return nil, err
	}

	defer rows.Close()

	for rows.Next() {
		var u model.User
		if err := rows.Scan(&u.UID, &u.Name, &u.Email, &u.Created); err != nil {
			return nil, err
		}

		users = append(users, u)
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return users, nil
}

func (d *pgUserRepository) Create(ctx context.Context, name, email string) (*model.User, error) {
	query := "INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *"

	rows, err := d.DB.Query(ctx, query, name, email)
	if err != nil {
		return nil, err
	}

	defer rows.Close()

	user := &model.User{}

	for rows.Next() {
		if err := rows.Scan(&user.UID, &user.Name, &user.Email, &user.Created); err != nil {
			return nil, err
		}
	}

	if err := rows.Err(); err != nil {
		return nil, err
	}

	return user, nil
}
