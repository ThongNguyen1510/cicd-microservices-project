# Demo Script for Interviews

This script helps you demonstrate the CI/CD microservices project effectively during technical interviews or presentations.

## Preparation (Before Demo)

### 1. Environment Setup
```bash
# Start all services
docker-compose up -d

# Verify everything is running
docker-compose ps
```

### 2. Open Required Tabs
- Frontend: http://localhost:3000
- Backend Swagger: http://localhost:5000/swagger
- GitHub Repository
- GitHub Actions (Workflows)
- Kubernetes Dashboard (optional)

## Demo Flow (15-20 minutes)

### Part 1: Project Overview (2 minutes)

**What to say:**
> "I built a production-ready CI/CD pipeline for a microservices application that demonstrates modern DevOps practices. The project includes:
> - A React frontend and .NET Core backend with SQL Server
> - Automated CI/CD with GitHub Actions
> - Docker containerization
> - Kubernetes orchestration
> - Comprehensive testing and security scanning"

**Show:** README.md with architecture diagram

### Part 2: Application Demo (3 minutes)

**Frontend Demo:**
1. Open http://localhost:3000
2. Show the product list
3. Click "Add Product"
4. Create a new product:
   - Name: "Demo Laptop"
   - Description: "High-performance laptop"
   - Price: 1499.99
   - Stock: 25
   - Category: "Electronics"
5. Show the product appears in the list
6. Edit the product
7. Delete a product

**What to say:**
> "This is a full-stack application with CRUD operations. The frontend is built with React and TailwindCSS, communicating with a RESTful API backend."

### Part 3: Backend API (2 minutes)

**Swagger Demo:**
1. Open http://localhost:5000/swagger
2. Show the API endpoints
3. Test GET /api/products
4. Test POST /api/products
5. Show health check endpoints

**What to say:**
> "The backend is a .NET 8 Web API with Entity Framework Core, connected to SQL Server. It includes health checks, structured logging with Serilog, and comprehensive API documentation with Swagger."

### Part 4: Architecture & Code (3 minutes)

**Backend Code:**
```bash
# Show project structure
backend/
├── src/
│   ├── Controllers/      # API endpoints
│   ├── Services/         # Business logic
│   ├── Models/           # Data models
│   └── Data/             # Database context
└── tests/                # Unit tests
```

**Show key files:**
1. `ProductsController.cs` - RESTful API implementation
2. `ProductService.cs` - Business logic with dependency injection
3. `ApplicationDbContext.cs` - EF Core with SQL Server
4. `ProductServiceTests.cs` - Unit tests with xUnit

**Frontend Code:**
```bash
frontend/
├── src/
│   ├── components/       # React components
│   ├── services/         # API integration
│   └── App.jsx           # Main application
```

**What to say:**
> "The code follows SOLID principles with dependency injection, repository pattern, and comprehensive error handling. The frontend uses modern React with hooks and functional components."

### Part 5: Docker & Containerization (3 minutes)

**Show Dockerfiles:**

**Backend Dockerfile:**
```dockerfile
# Multi-stage build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
# Build stage...

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
# Non-root user for security
USER appuser
```

**What to say:**
> "I use multi-stage Docker builds to minimize image size. The backend image is about 200MB instead of 2GB. All containers run as non-root users for security."

**Show docker-compose.yml:**
```bash
docker-compose ps
docker-compose logs backend --tail=20
```

**What to say:**
> "Docker Compose orchestrates all services locally with health checks, proper networking, and volume management for database persistence."

### Part 6: CI/CD Pipeline (5 minutes)

**Show GitHub Actions Workflow:**

Open `.github/workflows/backend-ci-cd.yaml`

**Explain the pipeline stages:**

1. **Build & Test**
   - Restore dependencies
   - Build application
   - Run unit tests
   - Generate code coverage

2. **Security Scanning**
   - OWASP Dependency Check
   - Trivy container scanning
   - Vulnerability reports

3. **Build & Push Docker Image**
   - Multi-stage build
   - Tag with commit SHA
   - Push to GitHub Container Registry
   - Layer caching for speed

4. **Deploy to Kubernetes**
   - Rolling update deployment
   - Health check verification
   - Smoke tests
   - Automatic rollback on failure

**Show workflow run:**
1. Go to Actions tab
2. Show a successful workflow run
3. Explain each step
4. Show test results and security scans

**What to say:**
> "The CI/CD pipeline is fully automated. Every push triggers builds, tests, security scans, and deployment. The pipeline includes:
> - Automated testing with code coverage
> - Security vulnerability scanning with Trivy and OWASP
> - Docker image optimization and caching
> - Zero-downtime deployments to Kubernetes
> - Automatic rollback on failures"

### Part 7: Kubernetes Deployment (3 minutes)

**Show Kubernetes manifests:**

```bash
k8s/base/
├── namespace.yaml
├── database-statefulset.yaml
├── backend-deployment.yaml
└── frontend-deployment.yaml
```

**Key features to highlight:**

1. **Resource Management**
```yaml
resources:
  requests:
    memory: "256Mi"
    cpu: "250m"
  limits:
    memory: "512Mi"
    cpu: "500m"
```

2. **Health Checks**
```yaml
livenessProbe:
  httpGet:
    path: /api/health
readinessProbe:
  httpGet:
    path: /api/health/ready
```

3. **Auto-scaling**
```yaml
minReplicas: 2
maxReplicas: 10
```

**Demo Kubernetes (if available):**
```bash
kubectl get all -n microservices
kubectl get pods -n microservices
kubectl describe pod <backend-pod> -n microservices
kubectl logs -l app=backend -n microservices --tail=20
```

**What to say:**
> "The Kubernetes deployment includes:
> - Horizontal Pod Autoscaling based on CPU/memory
> - Health checks for self-healing
> - Resource limits to prevent resource exhaustion
> - StatefulSet for database with persistent storage
> - LoadBalancer service for external access"

### Part 8: Testing & Quality (2 minutes)

**Show tests:**

```bash
# Backend tests
cd backend
dotnet test

# Frontend tests
cd frontend
npm test
```

**Show test file:**
`backend/tests/Services/ProductServiceTests.cs`

**What to say:**
> "The project includes:
> - Unit tests with xUnit and Moq
> - Integration tests with in-memory database
> - Code coverage reporting
> - Automated testing in CI/CD pipeline
> - All tests must pass before deployment"

### Part 9: Security & Best Practices (2 minutes)

**Security measures:**

1. **Container Security**
   - Non-root user execution
   - Minimal base images (Alpine)
   - Regular vulnerability scanning
   - No secrets in images

2. **Application Security**
   - Input validation
   - SQL injection prevention (EF Core)
   - CORS configuration
   - Health check endpoints

3. **CI/CD Security**
   - Automated security scanning
   - Dependency vulnerability checks
   - Secret management with Kubernetes Secrets
   - Image signing (can be added)

**Show security scan results:**
- Trivy scan output
- OWASP Dependency Check report

**What to say:**
> "Security is built into every layer:
> - Automated vulnerability scanning in CI/CD
> - Container hardening with non-root users
> - Secrets management with Kubernetes
> - Regular dependency updates
> - Security best practices throughout"

## Questions You Might Get

### Q: "Why did you choose these technologies?"

**Answer:**
> "I chose this stack because:
> - .NET Core: High performance, cross-platform, strong typing
> - React: Modern, component-based, large ecosystem
> - SQL Server: Enterprise-grade, excellent .NET integration
> - Kubernetes: Industry standard for container orchestration
> - GitHub Actions: Native GitHub integration, free for public repos"

### Q: "How do you handle database migrations?"

**Answer:**
> "I use Entity Framework Core migrations. The backend automatically applies migrations on startup with retry logic. In production, I'd use a separate migration job in the CI/CD pipeline before deploying the application."

### Q: "How would you scale this application?"

**Answer:**
> "The application is designed for horizontal scaling:
> - Frontend and backend are stateless and can scale independently
> - Kubernetes HPA automatically scales based on CPU/memory
> - Database uses connection pooling
> - For further scaling, I'd add Redis for caching and a message queue for async processing"

### Q: "How do you handle failures?"

**Answer:**
> "Multiple layers of resilience:
> - Kubernetes health checks restart failed containers
> - Rolling updates ensure zero downtime
> - Automatic rollback on deployment failures
> - Database retry logic for transient failures
> - Structured logging for debugging"

### Q: "What would you add for production?"

**Answer:**
> "For production, I'd add:
> - Monitoring with Prometheus and Grafana
> - Log aggregation with ELK/EFK stack
> - Distributed tracing with Jaeger
> - API Gateway for authentication and rate limiting
> - Service mesh (Istio) for advanced traffic management
> - External secret management (HashiCorp Vault)
> - Backup and disaster recovery procedures"

### Q: "How do you ensure code quality?"

**Answer:**
> "Multiple quality gates:
> - Automated testing in CI/CD (unit, integration)
> - Code coverage requirements
> - Linting and code formatting
> - Pull request reviews
> - Security scanning
> - SonarCloud for code quality analysis (optional)"

## Closing Statement

**What to say:**
> "This project demonstrates my understanding of modern DevOps practices including:
> - Microservices architecture
> - Containerization and orchestration
> - CI/CD automation
> - Infrastructure as Code
> - Security best practices
> - Testing and quality assurance
> 
> The entire codebase is well-documented, follows industry standards, and is production-ready. I'm happy to dive deeper into any aspect or answer specific questions."

## Tips for Success

1. **Practice the demo** multiple times
2. **Know your code** - be ready to explain any file
3. **Have the environment running** before the interview
4. **Prepare for deep dives** into any component
5. **Show enthusiasm** about the technologies
6. **Be honest** about what you'd improve
7. **Connect to business value** - faster deployments, reliability, security

## Time Management

- **5 min demo**: Focus on application + CI/CD pipeline
- **10 min demo**: Add architecture and Kubernetes
- **15 min demo**: Include code walkthrough
- **20 min demo**: Add testing and security details

## Backup Plan

If live demo fails:
1. Have screenshots ready
2. Show GitHub Actions workflow runs
3. Walk through code and architecture
4. Explain the concepts even without running demo

---

**Good luck with your demo! 🚀**
