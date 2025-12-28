#!/bin/bash
# scripts/update-hosts.sh

echo "🌐 Updating /etc/hosts for Minikube access..."

MINIKUBE_IP=$(minikube ip)
HOSTS_ENTRY="$MINIKUBE_IP metrics-dashboard.local"

# Check if entry already exists
if grep -q "metrics-dashboard.local" /etc/hosts; then
    echo "Updating existing hosts entry..."
    sudo sed -i.bak "s/.*metrics-dashboard.local/$HOSTS_ENTRY/" /etc/hosts
else
    echo "Adding new hosts entry..."
    echo "$HOSTS_ENTRY" | sudo tee -a /etc/hosts
fi

echo "✅ Updated /etc/hosts:"
grep "metrics-dashboard.local" /etc/hosts

echo ""
echo "🎯 You can now access:"
echo "   Frontend: http://metrics-dashboard.local"
echo "   API: http://metrics-dashboard.local/api"
