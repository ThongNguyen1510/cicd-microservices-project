# Kubernetes Deployment Script for Windows
# This script deploys the microservices application to Kubernetes

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("dev", "staging", "prod")]
    [string]$Environment = "dev",
    
    [Parameter(Mandatory=$false)]
    [string]$ImageTag = "latest"
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Kubernetes Deployment Script         " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Environment: $Environment" -ForegroundColor Yellow
Write-Host "Image Tag: $ImageTag" -ForegroundColor Yellow
Write-Host ""

# Check if kubectl is installed
if (-not (Get-Command kubectl -ErrorAction SilentlyContinue)) {
    Write-Host "✗ kubectl is not installed. Please install kubectl." -ForegroundColor Red
    exit 1
}

# Check if cluster is accessible
Write-Host "Checking Kubernetes cluster..." -ForegroundColor Yellow
kubectl cluster-info | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "✗ Cannot connect to Kubernetes cluster" -ForegroundColor Red
    exit 1
}
Write-Host "✓ Connected to Kubernetes cluster" -ForegroundColor Green

Write-Host ""
Write-Host "Creating namespace..." -ForegroundColor Yellow
kubectl apply -f k8s/base/namespace.yaml
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Namespace created/updated" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to create namespace" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Deploying database..." -ForegroundColor Yellow
kubectl apply -f k8s/base/database-secret.yaml
kubectl apply -f k8s/base/database-statefulset.yaml

Write-Host "Waiting for database to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=sqlserver -n microservices --timeout=300s
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Database is ready" -ForegroundColor Green
} else {
    Write-Host "✗ Database failed to start" -ForegroundColor Red
    Write-Host "Checking database logs..." -ForegroundColor Yellow
    kubectl logs -l app=sqlserver -n microservices --tail=50
    exit 1
}

Write-Host ""
Write-Host "Deploying backend..." -ForegroundColor Yellow
kubectl apply -f k8s/base/backend-deployment.yaml

Write-Host "Waiting for backend to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=backend -n microservices --timeout=300s
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Backend is ready" -ForegroundColor Green
} else {
    Write-Host "✗ Backend failed to start" -ForegroundColor Red
    Write-Host "Checking backend logs..." -ForegroundColor Yellow
    kubectl logs -l app=backend -n microservices --tail=50
    exit 1
}

Write-Host ""
Write-Host "Deploying frontend..." -ForegroundColor Yellow
kubectl apply -f k8s/base/frontend-deployment.yaml

Write-Host "Waiting for frontend to be ready..." -ForegroundColor Yellow
kubectl wait --for=condition=ready pod -l app=frontend -n microservices --timeout=300s
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Frontend is ready" -ForegroundColor Green
} else {
    Write-Host "✗ Frontend failed to start" -ForegroundColor Red
    Write-Host "Checking frontend logs..." -ForegroundColor Yellow
    kubectl logs -l app=frontend -n microservices --tail=50
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Deployment completed successfully! ✓ " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "Deployment Status:" -ForegroundColor Cyan
kubectl get all -n microservices

Write-Host ""
Write-Host "Services:" -ForegroundColor Cyan
kubectl get services -n microservices

Write-Host ""
Write-Host "To access the application:" -ForegroundColor Yellow
Write-Host "1. Get the frontend service URL:" -ForegroundColor White
Write-Host "   kubectl get service frontend-service -n microservices" -ForegroundColor Gray
Write-Host ""
Write-Host "2. For local access, use port-forward:" -ForegroundColor White
Write-Host "   kubectl port-forward service/frontend-service 8080:80 -n microservices" -ForegroundColor Gray
Write-Host "   Then open: http://localhost:8080" -ForegroundColor Yellow
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "   kubectl get pods -n microservices              - View pods" -ForegroundColor Gray
Write-Host "   kubectl logs -l app=backend -n microservices   - View backend logs" -ForegroundColor Gray
Write-Host "   kubectl logs -l app=frontend -n microservices  - View frontend logs" -ForegroundColor Gray
Write-Host "   kubectl describe pod <pod-name> -n microservices - Pod details" -ForegroundColor Gray
Write-Host "   kubectl delete namespace microservices         - Delete all resources" -ForegroundColor Gray
Write-Host ""
