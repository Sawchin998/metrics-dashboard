// internal/database/postgres.go
package database

import (
	"database/sql"
	"fmt"
	"log"
	"os"
	
	_ "github.com/lib/pq" // PostgreSQL driver
)

// Connect establishes connection to PostgreSQL
func Connect() (*sql.DB, error) {
	// Get database connection string from environment variables
	connStr := os.Getenv("DATABASE_URL")
	if connStr == "" {
		// Default connection string for development
		connStr = "postgres://metrics_user:password@localhost:5432/metrics_db?sslmode=disable"
	}
	
	// Open database connection
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return nil, fmt.Errorf("failed to open database: %v", err)
	}
	
	// Actually verify the connection works
	err = db.Ping()
	if err != nil {
		return nil, fmt.Errorf("failed to ping database: %v", err)
	}
	
	log.Println("Successfully connected to PostgreSQL database")
	return db, nil
}
