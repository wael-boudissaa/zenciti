package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/rs/cors"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var db *gorm.DB

type Table struct {
	ID       uint    `json:"id" gorm:"primaryKey"`
	Name     string  `json:"name"`
	X        float64 `json:"x"`
	Y        float64 `json:"y"`
	Width    float64 `json:"width"`
	Height   float64 `json:"height"`
	Shape    string  `json:"shape"` // SVG Path or Type
	Reserved bool    `json:"reserved"`
}

func initDB() {
	dsn := "root:Waelbvbusmh007.@tcp(localhost:3306)/restaurant?charset=utf8mb4&parseTime=True&loc=Local"
	var err error
	db, err = gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal("failed to connect to database:", err)
	}
	fmt.Println("Database connected successfully!")

	db.AutoMigrate(&Table{})
}

func getTables(w http.ResponseWriter, r *http.Request) {
	var tables []Table
	db.Find(&tables)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(tables)
}

func updateTable(w http.ResponseWriter, r *http.Request) {
	var table Table
	err := json.NewDecoder(r.Body).Decode(&table)
	if err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}
	db.Save(&table)
	w.WriteHeader(http.StatusOK)
}

func updateTables(w http.ResponseWriter, r *http.Request) {
	var tables []Table
	err := json.NewDecoder(r.Body).Decode(&tables)
	if err != nil {
		http.Error(w, "Invalid request payload", http.StatusBadRequest)
		return
	}

	for _, table := range tables {
		db.Model(&Table{}).Where("id = ?", table.ID).Updates(table)
	}

	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(map[string]string{"message": "Tables updated successfully"})
}

func main() {
	initDB()
	router := mux.NewRouter()
	router.HandleFunc("/tables", getTables).Methods("GET")
	router.HandleFunc("/update-table", updateTable).Methods("POST")
	router.HandleFunc("/update-tables", updateTables).Methods("POST") // New endpoint

	// Enable CORS
	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"*"}, // Allow any origin
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE"},
		AllowedHeaders:   []string{"Content-Type"},
		AllowCredentials: true,
	})

	handler := c.Handler(router)
	fmt.Println("Server running on :8080")
	log.Fatal(http.ListenAndServe(":8080", handler))
}
