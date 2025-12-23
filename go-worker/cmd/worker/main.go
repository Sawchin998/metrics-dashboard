// cmd/worker/main.go
package main

import (
	"log"
	"math/rand"
	"os"
	"strconv"
	"time"

	"metrics-dashboard/go-worker/internal/database"
	"metrics-dashboard/go-worker/internal/generator"
)

func main() {
	// Initialize random seed for generating random numbers
	rand.Seed(time.Now().UnixNano())
	
	log.Println("Starting Metrics Generator Worker...")
	
	// Connect to PostgreSQL database
	db, err := database.Connect()
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()
	
	// Create metrics generator
	metricsGen := generator.NewMetricsGenerator(db)
	
	workerIntervalStr := os.Getenv("WORKER_INTERVAL")
	if workerIntervalStr == "" {
			workerIntervalStr = "10" // default 10 seconds
	}

	// Convert string to int
	workerIntervalInt, err := strconv.Atoi(workerIntervalStr)
	if err != nil {
			log.Fatalf("WORKER_INTERVAL is invalid: %v", err)
	}
	ticker := time.NewTicker(time.Duration(workerIntervalInt) * time.Second)
	defer ticker.Stop()
	
	log.Println("Worker started. Generating metrics every 10 seconds...")
	
	// Infinite loop that runs every 10 seconds
	for range ticker.C {
		err := metricsGen.GenerateMetric()
		if err != nil {
			log.Printf("Error generating metric: %v", err)
		} else {
			log.Println("Successfully generated new metric")
		}
	}
}
