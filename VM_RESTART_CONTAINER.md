# 🔄 Restart Container on VM (Without Docker Compose)

## Quick Solution

If `docker-compose` is not installed, you can restart containers directly using Docker:

```bash
# Restart app container
docker restart cotton_weed_app

# Restart API container
docker restart cotton_weed_api

# Restart both
docker restart cotton_weed_app cotton_weed_api
```

---

## Alternative: Stop and Start (Full Restart)

If you want to force a complete restart:

```bash
# Stop app container
docker stop cotton_weed_app

# Start app container
docker start cotton_weed_app
```

Or in one command:

```bash
docker stop cotton_weed_app && docker start cotton_weed_app
```

---

## After Pulling New Image

If you just pulled a new image and want to use it:

```bash
# 1. Stop the container
docker stop cotton_weed_app

# 2. Remove the old container (this doesn't delete the image)
docker rm cotton_weed_app

# 3. Recreate with new image using docker-compose OR run directly:

# Option A: Using docker run (if docker-compose not available)
docker run -d \
  --name cotton_weed_app \
  --restart unless-stopped \
  -p 8501:8501 \
  -e API_URL=http://api:8000 \
  --network bridge \
  gcr.io/cotton-weed-detection-app/app:latest

# Option B: Install docker-compose and use it
# (see installation below)
```

---

## Install Docker Compose (Optional - For Future Use)

If you want to install Docker Compose for easier management:

### Method 1: Install Docker Compose Standalone

```bash
# Download and install
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker-compose --version
```

### Method 2: Use Docker Compose Plugin (Newer Way)

```bash
# Install Docker Compose plugin
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Use as: docker compose (with space, not hyphen)
docker compose version
```

---

## Check Container Status

After restarting, verify everything is working:

```bash
# Check if container is running
docker ps

# Check container logs
docker logs cotton_weed_app

# Check last 50 lines of logs
docker logs --tail 50 cotton_weed_app

# Follow logs in real-time
docker logs -f cotton_weed_app
```

---

## Verify New Image is Being Used

Check that the container is using the latest image:

```bash
# Check container image ID
docker inspect cotton_weed_app | grep Image

# Compare with pulled image
docker images gcr.io/cotton-weed-detection-app/app:latest

# The Image ID in the container should match the latest image ID
```

---

## One-Line Commands

### Restart app with new image:

```bash
docker stop cotton_weed_app && docker rm cotton_weed_app && docker run -d --name cotton_weed_app --restart unless-stopped -p 8501:8501 -e API_URL=http://api:8000 --network bridge gcr.io/cotton-weed-detection-app/app:latest
```

### Check if new image is loaded:

```bash
docker logs cotton_weed_app | head -20
```

---

## Troubleshooting

### Container won't restart:
```bash
# Check what's wrong
docker logs cotton_weed_app

# Check container status
docker ps -a | grep cotton_weed_app
```

### Want to see what's happening:
```bash
# Watch logs in real-time
docker logs -f cotton_weed_app
```

### Need to completely rebuild:
```bash
# Stop and remove
docker stop cotton_weed_app
docker rm cotton_weed_app

# Pull latest
docker pull gcr.io/cotton-weed-detection-app/app:latest

# Start again (if docker-compose available)
docker-compose up -d app

# OR run directly
docker run -d --name cotton_weed_app --restart unless-stopped -p 8501:8501 -e API_URL=http://api:8000 gcr.io/cotton-weed-detection-app/app:latest
```

---

## Summary

**For immediate restart (no Docker Compose needed):**
```bash
docker restart cotton_weed_app
```

**To use newly pulled image:**
```bash
docker stop cotton_weed_app && docker rm cotton_weed_app
# Then use docker-compose up -d app OR docker run command above
```

**To install Docker Compose (for future convenience):**
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

