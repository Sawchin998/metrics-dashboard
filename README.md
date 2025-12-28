# Metrics Dashboard

A simple demo project for **Docker and Kubernetes** that displays random system metrics.

This project demonstrates how multiple services work together using Docker Compose and Kubernetes (Minikube).

---

## Architecture

The Metrics Dashboard consists of the following components:

- **PostgreSQL** – Stores generated metrics  
- **Go Worker** – Generates random metrics and saves them to the database  
- **Rails API** – Fetches metrics from PostgreSQL and exposes REST APIs  
- **Angular Frontend** – Displays metrics in the browser  

```
Angular Frontend → Rails API → PostgreSQL
                       ↑
                   Go Worker
```

---

## Prerequisites

### Docker

- Docker
- Docker Compose

### Kubernetes

- Docker
- Minikube
- kubectl

---

## Run with Docker Compose (Local)

This is the fastest way to run the project locally.

### Build and start services

```bash
./scripts/build-and-run.sh
```

This script will:

- Build all Docker images
- Start all services
- Wait for containers to be healthy
- Test API and frontend connectivity
- Show recent logs

### Access the application

- **Frontend:** <http://localhost:9000>  
- **API:** <http://localhost:3000>  
- **Database:** localhost:5432  

### Useful Docker commands

```bash
docker compose logs -f
docker compose down
```

---

## Run on Kubernetes (Minikube)

This setup is intended for Kubernetes demos.

### Deploy to Kubernetes

```bash
./scripts/deploy-kubernetes.sh
```

---

### Update /etc/hosts

```bash
./scripts/update-hosts.sh
```

---

### Access the application

- **Frontend:** <http://metrics-dashboard.local>  
- **API:** <http://metrics-dashboard.local/api>  

---

## Verify Deployment

```bash
./scripts/verify-deployment.sh
```

---

## Cleanup Kubernetes Resources

```bash
./scripts/teardown-kubernetes.sh
```

To completely remove Minikube:

```bash
minikube stop
minikube delete
```
