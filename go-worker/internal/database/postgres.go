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
	defaultUser := "metrics_user"
	defaultPassword := "password"
	defaultHost := "localhost"
	defaultPort := "5432"
	defaultDBName := "metrics_db"
	defaultSSLMode := "disable"

	// Read each part from environment, fall back to default if missing
	dbUser := os.Getenv("DB_USER")
	if dbUser == "" {
			dbUser = defaultUser
	}

	dbPassword := os.Getenv("DB_PASSWORD")
	if dbPassword == "" {
			dbPassword = defaultPassword
	}

	dbHost := os.Getenv("DB_HOST")
	if dbHost == "" {
			dbHost = defaultHost
	}

	dbPort := os.Getenv("DB_PORT")
	if dbPort == "" {
			dbPort = defaultPort
	}

	dbName := os.Getenv("DB_NAME")
	if dbName == "" {
			dbName = defaultDBName
	}

	dbSSLMode := os.Getenv("DB_SSLMODE")
	if dbSSLMode == "" {
			dbSSLMode = defaultSSLMode
	}

	// Build final connection string
	connStr := fmt.Sprintf(
			"postgres://%s:%s@%s:%s/%s?sslmode=%s",
			dbUser,
			dbPassword,
			dbHost,
			dbPort,
			dbName,
			dbSSLMode,
	)

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
