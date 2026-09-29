package service

import (
	"context"
	"projectPG/model"
)

type userService struct {
	UserRepository model.UserRepository
}

type USConfig struct {
	UserRepository model.UserRepository
}

func NewUserService(c *USConfig) model.UserService {
	return &userService{
		UserRepository: c.UserRepository,
	}
}

func (s *userService) List(ctx context.Context) ([]model.User, error) {
	users, err := s.UserRepository.List(ctx)

	if err != nil {
		return nil, err
	}

	return users, nil
}

func (s *userService) Create(ctx context.Context, name, email string) (*model.User, error) {
	user, err := s.UserRepository.Create(ctx, name, email)

	if err != nil {
		return nil, err
	}

	return user, nil
}
