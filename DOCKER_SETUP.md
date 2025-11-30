# 🐳 Docker Setup Guide

## Prerequisites

1. **Docker Desktop must be installed and running**
   - Download: https://www.docker.com/products/docker-desktop
   - Install and **make sure it's running** (you'll see Docker icon in system tray)

2. **Stop your local API and App** (if running)
   - Press `Ctrl+C` in both terminals
   - Docker will use the same ports (8000 and 8501)

## Step-by-Step Docker Setup

### Step 1: Verify Docker is Running

```powershell
docker --version
docker ps
```

If you get an error like "Cannot connect to Docker daemon", Docker Desktop is not running.

**Fix:** Open Docker Desktop application and wait for it to start (whale icon in system tray should be steady).

### Step 2: Stop Local Services

**IMPORTANT:** Stop your locally running API and App first!

1. Go to Terminal 1 (API) - Press `Ctrl+C`
2. Go to Terminal 2 (App) - Press `Ctrl+C`

Docker will use ports 8000 and 8501, so they need to be free.

### Step 3: Build and Run with Docker

```powershell
docker-compose up --build
```

This will:
- Build Docker images for API and App
- Start both containers
- Show logs from both services

### Step 4: Access the Application

- **Streamlit App**: http://localhost:8501
- **API Docs**: http://localhost:8000/docs
- **API Health**: http://localhost:8000/health

### Step 5: Stop Docker Containers

Press `Ctrl+C` in the terminal, then:

```powershell
docker-compose down
```

## Common Issues

### Issue 1: "Cannot connect to Docker daemon"

**Solution:**
1. Open Docker Desktop
2. Wait for it to fully start (check system tray)
3. Try again

### Issue 2: "Port already in use"

**Solution:**
1. Stop your local API and App (Ctrl+C)
2. Or change ports in docker-compose.yml

### Issue 3: "Build failed"

**Solution:**
1. Check Docker Desktop is running
2. Make sure you have enough disk space
3. Try: `docker system prune` (cleans up old images)

### Issue 4: Model not found in container

**Solution:**
The docker-compose.yml already mounts the models folder. Make sure your model is in `models/` folder.

## Docker Commands Reference

```powershell
# Build and start
docker-compose up --build

# Start in background
docker-compose up -d

# View logs
docker-compose logs -f

# Stop containers
docker-compose down

# Rebuild specific service
docker-compose build api
docker-compose build app

# View running containers
docker ps

# Remove all containers and images
docker-compose down --rmi all
```

## What Docker Does

Docker packages your application into containers that:
- Include all dependencies
- Work the same on any machine
- Are isolated from your system
- Make deployment easier

## Next Steps After Docker Works

Once Docker is working locally, you're ready to:
1. Deploy to Google Cloud
2. Share with others
3. Run in production

---

**Remember:** Always make sure Docker Desktop is running before using docker commands!

