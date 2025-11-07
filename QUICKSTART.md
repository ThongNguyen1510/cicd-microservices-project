# Quick Start Guide

Get the microservices application running in under 5 minutes!

## Prerequisites

- Docker Desktop (with Kubernetes enabled)
- .NET 8.0 SDK
- Node.js 18+
- Git

## Option 1: Docker Compose (Recommended for Quick Start)

### 1. Clone and Start

```bash
git clone https://github.com/yourusername/cicd-microservices-project.git
cd cicd-microservices-project
docker-compose up -d
```

### 2. Wait for Services

```bash
# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

### 3. Access Application

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:5000
- **API Docs**: http://localhost:5000/swagger

### 4. Test the API

```bash
# Get all products
curl http://localhost:5000/api/products

# Health check
curl http://localhost:5000/api/health
```

### 5. Stop Services

```bash
docker-compose down
```

## Option 2: Local Development

### 1. Setup Script (Windows)

```powershell
.\scripts\setup-local.ps1
```

### 2. Start Backend

```bash
cd backend/src
dotnet run
```

Backend runs at: http://localhost:5000

### 3. Start Frontend (New Terminal)

```bash
cd frontend
npm run dev
```

Frontend runs at: http://localhost:3000

## Option 3: Kubernetes

### 1. Enable Kubernetes in Docker Desktop

Settings → Kubernetes → Enable Kubernetes

### 2. Deploy

```powershell
.\scripts\deploy-k8s.ps1
```

### 3. Access Application

```bash
# Port forward
kubectl port-forward service/frontend-service 8080:80 -n microservices

# Open browser
http://localhost:8080
```

## Verify Installation

### Test Backend API

```bash
# Health check
curl http://localhost:5000/api/health

# Get products
curl http://localhost:5000/api/products

# Create product
curl -X POST http://localhost:5000/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "description": "Test Description",
    "price": 99.99,
    "stockQuantity": 10,
    "category": "Test"
  }'
```

### Test Frontend

1. Open http://localhost:3000
2. Click "Add Product"
3. Fill in the form
4. Click "Create Product"
5. Verify product appears in the list

## Troubleshooting

### Docker Compose Issues

```bash
# View logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs sqlserver

# Restart services
docker-compose restart

# Clean restart
docker-compose down -v
docker-compose up -d
```

### Port Already in Use

```bash
# Windows - Find and kill process
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# Or change ports in docker-compose.yml
```

### Database Connection Failed

```bash
# Check SQL Server
docker logs sqlserver

# Restart SQL Server
docker restart sqlserver

# Wait 30 seconds for SQL Server to start
```

## Next Steps

1. **Explore the API**: http://localhost:5000/swagger
2. **Read Documentation**: See `docs/` folder
3. **Set up CI/CD**: See `docs/deployment-guide.md`
4. **Customize**: Modify code and configurations
5. **Deploy to Cloud**: Follow Kubernetes deployment guide

## Useful Commands

### Docker Compose

```bash
docker-compose up -d          # Start services
docker-compose down           # Stop services
docker-compose ps             # View status
docker-compose logs -f        # View logs
docker-compose restart        # Restart services
```

### Kubernetes

```bash
kubectl get pods -n microservices              # View pods
kubectl get services -n microservices          # View services
kubectl logs -l app=backend -n microservices   # View logs
kubectl delete namespace microservices         # Delete all
```

### Development

```bash
# Backend
cd backend/src
dotnet run                    # Run API
dotnet test                   # Run tests
dotnet build                  # Build

# Frontend
cd frontend
npm run dev                   # Development server
npm run build                 # Production build
npm run test                  # Run tests
npm run lint                  # Lint code
```

## Common Issues

**Issue**: "Cannot connect to Docker daemon"
**Solution**: Start Docker Desktop

**Issue**: "Port 1433 already in use"
**Solution**: Stop existing SQL Server or change port

**Issue**: "npm install fails"
**Solution**: Delete node_modules and package-lock.json, then run npm install

**Issue**: "Database migration fails"
**Solution**: Wait for SQL Server to fully start (30 seconds)

## Getting Help

- Check `docs/deployment-guide.md` for detailed instructions
- Review `docs/architecture.md` for system design
- Open an issue on GitHub
- Check logs for error messages

## Success Indicators

✅ All containers running: `docker-compose ps`
✅ Backend health: `curl http://localhost:5000/api/health`
✅ Frontend loads: http://localhost:3000
✅ Can create/view products in UI
✅ Swagger UI accessible: http://localhost:5000/swagger

---

**You're all set! Start building! 🚀**
