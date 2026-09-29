package handler

import (
	"encoding/json"
	"log"
	"net/http"
	"projectPG/model"
)

type Handler struct {
	UserService model.UserService
}

type Config struct {
	Mux         *http.ServeMux
	UserService model.UserService
}

type createReq struct {
	Name  string `json:"name"`
	Email string `json:"email"`
}

func NewHandler(c *Config) {
	h := &Handler{
		UserService: c.UserService,
	}

	c.Mux.HandleFunc("GET /list", h.listHandler)
	c.Mux.HandleFunc("POST /create", h.createHandler)
}

func (h *Handler) listHandler(w http.ResponseWriter, r *http.Request) {
	users, err := h.UserService.List(r.Context())
	if err != nil {
		http.Error(w, "failed get users", http.StatusNotFound)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)

	json.NewEncoder(w).Encode(users)
}

func (h *Handler) createHandler(w http.ResponseWriter, r *http.Request) {
	var req createReq

	err := json.NewDecoder(r.Body).Decode(&req)
	if err != nil {
		http.Error(w, "Invalid request body", http.StatusBadRequest)
		return
	}

	user, err := h.UserService.Create(r.Context(), req.Name, req.Email)
	if err != nil {
		http.Error(w, "Failed create in Postgres", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)

	err = json.NewEncoder(w).Encode(user)
	if err != nil {
		log.Println("failed to encode created product: %w", err)
	}
}
