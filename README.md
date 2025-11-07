# CI/CD Microservices Project

A production-ready CI/CD pipeline demonstrating automated testing, security scanning, and deployment of a multi-service application to Kubernetes.

## 🏗️ Architecture Overview

This project implements a modern microservices architecture with:

- **Frontend Service**: React-based web application
- **Backend API Service**: .NET Core Web API with SQL Server
- **Database**: SQL Server for persistent data storage
- **Container Orchestration**: Kubernetes (K8s)
- **CI/CD**: GitHub Actions with automated testing and security scanning

## 🚀 Features

### CI/CD Pipeline
- ✅ Automated testing (unit tests, integration tests)
- ✅ Code quality analysis
- ✅ Security vulnerability scanning (Trivy, OWASP Dependency Check)
- ✅ Docker image building and optimization
- ✅ Multi-stage builds for reduced image size
- ✅ Automated deployment to multiple environments (dev, staging, prod)
- ✅ Container registry integration (GitHub Container Registry)
- ✅ Kubernetes deployment automation
- ✅ Health checks and readiness probes

### Application Features
- RESTful API with CRUD operations
- SQL Server database integration
- Swagger/OpenAPI documentation
- Modern React frontend with responsive design
- Environment-based configuration
- Logging and monitoring ready

## 📁 Project Structure

```
cicd-microservices-project/
├── .github/
│   └── workflows/
│       ├── backend-ci-cd.yml      # Backend CI/CD pipeline
│       ├── frontend-ci-cd.yml     # Frontend CI/CD pipeline
│       └── database-ci.yml        # Database migration pipeline
├── backend/
│   ├── src/
│   │   ├── Controllers/           # API controllers
│   │   ├── Models/                # Data models
│   │   ├── Services/              # Business logic
│   │   └── Data/                  # Database context
│   ├── tests/                     # Unit and integration tests
│   ├── Dockerfile                 # Multi-stage Docker build
│   └── ProductApi.sln             # Solution file
├── frontend/
│   ├── src/
│   │   ├── components/            # React components
│   │   ├── services/              # API services
│   │   └── App.jsx                # Main app component
│   ├── public/                    # Static assets
│   ├── Dockerfile                 # Multi-stage Docker build
│   └── package.json               # Dependencies
├── database/
│   ├── init/                      # Database initialization scripts
│   └── migrations/                # Database migration scripts
├── k8s/
│   ├── base/                      # Base Kubernetes manifests
│   │   ├── namespace.yaml
│   │   ├── backend-deployment.yaml
│   │   ├── frontend-deployment.yaml
│   │   ├── database-statefulset.yaml
│   │   └── services.yaml
│   └── overlays/                  # Environment-specific configs
│       ├── dev/
│       ├── staging/
│       └── prod/
├── docs/
│   ├── architecture.md            # Architecture documentation
│   ├── deployment-guide.md        # Deployment instructions
│   └── diagrams/                  # Architecture diagrams
└── scripts/
    ├── setup-local.sh             # Local development setup
    └── deploy.sh                  # Deployment script
```

## 🛠️ Technology Stack

### Backend
- **.NET 8.0**: Modern, high-performance framework
- **ASP.NET Core Web API**: RESTful API development
- **Entity Framework Core**: ORM for database operations
- **SQL Server**: Relational database
- **xUnit**: Testing framework
- **Serilog**: Structured logging

### Frontend
- **React 18**: Modern UI library
- **Vite**: Fast build tool
- **Axios**: HTTP client
- **TailwindCSS**: Utility-first CSS framework
- **React Router**: Client-side routing
- **Lucide React**: Modern icon library

### DevOps
- **Docker**: Containerization
- **Kubernetes**: Container orchestration
- **GitHub Actions**: CI/CD automation
- **Trivy**: Container security scanning
- **OWASP Dependency Check**: Dependency vulnerability scanning
- **SonarCloud** (optional): Code quality analysis

## 🚦 Getting Started

### Prerequisites

- Docker Desktop with Kubernetes enabled
- .NET 8.0 SDK
- Node.js 18+ and npm
- kubectl CLI
- Git

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/cicd-microservices-project.git
   cd cicd-microservices-project
   ```

2. **Start SQL Server locally**
   ```bash
   docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" \
     -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest
   ```

3. **Run Backend API**
   ```bash
   cd backend/src
   dotnet restore
   dotnet run
   ```
   API will be available at `http://localhost:5000`

4. **Run Frontend**
   ```bash
   cd frontend
   npm install
   npm run dev
   ```
   Frontend will be available at `http://localhost:3000`

### Deploy to Kubernetes

1. **Build and push Docker images**
   ```bash
   # Backend
   docker build -t yourusername/product-api:latest ./backend
   docker push yourusername/product-api:latest

   # Frontend
   docker build -t yourusername/product-frontend:latest ./frontend
   docker push yourusername/product-frontend:latest
   ```

2. **Deploy to Kubernetes**
   ```bash
   kubectl apply -f k8s/base/
   ```

3. **Verify deployment**
   ```bash
   kubectl get pods -n microservices
   kubectl get services -n microservices
   ```

## 🔄 CI/CD Pipeline

The GitHub Actions pipeline automatically:

1. **Build Stage**
   - Checkout code
   - Restore dependencies
   - Build application

2. **Test Stage**
   - Run unit tests
   - Run integration tests
   - Generate code coverage reports

3. **Security Scan Stage**
   - Scan dependencies for vulnerabilities
   - Scan Docker images with Trivy
   - Check for security best practices

4. **Build & Push Stage**
   - Build optimized Docker images
   - Tag with commit SHA and branch name
   - Push to GitHub Container Registry

5. **Deploy Stage**
   - Deploy to appropriate environment (dev/staging/prod)
   - Run smoke tests
   - Health check verification

### Pipeline Triggers

- **Push to `main`**: Deploy to production
- **Push to `develop`**: Deploy to staging
- **Pull Request**: Run tests and security scans
- **Manual**: Deploy to any environment

## 📊 Monitoring and Observability

- Health check endpoints: `/health` and `/ready`
- Structured logging with Serilog
- Kubernetes liveness and readiness probes
- Resource limits and requests configured

## 🔐 Security Features

- Container image scanning with Trivy
- Dependency vulnerability scanning
- Non-root container execution
- Secrets management with Kubernetes secrets
- Network policies for pod communication
- HTTPS/TLS configuration ready

## 🧪 Testing Strategy

- **Unit Tests**: Test individual components
- **Integration Tests**: Test API endpoints with test database
- **Security Tests**: Automated vulnerability scanning
- **Smoke Tests**: Post-deployment verification

## 📈 Performance Optimization

- Multi-stage Docker builds for minimal image size
- Layer caching optimization
- Resource limits and autoscaling configured
- Database connection pooling
- Frontend code splitting and lazy loading

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎯 Learning Objectives

This project demonstrates:
- Modern microservices architecture
- Container orchestration with Kubernetes
- CI/CD best practices
- Security scanning and vulnerability management
- Infrastructure as Code (IaC)
- Automated testing strategies
- Multi-environment deployment
- DevOps culture and practices

## 📚 Additional Resources

- [Architecture Documentation](./docs/architecture.md)
- [Deployment Guide](./docs/deployment-guide.md)
- [API Documentation](http://localhost:5000/swagger) (when running locally)

## 🙋 Support

For questions or issues, please open an issue in the GitHub repository.

---

**Built with ❤️ to demonstrate DevOps excellence**
