#!/bin/bash
# scripts/teardown-kubernetes.sh

echo "🧹 Cleaning up Kubernetes deployment..."

# Delete all resources in the namespace
kubectl delete -f kubernetes/ingress/
kubectl delete -f kubernetes/angular-frontend/
kubectl delete -f kubernetes/rails-api/
kubectl delete -f kubernetes/go-worker/
kubectl delete -f kubernetes/postgres/
kubectl delete -f kubernetes/secret.yaml
kubectl delete -f kubernetes/configmap.yaml
kubectl delete -f kubernetes/namespace.yaml

echo "✅ Cleanup completed!"
echo ""
echo "To completely remove Minikube:"
echo "  minikube stop"
echo "  minikube delete"
