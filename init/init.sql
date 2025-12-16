

-- Create metrics table to store our time-series data
CREATE TABLE IF NOT EXISTS metrics (
    id SERIAL PRIMARY KEY,
    value INTEGER NOT NULL,
    category VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT NOW()
);

-- Create index on category for faster filtering
CREATE INDEX IF NOT EXISTS idx_metrics_category ON metrics(category);

-- Create index on timestamp for time-range queries
CREATE INDEX IF NOT EXISTS idx_metrics_timestamp ON metrics(timestamp);

-- Insert some initial data for demonstration
INSERT INTO metrics (value, category, timestamp) VALUES
(72, 'temperature', NOW() - INTERVAL '5 minutes'),
(45, 'sales', NOW() - INTERVAL '4 minutes'),
(58, 'users', NOW() - INTERVAL '3 minutes'),
(65, 'revenue', NOW() - INTERVAL '2 minutes'),
(68, 'temperature', NOW() - INTERVAL '1 minute');
