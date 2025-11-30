#!/bin/bash
# Firewall Rules Setup for Streamlit App
# This script sets up Google Cloud firewall rules to allow access to your app

set -e

echo "🔥 Setting up firewall rules..."

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    echo -e "${RED}gcloud CLI is not installed. Please install it first.${NC}"
    exit 1
fi

# Get project ID
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
if [ -z "$PROJECT_ID" ]; then
    echo -e "${RED}No GCP project set. Please run: gcloud config set project YOUR_PROJECT_ID${NC}"
    exit 1
fi

echo -e "${YELLOW}Project: $PROJECT_ID${NC}"

# Function to create firewall rule if it doesn't exist
create_firewall_rule() {
    local rule_name=$1
    local port=$2
    local description=$3
    
    if gcloud compute firewall-rules describe "$rule_name" --project="$PROJECT_ID" &>/dev/null; then
        echo -e "${GREEN}✓ Firewall rule '$rule_name' already exists${NC}"
    else
        echo -e "${YELLOW}Creating firewall rule '$rule_name'...${NC}"
        gcloud compute firewall-rules create "$rule_name" \
            --allow tcp:$port \
            --source-ranges 0.0.0.0/0 \
            --description "$description" \
            --project="$PROJECT_ID"
        echo -e "${GREEN}✓ Firewall rule '$rule_name' created${NC}"
    fi
}

# Create firewall rules
echo -e "${YELLOW}Creating firewall rules...${NC}"

# Port 8501 for Streamlit
create_firewall_rule "allow-streamlit-app" "8501" "Allow access to Streamlit app"

# Port 8000 for FastAPI
create_firewall_rule "allow-fastapi" "8000" "Allow access to FastAPI backend"

echo ""
echo -e "${GREEN}✅ Firewall rules setup complete!${NC}"
echo ""
echo "Your firewall rules:"
gcloud compute firewall-rules list --filter="name~allow-streamlit OR name~allow-fastapi" --format="table(name,allowed[].map().firewall_rule().list():label=ALLOW,sourceRanges.list():label=SRC_RANGES)"

