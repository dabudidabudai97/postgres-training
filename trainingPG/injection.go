package main

import (
	"log"
	"net/http"
	"projectPG/handler"
	"projectPG/repository"
	"projectPG/service"
)

func inject(d *dataSources) (*http.ServeMux, error) {
	log.Printf("Injecting data sources")

	userRepository := repository.NewUserRepository(d.DB)

	userService := service.NewUserService(&service.USConfig{
		UserRepository: userRepository,
	})

	mux := http.NewServeMux()

	handler.NewHandler(&handler.Config{
		Mux:         mux,
		UserService: userService,
	})

	return mux, nil
}
