#!/bin/bash
# scripts/build-and-run.sh

set -e

echo "🚀 Building and starting Metrics Dashboard..."

# Build Docker images
echo "📦 Building Docker images..."
docker compose build

# Start services
echo "🔧 Starting services..."
docker compose up -d

# Wait for services to be healthy
echo "⏳ Waiting for services to be ready..."
sleep 30

# Check service status
echo "🔍 Checking service status..."
docker compose ps

# Test API connectivity
echo "🧪 Testing API connectivity..."
curl -f http://localhost:3000/api/health || echo "API health check failed"
curl -f http://localhost:9000/health || echo "Frontend health check failed"

# Show logs
echo "📋 Showing recent logs..."
docker compose logs --tail=20

echo "✅ Metrics Dashboard is running!"
echo "🌐 Frontend: http://localhost:9000"
echo "🔗 API: http://localhost:3000"
echo "🗄️  Database: localhost:5432"
echo ""
echo "To view logs: docker compose logs -f"
echo "To stop: docker compose down"
