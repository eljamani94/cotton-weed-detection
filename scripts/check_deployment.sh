#!/bin/bash
# Deployment Status Check Script
# Checks if your Streamlit app is properly deployed and accessible

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🔍 Checking deployment status...${NC}"
echo ""

# Check Docker
echo -e "${YELLOW}1. Checking Docker...${NC}"
if command -v docker &> /dev/null && docker ps &> /dev/null; then
    echo -e "${GREEN}✓ Docker is running${NC}"
else
    echo -e "${RED}✗ Docker is not running${NC}"
    exit 1
fi

# Check containers
echo -e "${YELLOW}2. Checking containers...${NC}"
API_CONTAINER=$(docker ps --filter "name=cotton_weed_api" --format "{{.Names}}" | head -1)
APP_CONTAINER=$(docker ps --filter "name=cotton_weed_app" --format "{{.Names}}" | head -1)

if [ -n "$API_CONTAINER" ]; then
    echo -e "${GREEN}✓ API container is running: $API_CONTAINER${NC}"
    API_STATUS=$(docker inspect --format='{{.State.Status}}' $API_CONTAINER)
    echo "  Status: $API_STATUS"
else
    echo -e "${RED}✗ API container is not running${NC}"
fi

if [ -n "$APP_CONTAINER" ]; then
    echo -e "${GREEN}✓ App container is running: $APP_CONTAINER${NC}"
    APP_STATUS=$(docker inspect --format='{{.State.Status}}' $APP_CONTAINER)
    echo "  Status: $APP_STATUS"
else
    echo -e "${RED}✗ App container is not running${NC}"
fi

# Check ports
echo -e "${YELLOW}3. Checking ports...${NC}"
if netstat -tuln 2>/dev/null | grep -q ":8000"; then
    echo -e "${GREEN}✓ Port 8000 (API) is listening${NC}"
else
    echo -e "${RED}✗ Port 8000 (API) is not listening${NC}"
fi

if netstat -tuln 2>/dev/null | grep -q ":8501"; then
    echo -e "${GREEN}✓ Port 8501 (Streamlit) is listening${NC}"
else
    echo -e "${RED}✗ Port 8501 (Streamlit) is not listening${NC}"
fi

# Check API health
echo -e "${YELLOW}4. Checking API health...${NC}"
if [ -n "$API_CONTAINER" ]; then
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo -e "${GREEN}✓ API is responding${NC}"
        curl -s http://localhost:8000/health | head -1
    else
        echo -e "${RED}✗ API is not responding${NC}"
    fi
else
    echo -e "${YELLOW}⚠ API container not running, skipping health check${NC}"
fi

# Check Streamlit
echo -e "${YELLOW}5. Checking Streamlit app...${NC}"
if [ -n "$APP_CONTAINER" ]; then
    if curl -s http://localhost:8501 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Streamlit app is responding${NC}"
    else
        echo -e "${RED}✗ Streamlit app is not responding${NC}"
    fi
else
    echo -e "${YELLOW}⚠ App container not running, skipping check${NC}"
fi

# Get VM IP
echo -e "${YELLOW}6. Getting VM IP address...${NC}"
VM_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google" 2>/dev/null || echo "")
if [ -n "$VM_IP" ]; then
    echo -e "${GREEN}✓ VM IP: $VM_IP${NC}"
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}Access URLs:${NC}"
    echo -e "  Streamlit App: ${GREEN}http://$VM_IP:8501${NC}"
    echo -e "  API Docs:      ${GREEN}http://$VM_IP:8000/docs${NC}"
    echo -e "  API Health:    ${GREEN}http://$VM_IP:8000/health${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
else
    echo -e "${YELLOW}⚠ Could not get VM IP automatically${NC}"
    echo "Get it manually with:"
    echo "  gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'"
fi

# Check logs for errors
echo ""
echo -e "${YELLOW}7. Recent logs (last 5 lines)...${NC}"
if [ -n "$API_CONTAINER" ]; then
    echo -e "${BLUE}API logs:${NC}"
    docker logs $API_CONTAINER --tail 5 2>&1 | tail -5
fi
if [ -n "$APP_CONTAINER" ]; then
    echo -e "${BLUE}App logs:${NC}"
    docker logs $APP_CONTAINER --tail 5 2>&1 | tail -5
fi

echo ""
if [ -n "$API_CONTAINER" ] && [ -n "$APP_CONTAINER" ]; then
    echo -e "${GREEN}✅ Deployment looks good!${NC}"
else
    echo -e "${RED}❌ Deployment has issues. Check the errors above.${NC}"
    echo ""
    echo "To fix, run:"
    echo "  cd ~"
    echo "  ./scripts/deploy_streamlit_vm.sh"
fi

