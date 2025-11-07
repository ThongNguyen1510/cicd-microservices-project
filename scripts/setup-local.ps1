# Local Development Setup Script for Windows
# This script sets up the development environment for the microservices project

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Microservices Project Setup Script  " -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Docker is installed
Write-Host "Checking prerequisites..." -ForegroundColor Yellow
if (Get-Command docker -ErrorAction SilentlyContinue) {
    Write-Host "✓ Docker is installed" -ForegroundColor Green
} else {
    Write-Host "✗ Docker is not installed. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Check if .NET SDK is installed
if (Get-Command dotnet -ErrorAction SilentlyContinue) {
    $dotnetVersion = dotnet --version
    Write-Host "✓ .NET SDK is installed (version $dotnetVersion)" -ForegroundColor Green
} else {
    Write-Host "✗ .NET SDK is not installed. Please install .NET 8.0 SDK." -ForegroundColor Red
    exit 1
}

# Check if Node.js is installed
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version
    Write-Host "✓ Node.js is installed (version $nodeVersion)" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js is not installed. Please install Node.js 18+." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Starting SQL Server container..." -ForegroundColor Yellow

# Check if SQL Server container already exists
$existingContainer = docker ps -a --filter "name=sqlserver" --format "{{.Names}}"
if ($existingContainer -eq "sqlserver") {
    Write-Host "SQL Server container already exists. Removing..." -ForegroundColor Yellow
    docker rm -f sqlserver
}

# Start SQL Server
docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=YourStrong@Passw0rd" `
    -p 1433:1433 --name sqlserver -d `
    mcr.microsoft.com/mssql/server:2022-latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ SQL Server container started successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to start SQL Server container" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Waiting for SQL Server to be ready..." -ForegroundColor Yellow
Start-Sleep -Seconds 15

Write-Host ""
Write-Host "Setting up Backend API..." -ForegroundColor Yellow
Set-Location -Path "backend/src"

Write-Host "Restoring .NET dependencies..." -ForegroundColor Yellow
dotnet restore

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Backend dependencies restored" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to restore backend dependencies" -ForegroundColor Red
    Set-Location -Path "../.."
    exit 1
}

Write-Host "Building backend..." -ForegroundColor Yellow
dotnet build --no-restore

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Backend built successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to build backend" -ForegroundColor Red
    Set-Location -Path "../.."
    exit 1
}

Set-Location -Path "../.."

Write-Host ""
Write-Host "Setting up Frontend..." -ForegroundColor Yellow
Set-Location -Path "frontend"

Write-Host "Installing npm dependencies..." -ForegroundColor Yellow
npm install

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Frontend dependencies installed" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install frontend dependencies" -ForegroundColor Red
    Set-Location -Path ".."
    exit 1
}

Set-Location -Path ".."

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Setup completed successfully! ✓      " -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "To start the application:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Start Backend API:" -ForegroundColor White
Write-Host "   cd backend/src" -ForegroundColor Gray
Write-Host "   dotnet run" -ForegroundColor Gray
Write-Host "   API will be available at: http://localhost:5000" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Start Frontend (in a new terminal):" -ForegroundColor White
Write-Host "   cd frontend" -ForegroundColor Gray
Write-Host "   npm run dev" -ForegroundColor Gray
Write-Host "   Frontend will be available at: http://localhost:3000" -ForegroundColor Yellow
Write-Host ""
Write-Host "Or use Docker Compose:" -ForegroundColor White
Write-Host "   docker-compose up -d" -ForegroundColor Gray
Write-Host ""
Write-Host "Useful commands:" -ForegroundColor Cyan
Write-Host "   docker ps                    - View running containers" -ForegroundColor Gray
Write-Host "   docker logs sqlserver        - View SQL Server logs" -ForegroundColor Gray
Write-Host "   docker-compose logs -f       - View all service logs" -ForegroundColor Gray
Write-Host ""
