#!/bin/bash
# Streamlit App Deployment Script for VM
# This script ensures your Streamlit app is properly deployed and accessible

set -e

echo "🚀 Deploying Streamlit App on VM..."

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if running as root (some commands need sudo)
if [ "$EUID" -eq 0 ]; then 
    SUDO=""
else
    SUDO="sudo"
fi

# Step 1: Check Docker is installed and running
echo -e "${YELLOW}Step 1: Checking Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed. Installing Docker...${NC}"
    curl -fsSL https://get.docker.com -o get-docker.sh
    $SUDO sh get-docker.sh
    $SUDO usermod -aG docker $USER
    echo -e "${GREEN}Docker installed. Please log out and back in, then run this script again.${NC}"
    exit 0
fi

if ! docker ps &> /dev/null; then
    echo -e "${RED}Docker is not running. Starting Docker...${NC}"
    $SUDO systemctl start docker
    $SUDO systemctl enable docker
fi
echo -e "${GREEN}✓ Docker is running${NC}"

# Step 2: Set up docker-compose alias if needed
echo -e "${YELLOW}Step 2: Setting up docker-compose...${NC}"
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Setting up docker-compose alias..."
    alias docker-compose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest'
    # Add to .bashrc for persistence
    if ! grep -q "docker-compose alias" ~/.bashrc 2>/dev/null; then
        echo "" >> ~/.bashrc
        echo "# Docker Compose alias" >> ~/.bashrc
        echo "alias docker-compose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v \"\$PWD:\$PWD\" -w \"\$PWD\" docker/compose:latest'" >> ~/.bashrc
    fi
fi
echo -e "${GREEN}✓ docker-compose ready${NC}"

# Step 3: Navigate to home directory
cd ~

# Step 4: Check if docker-compose.yml exists
echo -e "${YELLOW}Step 3: Checking docker-compose.yml...${NC}"
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}docker-compose.yml not found. Creating it...${NC}"
    cat > docker-compose.yml << 'EOF'
services:
  api:
    image: gcr.io/cotton-weed-detection-app/api:latest
    container_name: cotton_weed_api
    ports:
      - "8000:8000"
    volumes:
      - ./models:/app/models
    environment:
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3

  app:
    image: gcr.io/cotton-weed-detection-app/app:latest
    container_name: cotton_weed_app
    ports:
      - "8501:8501"
    depends_on:
      api:
        condition: service_healthy
    environment:
      - API_URL=http://api:8000
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
EOF
    echo -e "${GREEN}✓ docker-compose.yml created${NC}"
else
    echo -e "${GREEN}✓ docker-compose.yml exists${NC}"
fi

# Step 5: Authenticate with GCP (if needed)
echo -e "${YELLOW}Step 4: Authenticating with GCP...${NC}"
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    echo "Please authenticate with GCP..."
    gcloud auth login
fi
gcloud auth configure-docker --quiet
echo -e "${GREEN}✓ GCP authentication ready${NC}"

# Step 6: Pull latest images
echo -e "${YELLOW}Step 5: Pulling latest Docker images...${NC}"
docker pull gcr.io/cotton-weed-detection-app/api:latest || echo -e "${YELLOW}Warning: Could not pull API image${NC}"
docker pull gcr.io/cotton-weed-detection-app/app:latest || echo -e "${YELLOW}Warning: Could not pull App image${NC}"
echo -e "${GREEN}✓ Images pulled${NC}"

# Step 7: Check if models directory exists
echo -e "${YELLOW}Step 6: Checking models directory...${NC}"
if [ ! -d "models" ]; then
    echo -e "${YELLOW}Models directory not found. Creating it...${NC}"
    mkdir -p models
    echo -e "${YELLOW}⚠️  WARNING: You need to copy your model file (yolov8n_best_model.pt) to ~/models/${NC}"
fi
echo -e "${GREEN}✓ Models directory ready${NC}"

# Step 8: Stop existing containers
echo -e "${YELLOW}Step 7: Stopping existing containers...${NC}"
if command -v docker-compose &> /dev/null; then
    docker-compose down 2>/dev/null || true
elif docker compose version &> /dev/null; then
    docker compose down 2>/dev/null || true
else
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest down 2>/dev/null || true
fi
echo -e "${GREEN}✓ Existing containers stopped${NC}"

# Step 9: Start containers
echo -e "${YELLOW}Step 8: Starting containers...${NC}"
if command -v docker-compose &> /dev/null; then
    docker-compose up -d
elif docker compose version &> /dev/null; then
    docker compose up -d
else
    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest up -d
fi
echo -e "${GREEN}✓ Containers started${NC}"

# Step 10: Wait for containers to be healthy
echo -e "${YELLOW}Step 9: Waiting for services to be ready...${NC}"
sleep 10

# Step 11: Check container status
echo -e "${YELLOW}Step 10: Checking container status...${NC}"
docker ps --filter "name=cotton_weed" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Step 12: Check logs
echo -e "${YELLOW}Step 11: Checking logs...${NC}"
echo -e "${GREEN}API Logs (last 10 lines):${NC}"
docker logs cotton_weed_api --tail 10 2>&1 || echo "API container not found"
echo ""
echo -e "${GREEN}App Logs (last 10 lines):${NC}"
docker logs cotton_weed_app --tail 10 2>&1 || echo "App container not found"

# Step 13: Get VM IP
echo -e "${YELLOW}Step 12: Getting VM IP address...${NC}"
VM_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google" 2>/dev/null || echo "Unable to get IP")
if [ "$VM_IP" != "Unable to get IP" ]; then
    echo -e "${GREEN}✓ VM IP: $VM_IP${NC}"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}🎉 Deployment Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "Your Streamlit app is now accessible at:"
    echo -e "  ${YELLOW}http://$VM_IP:8501${NC}"
    echo ""
    echo -e "API documentation:"
    echo -e "  ${YELLOW}http://$VM_IP:8000/docs${NC}"
    echo ""
    echo -e "API health check:"
    echo -e "  ${YELLOW}http://$VM_IP:8000/health${NC}"
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}"
else
    echo -e "${YELLOW}⚠️  Could not automatically get VM IP.${NC}"
    echo -e "Get it manually with:"
    echo -e "  gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'"
fi

# Step 14: Set up auto-start on boot
echo -e "${YELLOW}Step 13: Setting up auto-start on boot...${NC}"
if [ ! -f /etc/systemd/system/cotton-weed.service ]; then
    echo "Creating systemd service for auto-start..."
    $SUDO tee /etc/systemd/system/cotton-weed.service > /dev/null << EOF
[Unit]
Description=Cotton Weed Detection App
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$HOME
ExecStart=/usr/bin/docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME:$HOME -w $HOME docker/compose:latest up -d
ExecStop=/usr/bin/docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $HOME:$HOME -w $HOME docker/compose:latest down
User=$USER

[Install]
WantedBy=multi-user.target
EOF
    $SUDO systemctl daemon-reload
    $SUDO systemctl enable cotton-weed.service
    echo -e "${GREEN}✓ Auto-start service created and enabled${NC}"
else
    echo -e "${GREEN}✓ Auto-start service already exists${NC}"
fi

echo ""
echo -e "${GREEN}✅ Deployment complete! Your app will automatically start on VM boot.${NC}"

