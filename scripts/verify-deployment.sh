#!/bin/bash
# scripts/verify-deployment.sh

echo "🔍 Verifying Kubernetes deployment..."

echo "1. Checking namespace..."
kubectl get ns metrics-dashboard

echo ""
echo "2. Checking pods..."
kubectl get pods -n metrics-dashboard

echo ""
echo "3. Checking services..."
kubectl get services -n metrics-dashboard

echo ""
echo "4. Checking ingress..."
kubectl get ingress -n metrics-dashboard

echo ""
echo "5. Checking pod status in detail..."
kubectl describe pods -n metrics-dashboard -l app=postgres
kubectl describe pods -n metrics-dashboard -l app=go-worker
kubectl describe pods -n metrics-dashboard -l app=rails-api
kubectl describe pods -n metrics-dashboard -l app=angular-frontend

echo ""
echo "6. Checking logs..."
echo "=== Go Worker Logs ==="
kubectl logs -n metrics-dashboard -l app=go-worker --tail=5

echo ""
echo "=== Rails API Logs ==="
kubectl logs -n metrics-dashboard -l app=rails-api --tail=5

echo ""
echo "=== Angular Frontend Logs ==="
kubectl logs -n metrics-dashboard -l app=angular-frontend --tail=5

echo ""
echo "7. Testing connectivity..."
# Port forward to test API
kubectl port-forward -n metrics-dashboard service/rails-api-service 3000:80 &
PORT_FORWARD_PID=$!
sleep 3

echo "Testing API health endpoint..."
curl -s http://localhost:3000/api/health || echo "API health check failed"

# Kill port forward
kill $PORT_FORWARD_PID

echo ""
echo "✅ Verification complete!"
