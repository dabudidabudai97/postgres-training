package model

import (
	"time"

	"github.com/google/uuid"
)

type User struct {
	UID      uuid.UUID `json:"id"`
	Name    string    `json:"name"`
	Email   string    `json:"email"`
	Created time.Time `json:"created_at"`
}
