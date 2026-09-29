package model

import (
	"context"
)

type UserService interface {
	List(ctx context.Context) ([]User, error)
	Create(ctx context.Context, name, email string) (*User, error)
}

type UserRepository interface {
	List(ctx context.Context) ([]User, error)
	Create(ctx context.Context, name, email string) (*User, error)
}
