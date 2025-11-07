# Deployment Guide

This guide provides step-by-step instructions for deploying the microservices application to various environments.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Local Development Setup](#local-development-setup)
3. [Docker Compose Deployment](#docker-compose-deployment)
4. [Kubernetes Deployment](#kubernetes-deployment)
5. [CI/CD Setup](#cicd-setup)
6. [Environment Configuration](#environment-configuration)
7. [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

- **Docker Desktop** (with Kubernetes enabled)
  - Version: 20.10+
  - Download: https://www.docker.com/products/docker-desktop

- **.NET SDK** (for local development)
  - Version: 8.0
  - Download: https://dotnet.microsoft.com/download

- **Node.js and npm** (for local development)
  - Version: 18+
  - Download: https://nodejs.org/

- **kubectl** (Kubernetes CLI)
  - Version: 1.25+
  - Install: https://kubernetes.io/docs/tasks/tools/

- **Git**
  - Version: 2.30+
  - Download: https://git-scm.com/

### Optional Tools

- **k9s** - Terminal UI for Kubernetes
- **Lens** - Kubernetes IDE
- **Postman** - API testing

## Local Development Setup

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/cicd-microservices-project.git
cd cicd-microservices-project
```

### 2. Start SQL Server

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" \
  -p 1433:1433 --name sqlserver -d \
  mcr.microsoft.com/mssql/server:2022-latest
```

### 3. Run Backend API

```bash
cd backend/src
dotnet restore
dotnet run
```

The API will be available at `http://localhost:5000`
Swagger UI: `http://localhost:5000`

### 4. Run Frontend

```bash
cd frontend
npm install
npm run dev
```

The frontend will be available at `http://localhost:3000`

### 5. Verify Setup

- Open browser: `http://localhost:3000`
- Check API health: `http://localhost:5000/api/health`
- View API docs: `http://localhost:5000/swagger`

## Docker Compose Deployment

### 1. Create docker-compose.yml

```yaml
version: '3.8'

services:
  sqlserver:
    image: mcr.microsoft.com/mssql/server:2022-latest
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=YourStrong@Passw0rd
    ports:
      - "1433:1433"
    volumes:
      - sqlserver-data:/var/opt/mssql

  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ConnectionStrings__DefaultConnection=Server=sqlserver;Database=ProductDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True
    ports:
      - "5000:80"
    depends_on:
      - sqlserver

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:80"
    depends_on:
      - backend

volumes:
  sqlserver-data:
```

### 2. Start Services

```bash
docker-compose up -d
```

### 3. Verify Deployment

```bash
docker-compose ps
curl http://localhost:5000/api/health
curl http://localhost:3000
```

### 4. View Logs

```bash
docker-compose logs -f backend
docker-compose logs -f frontend
```

### 5. Stop Services

```bash
docker-compose down
```

## Kubernetes Deployment

### 1. Enable Kubernetes in Docker Desktop

1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"

### 2. Verify Kubernetes Cluster

```bash
kubectl cluster-info
kubectl get nodes
```

### 3. Build and Push Docker Images

```bash
# Build backend
docker build -t yourusername/product-api:latest ./backend
docker push yourusername/product-api:latest

# Build frontend
docker build -t yourusername/product-frontend:latest ./frontend
docker push yourusername/product-frontend:latest
```

**Note:** Replace `yourusername` with your Docker Hub or GitHub Container Registry username.

### 4. Update Image References

Edit `k8s/base/backend-deployment.yaml` and `k8s/base/frontend-deployment.yaml`:

```yaml
image: yourusername/product-api:latest  # Update this
```

### 5. Deploy to Kubernetes

```bash
# Create namespace
kubectl apply -f k8s/base/namespace.yaml

# Deploy database
kubectl apply -f k8s/base/database-secret.yaml
kubectl apply -f k8s/base/database-statefulset.yaml

# Wait for database to be ready
kubectl wait --for=condition=ready pod -l app=sqlserver -n microservices --timeout=300s

# Deploy backend
kubectl apply -f k8s/base/backend-deployment.yaml

# Wait for backend to be ready
kubectl wait --for=condition=ready pod -l app=backend -n microservices --timeout=300s

# Deploy frontend
kubectl apply -f k8s/base/frontend-deployment.yaml
```

### 6. Verify Deployment

```bash
# Check all resources
kubectl get all -n microservices

# Check pods
kubectl get pods -n microservices

# Check services
kubectl get services -n microservices

# Check logs
kubectl logs -l app=backend -n microservices --tail=50
kubectl logs -l app=frontend -n microservices --tail=50
```

### 7. Access the Application

```bash
# Get frontend service URL
kubectl get service frontend-service -n microservices

# For LoadBalancer (cloud)
# Access via EXTERNAL-IP

# For local development (port-forward)
kubectl port-forward service/frontend-service 8080:80 -n microservices
```

Open browser: `http://localhost:8080`

### 8. Monitor Deployments

```bash
# Watch pods
kubectl get pods -n microservices -w

# Describe pod
kubectl describe pod <pod-name> -n microservices

# Get pod logs
kubectl logs <pod-name> -n microservices -f

# Execute commands in pod
kubectl exec -it <pod-name> -n microservices -- /bin/sh
```

## CI/CD Setup

### 1. Fork the Repository

Fork the repository to your GitHub account.

### 2. Configure GitHub Secrets

Go to repository Settings → Secrets and variables → Actions

Add the following secrets:

- `KUBE_CONFIG`: Base64 encoded kubeconfig file
  ```bash
  cat ~/.kube/config | base64
  ```

- `SONAR_TOKEN`: SonarCloud token (optional)

### 3. Enable GitHub Actions

1. Go to repository Actions tab
2. Enable workflows
3. Workflows will trigger on push/PR

### 4. Configure Container Registry

The workflows use GitHub Container Registry (ghcr.io) by default.

To use Docker Hub:
1. Add `DOCKER_USERNAME` and `DOCKER_PASSWORD` secrets
2. Update workflow files to use Docker Hub

### 5. Trigger Deployment

```bash
# Push to main branch (production)
git push origin main

# Push to develop branch (staging)
git push origin develop

# Manual deployment
# Go to Actions → Select workflow → Run workflow
```

### 6. Monitor Pipeline

1. Go to repository Actions tab
2. Click on running workflow
3. View logs and status

## Environment Configuration

### Development Environment

**Backend (`appsettings.Development.json`):**
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=ProductDb;User Id=sa;Password=YourStrong@Passw0rd;TrustServerCertificate=True"
  }
}
```

**Frontend (`.env.development`):**
```
VITE_API_URL=http://localhost:5000
```

### Production Environment

**Backend (Kubernetes ConfigMap):**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backend-config
  namespace: microservices
data:
  ASPNETCORE_ENVIRONMENT: "Production"
```

**Frontend (Build time):**
```
VITE_API_URL=http://backend-service
```

## Scaling

### Manual Scaling

```bash
# Scale backend
kubectl scale deployment backend --replicas=5 -n microservices

# Scale frontend
kubectl scale deployment frontend --replicas=3 -n microservices
```

### Auto-scaling

HPA is already configured. Verify:

```bash
kubectl get hpa -n microservices
```

## Updates and Rollbacks

### Rolling Update

```bash
# Update image
kubectl set image deployment/backend backend=yourusername/product-api:v2 -n microservices

# Check rollout status
kubectl rollout status deployment/backend -n microservices
```

### Rollback

```bash
# Rollback to previous version
kubectl rollout undo deployment/backend -n microservices

# Rollback to specific revision
kubectl rollout undo deployment/backend --to-revision=2 -n microservices

# Check rollout history
kubectl rollout history deployment/backend -n microservices
```

## Troubleshooting

### Pod Not Starting

```bash
# Check pod status
kubectl get pods -n microservices

# Describe pod
kubectl describe pod <pod-name> -n microservices

# Check logs
kubectl logs <pod-name> -n microservices

# Check events
kubectl get events -n microservices --sort-by='.lastTimestamp'
```

### Database Connection Issues

```bash
# Check SQL Server pod
kubectl get pods -l app=sqlserver -n microservices

# Check SQL Server logs
kubectl logs -l app=sqlserver -n microservices

# Test connection from backend pod
kubectl exec -it <backend-pod> -n microservices -- /bin/sh
# Inside pod:
# curl sqlserver-service:1433
```

### Image Pull Errors

```bash
# Check image pull secrets
kubectl get secrets -n microservices

# Create image pull secret (if using private registry)
kubectl create secret docker-registry regcred \
  --docker-server=ghcr.io \
  --docker-username=<username> \
  --docker-password=<token> \
  -n microservices
```

### Service Not Accessible

```bash
# Check service
kubectl get service -n microservices

# Check endpoints
kubectl get endpoints -n microservices

# Port forward for testing
kubectl port-forward service/backend-service 5000:80 -n microservices
```

### High Resource Usage

```bash
# Check resource usage
kubectl top pods -n microservices
kubectl top nodes

# Check resource limits
kubectl describe pod <pod-name> -n microservices | grep -A 5 "Limits"
```

## Cleanup

### Remove Kubernetes Deployment

```bash
# Delete all resources in namespace
kubectl delete namespace microservices

# Or delete individual resources
kubectl delete -f k8s/base/
```

### Remove Docker Containers

```bash
docker-compose down -v
docker system prune -a
```

### Remove Local Database

```bash
docker rm -f sqlserver
docker volume rm sqlserver-data
```

## Best Practices

1. **Always use version tags** for Docker images in production
2. **Never commit secrets** to version control
3. **Use resource limits** to prevent resource exhaustion
4. **Implement health checks** for all services
5. **Monitor logs and metrics** regularly
6. **Test in staging** before production deployment
7. **Have a rollback plan** for every deployment
8. **Document changes** in commit messages
9. **Use GitOps** for infrastructure management
10. **Regular backups** of database and configurations

## Additional Resources

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [.NET Documentation](https://docs.microsoft.com/en-us/dotnet/)
- [React Documentation](https://react.dev/)

## Support

For issues or questions:
1. Check the [Troubleshooting](#troubleshooting) section
2. Review logs and events
3. Open an issue in the GitHub repository
4. Consult the architecture documentation

---

**Happy Deploying! 🚀**
