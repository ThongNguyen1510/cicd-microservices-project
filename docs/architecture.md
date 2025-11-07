# Architecture Documentation

## System Overview

This project implements a modern microservices architecture demonstrating DevOps best practices with automated CI/CD pipelines, containerization, and orchestration.

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub Actions                           │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Build      │  │   Test       │  │   Security   │          │
│  │   & Lint     │→ │   & Coverage │→ │   Scanning   │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
│                           ↓                                      │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐          │
│  │   Docker     │  │   Push to    │  │   Deploy to  │          │
│  │   Build      │→ │   Registry   │→ │   K8s        │          │
│  └──────────────┘  └──────────────┘  └──────────────┘          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                            │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                    Ingress Controller                   │    │
│  └────────────────────────────────────────────────────────┘    │
│                              ↓                                   │
│  ┌──────────────────────┐         ┌──────────────────────┐     │
│  │   Frontend Service   │         │   Backend Service    │     │
│  │   (React + Nginx)    │────────→│   (.NET Core API)    │     │
│  │   Port: 80           │         │   Port: 80           │     │
│  │   Replicas: 2-10     │         │   Replicas: 2-10     │     │
│  └──────────────────────┘         └──────────────────────┘     │
│           ↑                                    ↓                 │
│           │                        ┌──────────────────────┐     │
│           │                        │   SQL Server         │     │
│           │                        │   StatefulSet        │     │
│           │                        │   Port: 1433         │     │
│           │                        │   Persistent Volume  │     │
│           │                        └──────────────────────┘     │
│           │                                                      │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              Horizontal Pod Autoscaler                  │    │
│  │         (CPU & Memory based auto-scaling)               │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

## Component Architecture

### 1. Frontend Service (React)

**Technology Stack:**
- React 18 with Vite
- TailwindCSS for styling
- Axios for API communication
- Nginx for serving static files

**Key Features:**
- Single Page Application (SPA)
- Responsive design
- Client-side routing
- API proxy configuration
- Health check endpoints

**Container Details:**
- Base Image: `node:18-alpine` (build), `nginx:alpine` (runtime)
- Multi-stage build for optimization
- Non-root user execution
- Resource limits: 128Mi-256Mi memory, 100m-200m CPU

### 2. Backend Service (.NET Core)

**Technology Stack:**
- .NET 8.0 Web API
- Entity Framework Core
- SQL Server
- Serilog for logging
- Swagger/OpenAPI

**Key Features:**
- RESTful API design
- CRUD operations for products
- Database migrations
- Health and readiness probes
- Structured logging
- Automatic retry logic for database connections

**Container Details:**
- Base Image: `mcr.microsoft.com/dotnet/aspnet:8.0`
- Multi-stage build
- Non-root user execution
- Resource limits: 256Mi-512Mi memory, 250m-500m CPU

**API Endpoints:**
```
GET    /api/products              - Get all products
GET    /api/products/{id}         - Get product by ID
GET    /api/products/category/{category} - Get products by category
POST   /api/products              - Create new product
PUT    /api/products/{id}         - Update product
DELETE /api/products/{id}         - Delete product (soft delete)
GET    /api/health                - Health check
GET    /api/health/ready          - Readiness check
```

### 3. Database Service (SQL Server)

**Technology Stack:**
- Microsoft SQL Server 2022
- StatefulSet for persistence
- Persistent Volume Claims

**Key Features:**
- Persistent data storage
- Automatic initialization scripts
- Connection pooling
- Transaction support

**Container Details:**
- Base Image: `mcr.microsoft.com/mssql/server:2022-latest`
- Persistent Volume: 10Gi
- Resource limits: 2Gi-4Gi memory, 1-2 CPU cores

## CI/CD Pipeline Architecture

### Pipeline Stages

#### 1. Build Stage
- Checkout source code
- Restore dependencies
- Compile application
- Generate build artifacts

#### 2. Test Stage
- Run unit tests
- Run integration tests
- Generate code coverage reports
- Upload test results

#### 3. Security Scan Stage
- OWASP Dependency Check
- Trivy container scanning
- Vulnerability assessment
- Security report generation

#### 4. Build & Push Stage
- Build Docker images
- Tag with commit SHA and branch
- Push to GitHub Container Registry
- Layer caching for optimization

#### 5. Deploy Stage
- Update Kubernetes deployments
- Rolling update strategy
- Health check verification
- Smoke tests

### Deployment Environments

**Development (dev):**
- Triggered on: Push to feature branches
- Auto-deploy: Yes
- Approval: Not required

**Staging:**
- Triggered on: Push to `develop` branch
- Auto-deploy: Yes
- Approval: Not required
- Purpose: Pre-production testing

**Production:**
- Triggered on: Push to `main` branch
- Auto-deploy: Yes (can be configured for manual approval)
- Approval: Optional (recommended)
- Purpose: Live environment

## Kubernetes Architecture

### Namespace Organization
```
microservices/
├── Deployments
│   ├── frontend (2-10 replicas)
│   └── backend (2-10 replicas)
├── StatefulSets
│   └── sqlserver (1 replica)
├── Services
│   ├── frontend-service (LoadBalancer)
│   ├── backend-service (ClusterIP)
│   └── sqlserver-service (ClusterIP)
├── ConfigMaps
│   └── app-config
├── Secrets
│   └── sqlserver-secret
└── PersistentVolumeClaims
    └── sqlserver-pvc (10Gi)
```

### Resource Management

**Frontend Pods:**
- Requests: 128Mi memory, 100m CPU
- Limits: 256Mi memory, 200m CPU
- Replicas: 2-10 (auto-scaling)

**Backend Pods:**
- Requests: 256Mi memory, 250m CPU
- Limits: 512Mi memory, 500m CPU
- Replicas: 2-10 (auto-scaling)

**Database Pod:**
- Requests: 2Gi memory, 1 CPU
- Limits: 4Gi memory, 2 CPU
- Replicas: 1 (StatefulSet)

### Auto-scaling Configuration

**Horizontal Pod Autoscaler (HPA):**
- Metric: CPU utilization (70% threshold)
- Metric: Memory utilization (80% threshold)
- Scale up: When metrics exceed threshold
- Scale down: After 5 minutes of low utilization

### Health Checks

**Liveness Probes:**
- Check if container is running
- Restart container on failure
- Initial delay: 30 seconds
- Period: 10 seconds

**Readiness Probes:**
- Check if container is ready to serve traffic
- Remove from service on failure
- Initial delay: 20 seconds
- Period: 5 seconds

## Security Architecture

### Container Security
- Non-root user execution
- Minimal base images (Alpine)
- Multi-stage builds
- No secrets in images
- Regular vulnerability scanning

### Network Security
- Service-to-service communication within cluster
- Network policies (optional)
- TLS/HTTPS support (configurable)
- API authentication (can be added)

### Secret Management
- Kubernetes Secrets for sensitive data
- Environment variable injection
- Base64 encoding
- External secret management (recommended for production)

### Security Scanning
- Trivy for container vulnerabilities
- OWASP Dependency Check
- npm audit for frontend
- .NET security scanning

## Monitoring and Observability

### Logging
- Structured logging with Serilog
- Console and file outputs
- Log aggregation ready
- Request/response logging

### Metrics
- Health check endpoints
- Readiness endpoints
- Resource utilization metrics
- Auto-scaling metrics

### Recommended Additions
- Prometheus for metrics collection
- Grafana for visualization
- ELK/EFK stack for log aggregation
- Distributed tracing (Jaeger/Zipkin)

## Scalability Considerations

### Horizontal Scaling
- Frontend: Stateless, easily scalable
- Backend: Stateless, easily scalable
- Database: Vertical scaling recommended

### Performance Optimization
- Docker layer caching
- CDN for static assets (recommended)
- Database connection pooling
- API response caching (can be added)
- Load balancing

## Disaster Recovery

### Backup Strategy
- Database: Regular backups of persistent volume
- Configuration: Version controlled in Git
- Images: Stored in container registry

### Recovery Procedures
- Rollback to previous deployment
- Restore database from backup
- Redeploy from Git repository

## Technology Decisions

### Why Microservices?
- Independent deployment
- Technology flexibility
- Scalability
- Fault isolation

### Why Kubernetes?
- Container orchestration
- Auto-scaling
- Self-healing
- Service discovery
- Load balancing

### Why GitHub Actions?
- Native GitHub integration
- Free for public repositories
- Easy to configure
- Matrix builds support
- Rich marketplace

### Why SQL Server?
- Enterprise-grade RDBMS
- Strong consistency
- Transaction support
- Excellent .NET integration
- Familiar to many developers

## Future Enhancements

1. **Service Mesh** (Istio/Linkerd)
   - Advanced traffic management
   - Mutual TLS
   - Observability

2. **API Gateway**
   - Rate limiting
   - Authentication
   - Request routing

3. **Caching Layer** (Redis)
   - Improved performance
   - Session management

4. **Message Queue** (RabbitMQ/Kafka)
   - Asynchronous processing
   - Event-driven architecture

5. **Monitoring Stack**
   - Prometheus + Grafana
   - ELK/EFK stack
   - Distributed tracing

## Conclusion

This architecture demonstrates modern DevOps practices with:
- ✅ Automated CI/CD pipelines
- ✅ Containerization with Docker
- ✅ Orchestration with Kubernetes
- ✅ Security scanning and testing
- ✅ Auto-scaling and self-healing
- ✅ Infrastructure as Code
- ✅ Comprehensive documentation

The system is production-ready and can be extended with additional features as needed.
