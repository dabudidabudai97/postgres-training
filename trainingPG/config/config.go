package config

import (
	"fmt"
	"os"
)

type ConfigPG struct {
	User     string
	Password string
	Host     string
	Port     string
	NameDB   string
}

func Load() (ConfigPG, error) {
	config := ConfigPG{
		User:     os.Getenv("PG_USER"),
		Password: os.Getenv("PG_PASSWORD"),
		Host:     os.Getenv("PG_HOST"),
		Port:     os.Getenv("PG_PORT"),
		NameDB:   os.Getenv("PG_NAME"),
	}

	if config.User == "" {
		return ConfigPG{}, fmt.Errorf("PG_USER is required")
	}

	if config.Port == "" {
		return ConfigPG{}, fmt.Errorf("PG_PORT is required")
	}

	if config.Host == "" {
		return ConfigPG{}, fmt.Errorf("PG_HOST is required")
	}

	if config.NameDB == "" {
		return ConfigPG{}, fmt.Errorf("PG_NAME is required")
	}

	return config, nil
}
