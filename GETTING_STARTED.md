# Getting Started with CI/CD Microservices Project

Welcome! This guide will help you get the project up and running quickly and understand how to use it effectively.

## 📋 Table of Contents

1. [What You'll Need](#what-youll-need)
2. [Installation Steps](#installation-steps)
3. [Running the Application](#running-the-application)
4. [Understanding the Project](#understanding-the-project)
5. [Making Changes](#making-changes)
6. [Deploying](#deploying)
7. [Troubleshooting](#troubleshooting)
8. [Next Steps](#next-steps)

## 🎯 What You'll Need

### Required Software

| Tool | Version | Purpose | Download Link |
|------|---------|---------|---------------|
| Docker Desktop | 20.10+ | Container runtime | [docker.com](https://www.docker.com/products/docker-desktop) |
| .NET SDK | 8.0 | Backend development | [dotnet.microsoft.com](https://dotnet.microsoft.com/download) |
| Node.js | 18+ | Frontend development | [nodejs.org](https://nodejs.org/) |
| Git | 2.30+ | Version control | [git-scm.com](https://git-scm.com/) |

### Optional Tools

- **kubectl**: Kubernetes CLI (for K8s deployment)
- **VS Code**: Recommended code editor
- **Postman**: API testing
- **k9s**: Terminal UI for Kubernetes

### System Requirements

- **OS**: Windows 10/11, macOS, or Linux
- **RAM**: 8GB minimum, 16GB recommended
- **Disk**: 20GB free space
- **CPU**: 4 cores recommended

## 🚀 Installation Steps

### Step 1: Install Prerequisites

#### Windows (PowerShell as Administrator)

```powershell
# Install Chocolatey (if not installed)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install tools
choco install docker-desktop -y
choco install dotnet-sdk -y
choco install nodejs -y
choco install git -y

# Restart your terminal
```

#### macOS (using Homebrew)

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install tools
brew install --cask docker
brew install dotnet
brew install node
brew install git
```

#### Linux (Ubuntu/Debian)

```bash
# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# .NET SDK
wget https://dot.net/v1/dotnet-install.sh
chmod +x dotnet-install.sh
./dotnet-install.sh --channel 8.0

# Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Git
sudo apt-get install git -y
```

### Step 2: Verify Installation

```bash
# Check versions
docker --version
dotnet --version
node --version
npm --version
git --version
```

Expected output:
```
Docker version 24.0.x
8.0.xxx
v18.x.x
9.x.x
git version 2.x.x
```

### Step 3: Enable Kubernetes (Optional)

1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"
5. Wait for Kubernetes to start (green indicator)

Verify:
```bash
kubectl version --client
```

### Step 4: Clone the Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/cicd-microservices-project.git

# Navigate to project directory
cd cicd-microservices-project

# Verify files
ls
```

You should see:
```
backend/
frontend/
k8s/
docs/
scripts/
docker-compose.yml
README.md
...
```

## 🎮 Running the Application

### Method 1: Docker Compose (Recommended for Beginners)

This is the easiest way to get started!

```bash
# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

**Access the application:**
- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- Swagger Docs: http://localhost:5000/swagger

**Stop services:**
```bash
docker-compose down
```

### Method 2: Local Development

For active development with hot reload:

#### Terminal 1 - Backend

```bash
cd backend/src
dotnet restore
dotnet run
```

Backend will start at: http://localhost:5000

#### Terminal 2 - Frontend

```bash
cd frontend
npm install
npm run dev
```

Frontend will start at: http://localhost:3000

#### Terminal 3 - Database (if needed)

```bash
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" \
  -p 1433:1433 --name sqlserver -d \
  mcr.microsoft.com/mssql/server:2022-latest
```

### Method 3: Kubernetes

For production-like environment:

```powershell
# Windows
.\scripts\deploy-k8s.ps1

# Or manually
kubectl apply -f k8s/base/
```

**Access the application:**
```bash
kubectl port-forward service/frontend-service 8080:80 -n microservices
```

Then open: http://localhost:8080

## 🎓 Understanding the Project

### Project Structure

```
cicd-microservices-project/
│
├── backend/                    # .NET Core API
│   ├── src/                   # Source code
│   │   ├── Controllers/       # API endpoints
│   │   ├── Services/          # Business logic
│   │   ├── Models/            # Data models
│   │   ├── Data/              # Database context
│   │   └── Program.cs         # Application entry point
│   ├── tests/                 # Unit tests
│   └── Dockerfile             # Container definition
│
├── frontend/                   # React application
│   ├── src/
│   │   ├── components/        # React components
│   │   ├── services/          # API calls
│   │   └── App.jsx            # Main app
│   ├── Dockerfile
│   └── package.json
│
├── k8s/                        # Kubernetes manifests
│   └── base/
│       ├── namespace.yaml
│       ├── backend-deployment.yaml
│       ├── frontend-deployment.yaml
│       └── database-statefulset.yaml
│
├── .github/workflows/          # CI/CD pipelines
│   ├── backend-ci-cd.yaml
│   └── frontend-ci-cd.yaml
│
├── docs/                       # Documentation
├── scripts/                    # Automation scripts
└── docker-compose.yml          # Local orchestration
```

### Key Concepts

#### 1. Microservices Architecture
- **Frontend**: User interface (React)
- **Backend**: Business logic (API)
- **Database**: Data storage (SQL Server)

Each service is independent and can be deployed separately.

#### 2. Containerization
- Each service runs in a Docker container
- Containers are portable and consistent
- Easy to deploy anywhere

#### 3. Orchestration
- Kubernetes manages containers
- Auto-scaling based on load
- Self-healing if containers fail

#### 4. CI/CD Pipeline
- Automated testing on every commit
- Automated security scanning
- Automated deployment to environments

### How It Works

1. **User visits frontend** (React app)
2. **Frontend calls backend API** (REST endpoints)
3. **Backend queries database** (SQL Server)
4. **Data returns to user** through the chain

```
User → Frontend → Backend → Database
     ←          ←         ←
```

## 🛠️ Making Changes

### Modify the Backend

1. **Edit a controller:**
```bash
# Open backend/src/Controllers/ProductsController.cs
# Add a new endpoint or modify existing ones
```

2. **Test your changes:**
```bash
cd backend
dotnet test
```

3. **Run locally:**
```bash
cd backend/src
dotnet run
```

### Modify the Frontend

1. **Edit a component:**
```bash
# Open frontend/src/components/ProductCard.jsx
# Modify the UI or add features
```

2. **See changes immediately:**
```bash
cd frontend
npm run dev
# Changes auto-reload in browser
```

### Add a New Feature

Example: Add a "Featured" flag to products

1. **Update backend model:**
```csharp
// backend/src/Models/Product.cs
public bool IsFeatured { get; set; }
```

2. **Create migration:**
```bash
cd backend/src
dotnet ef migrations add AddFeaturedFlag
```

3. **Update frontend:**
```jsx
// frontend/src/components/ProductForm.jsx
// Add checkbox for featured flag
```

4. **Test and commit:**
```bash
git add .
git commit -m "feat: add featured products"
git push
```

## 🚢 Deploying

### Deploy to GitHub

1. **Create GitHub repository**
2. **Push code:**
```bash
git remote add origin https://github.com/yourusername/cicd-microservices-project.git
git push -u origin main
```

3. **Configure secrets:**
   - Go to Settings → Secrets
   - Add `KUBE_CONFIG` (if using K8s)

4. **Watch CI/CD run:**
   - Go to Actions tab
   - See automated build, test, and deploy

### Deploy to Cloud

#### AWS EKS
```bash
# Configure AWS CLI
aws configure

# Create EKS cluster
eksctl create cluster --name microservices --region us-east-1

# Deploy
kubectl apply -f k8s/base/
```

#### Azure AKS
```bash
# Login to Azure
az login

# Create AKS cluster
az aks create --resource-group myResourceGroup --name microservices

# Deploy
kubectl apply -f k8s/base/
```

#### Google GKE
```bash
# Login to Google Cloud
gcloud auth login

# Create GKE cluster
gcloud container clusters create microservices

# Deploy
kubectl apply -f k8s/base/
```

## 🔧 Troubleshooting

### Common Issues

#### Issue: "Cannot connect to Docker daemon"
**Solution:**
```bash
# Start Docker Desktop
# Wait for it to fully start (green icon)
```

#### Issue: "Port already in use"
**Solution:**
```bash
# Windows
netstat -ano | findstr :5000
taskkill /PID <PID> /F

# macOS/Linux
lsof -ti:5000 | xargs kill -9
```

#### Issue: "Database connection failed"
**Solution:**
```bash
# Wait 30 seconds for SQL Server to start
# Or restart SQL Server container
docker restart sqlserver
```

#### Issue: "npm install fails"
**Solution:**
```bash
cd frontend
rm -rf node_modules package-lock.json
npm install
```

#### Issue: "Kubernetes pods not starting"
**Solution:**
```bash
# Check pod status
kubectl get pods -n microservices

# Check pod logs
kubectl logs <pod-name> -n microservices

# Describe pod for events
kubectl describe pod <pod-name> -n microservices
```

### Getting Help

1. **Check logs:**
   ```bash
   # Docker Compose
   docker-compose logs backend
   
   # Kubernetes
   kubectl logs -l app=backend -n microservices
   ```

2. **Check documentation:**
   - README.md
   - docs/deployment-guide.md
   - docs/architecture.md

3. **Search issues:**
   - GitHub Issues
   - Stack Overflow

4. **Ask for help:**
   - Open an issue on GitHub
   - Join community discussions

## 📚 Next Steps

### Learn More

1. **Explore the code:**
   - Read through backend controllers
   - Understand frontend components
   - Review Kubernetes manifests

2. **Read documentation:**
   - [Architecture](docs/architecture.md)
   - [Deployment Guide](docs/deployment-guide.md)
   - [Features](docs/FEATURES.md)

3. **Watch tutorials:**
   - Docker basics
   - Kubernetes fundamentals
   - CI/CD best practices

### Extend the Project

1. **Add authentication:**
   - JWT tokens
   - OAuth integration
   - User management

2. **Add more services:**
   - Notification service
   - File upload service
   - Analytics service

3. **Improve infrastructure:**
   - Add monitoring (Prometheus/Grafana)
   - Add logging (ELK stack)
   - Add caching (Redis)

### Prepare for Interviews

1. **Practice demo:**
   - Follow [DEMO_SCRIPT.md](docs/DEMO_SCRIPT.md)
   - Time yourself (aim for 15 minutes)
   - Record yourself

2. **Understand deeply:**
   - Know every technology choice
   - Explain trade-offs
   - Discuss improvements

3. **Prepare questions:**
   - About their DevOps practices
   - About their tech stack
   - About team structure

## ✅ Success Checklist

You're ready when you can:
- [ ] Start all services without errors
- [ ] Create, read, update, and delete products
- [ ] Explain the architecture
- [ ] Run tests successfully
- [ ] Deploy to Kubernetes
- [ ] Explain CI/CD pipeline
- [ ] Troubleshoot common issues

## 🎉 Congratulations!

You now have a working CI/CD microservices application!

**What you've accomplished:**
- ✅ Set up a complete development environment
- ✅ Deployed a multi-service application
- ✅ Learned Docker and Kubernetes
- ✅ Understood CI/CD pipelines
- ✅ Built a portfolio project

**Keep learning and building! 🚀**

---

## 📞 Resources

- **Documentation**: See `docs/` folder
- **Quick Start**: See `QUICKSTART.md`
- **Checklist**: See `CHECKLIST.md`
- **Demo Script**: See `docs/DEMO_SCRIPT.md`

**Questions?** Open an issue on GitHub!
