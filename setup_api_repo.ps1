# PowerShell script to create API-only repository
# Run this from cotton_weed_project directory

Write-Host "🚀 Creating API-only repository..." -ForegroundColor Green

# Get current directory
$currentDir = Get-Location
$parentDir = Split-Path -Parent $currentDir
$apiRepoPath = Join-Path $parentDir "cotton-weed-api"

# Create new directory
Write-Host "Creating directory: $apiRepoPath" -ForegroundColor Yellow
if (Test-Path $apiRepoPath) {
    Write-Host "Directory already exists. Removing..." -ForegroundColor Yellow
    Remove-Item -Path $apiRepoPath -Recurse -Force
}
New-Item -ItemType Directory -Path $apiRepoPath | Out-Null

# Copy API folder
Write-Host "Copying API folder..." -ForegroundColor Yellow
Copy-Item -Path "api" -Destination "$apiRepoPath\api" -Recurse -Exclude "__pycache__","*.db","uploads"

# Copy models folder
Write-Host "Copying models folder..." -ForegroundColor Yellow
Copy-Item -Path "models" -Destination "$apiRepoPath\models" -Recurse

# Copy Dockerfile (rename to Dockerfile)
Write-Host "Copying Dockerfile..." -ForegroundColor Yellow
Copy-Item -Path "docker\Dockerfile.api" -Destination "$apiRepoPath\Dockerfile"

# Copy requirements.txt
Write-Host "Copying requirements.txt..." -ForegroundColor Yellow
Copy-Item -Path "requirements.txt" -Destination "$apiRepoPath\requirements.txt"

# Create .gitignore
Write-Host "Creating .gitignore..." -ForegroundColor Yellow
$gitignoreContent = @"
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
env/
venv/
ENV/
build/
*.egg-info/

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Environment variables
.env
.env.local

# Logs
*.log
logs/

# Database
*.db
*.sqlite
*.sqlite3

# Uploads
uploads/
*.jpg
*.jpeg
*.png
!models/*.jpg
!models/*.jpeg
!models/*.png

# Keep model files
!models/*.pt
!models/*.pth
"@
Set-Content -Path "$apiRepoPath\.gitignore" -Value $gitignoreContent

# Create README.md
Write-Host "Creating README.md..." -ForegroundColor Yellow
$readmeContent = @"
# Cotton Weed Detection API

FastAPI backend for cotton weed detection using YOLOv8.

## Quick Start

### Local Development

\`\`\`bash
pip install -r requirements.txt
uvicorn api.main:app --reload --port 8000
\`\`\`

### Docker

\`\`\`bash
docker build -t cotton-weed-api .
docker run -p 8000:8000 cotton-weed-api
\`\`\`

## API Endpoints

- \`GET /health\` - Health check
- \`POST /predict\` - Upload image and get predictions
- \`GET /docs\` - Interactive API documentation

## Deployment

This API is deployed on Render.com
"@
Set-Content -Path "$apiRepoPath\README.md" -Value $readmeContent

Write-Host "✅ API repository structure created at: $apiRepoPath" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. cd $apiRepoPath" -ForegroundColor White
Write-Host "2. git init" -ForegroundColor White
Write-Host "3. git add ." -ForegroundColor White
Write-Host "4. git commit -m 'Initial commit: API for cotton weed detection'" -ForegroundColor White
Write-Host "5. Create repository on GitHub and push" -ForegroundColor White

