// internal/generator/metrics.go
package generator

import (
	"database/sql"
	"fmt"
	"math/rand"
	"time"
)

// Metric represents a single data point in our time series
type Metric struct {
	Value     int       `json:"value"`
	Category  string    `json:"category"`
	Timestamp time.Time `json:"timestamp"`
}

// MetricsGenerator handles creating and storing random metrics
type MetricsGenerator struct {
	db *sql.DB
}

// NewMetricsGenerator creates a new metrics generator
func NewMetricsGenerator(db *sql.DB) *MetricsGenerator {
	return &MetricsGenerator{db: db}
}

// Available categories for our metrics
var categories = []string{"temperature", "sales", "users", "revenue"}

// GenerateMetric creates and stores one random metric
func (mg *MetricsGenerator) GenerateMetric() error {
	// Create a new metric with random values
	metric := Metric{
		Value:     rand.Intn(100) + 1, // Random number between 1-100
		Category:  categories[rand.Intn(len(categories))], // Random category
		Timestamp: time.Now(), // Current time
	}
	
	// Store the metric in PostgreSQL
	query := `INSERT INTO metrics (value, category, timestamp) VALUES ($1, $2, $3)`
	_, err := mg.db.Exec(query, metric.Value, metric.Category, metric.Timestamp)
	if err != nil {
		return fmt.Errorf("failed to insert metric: %v", err)
	}
	
	return nil
}
