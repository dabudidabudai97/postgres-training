package main

import (
	"context"
	"fmt"
	"net"
	"net/url"
	"projectPG/config"

	"github.com/jackc/pgx/v5/pgxpool"
)

type dataSources struct {
	DB *pgxpool.Pool
}

// postgres://jack:secret@pg.example.com:5432/mydb?sslmode=verify-full&pool_max_conns=10&pool_max_conn_lifetime=1h30m
func initDS() (*dataSources, error) {
	cfg, err := config.Load()
	if err != nil {
		return nil, err
	}

	dbURL := url.URL{
		Scheme: "postgres",
		User:   url.UserPassword(cfg.User, cfg.Password),
		Host:   net.JoinHostPort(cfg.Host, cfg.Port),
		Path:   cfg.NameDB,
	}

	ctx := context.Background()

	dbpool, err := pgxpool.New(ctx, dbURL.String())
	if err != nil {
		return nil, fmt.Errorf("error openning db: %w", err)
	}

	if err := dbpool.Ping(ctx); err != nil {
		return nil, fmt.Errorf("error connecting db: %w", err)
	}

	ds := &dataSources{
		DB: dbpool,
	}

	return ds, nil
}

func (d *dataSources) close() {
	d.DB.Close()
}