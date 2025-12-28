#!/bin/bash
# scripts/deploy-kubernetes.sh

set -e

echo "🚀 Deploying Metrics Dashboard to Kubernetes..."

# Start Minikube if not running
echo "🔧 Checking Minikube status..."
if ! minikube status | grep -q "Running"; then
    echo "Starting Minikube..."
    minikube start --cpus=4 --memory=8192 --driver=docker
fi

# Enable ingress addon
echo "🔧 Enabling ingress..."
minikube addons enable ingress

# Set up Docker environment to use Minikube's Docker daemon
echo "🔧 Setting up Docker environment..."
eval $(minikube docker-env)

# Build Docker images
echo "📦 Building Docker images inside Minikube..."
docker build -t metrics-dashboard-go-worker:latest ./go-worker
docker build -t metrics-dashboard-rails-api:latest ./rails-api
docker build -t metrics-dashboard-angular-frontend:latest ./angular-frontend

# Create namespace
echo "📁 Creating namespace..."
kubectl apply -f kubernetes/namespace.yaml

# Create ConfigMap and Secrets
echo "🔐 Creating ConfigMap and Secrets..."
kubectl apply -f kubernetes/configmap.yaml
kubectl apply -f kubernetes/secret.yaml

# Wait a moment for namespace to be ready
sleep 2

# Deploy PostgreSQL
echo "🗄️ Deploying PostgreSQL..."
kubectl apply -f kubernetes/postgres/

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n metrics-dashboard --timeout=180s

# Deploy Go Worker
echo "⚙️ Deploying Go Worker..."
kubectl apply -f kubernetes/go-worker/

# Deploy Rails API
echo "🔗 Deploying Rails API..."
kubectl apply -f kubernetes/rails-api/

# Deploy Angular Frontend
echo "🌐 Deploying Angular Frontend..."
kubectl apply -f kubernetes/angular-frontend/

# Deploy Ingress
echo "🚪 Deploying Ingress..."
kubectl apply -f kubernetes/ingress/

# Wait for all pods to be ready
echo "⏳ Waiting for all pods to be ready..."
kubectl wait --for=condition=ready pod -l app=rails-api -n metrics-dashboard --timeout=180s
kubectl wait --for=condition=ready pod -l app=angular-frontend -n metrics-dashboard --timeout=180s

# Get Minikube IP
MINIKUBE_IP=$(minikube ip)
echo "🎉 Deployment completed!"
echo ""
echo "📊 Access your application:"
echo "   Frontend: http://metrics-dashboard.local"
echo "   API: http://metrics-dashboard.local/api"
echo ""
echo "🔧 To access the application, add this to your /etc/hosts:"
echo "   $MINIKUBE_IP metrics-dashboard.local"
echo ""
echo "📋 Useful commands:"
echo "   kubectl get all -n metrics-dashboard"
echo "   kubectl logs -f deployment/go-worker -n metrics-dashboard"
echo "   minikube service list"
echo ""
echo "🔄 To update images after changes:"
echo "   kubectl rollout restart deployment/go-worker -n metrics-dashboard"
echo "   kubectl rollout restart deployment/rails-api -n metrics-dashboard"
echo "   kubectl rollout restart deployment/angular-frontend -n metrics-dashboard"
