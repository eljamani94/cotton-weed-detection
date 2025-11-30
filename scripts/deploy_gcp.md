# Google Cloud Platform Deployment Guide

This guide will walk you through deploying the Cotton Weed Detection app to Google Cloud Platform.

## Prerequisites

1. Google Cloud account with $300 free trial activated
2. Google Cloud SDK (gcloud) installed
3. Docker installed locally (for building images)

## Step 1: Install Google Cloud SDK

### Windows:
1. Download from: https://cloud.google.com/sdk/docs/install
2. Run the installer
3. Open PowerShell and run: `gcloud init`

### Verify installation:
```bash
gcloud --version
```

## Step 2: Create GCP Project

```bash
# Login to Google Cloud
gcloud auth login

# Create a new project (or use existing)
gcloud projects create cotton-weed-detection --name="Cotton Weed Detection"

# Set as active project
gcloud config set project cotton-weed-detection

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
```

## Step 3: Set Up Docker for GCP

```bash
# Configure Docker to use gcloud as credential helper
gcloud auth configure-docker
```

## Step 4: Build and Push Docker Images

```bash
# Build API image
docker build -f docker/Dockerfile.api -t gcr.io/cotton-weed-detection/api:latest .

# Build App image
docker build -f docker/Dockerfile.app -t gcr.io/cotton-weed-detection/app:latest .

# Push images to Google Container Registry
docker push gcr.io/cotton-weed-detection/api:latest
docker push gcr.io/cotton-weed-detection/app:latest
```

## Step 5: Create VM Instance

### Option A: Using gcloud command

```bash
# Create VM instance
gcloud compute instances create cotton-weed-vm \
    --zone=us-central1-a \
    --machine-type=e2-medium \
    --image-family=cos-stable \
    --image-project=cos-cloud \
    --boot-disk-size=20GB \
    --tags=http-server,https-server

# Allow HTTP traffic
gcloud compute firewall-rules create allow-http \
    --allow tcp:8501,tcp:8000 \
    --source-ranges 0.0.0.0/0 \
    --target-tags http-server
```

### Option B: Using Google Cloud Console

1. Go to Compute Engine > VM instances
2. Click "Create Instance"
3. Configure:
   - Name: `cotton-weed-vm`
   - Region: `us-central1`
   - Machine type: `e2-medium` (2 vCPU, 4GB RAM)
   - Boot disk: 20GB
   - Firewall: Allow HTTP and HTTPS traffic
4. Click "Create"

## Step 6: Install Docker on VM

```bash
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Install Docker (on the VM)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Step 7: Deploy Application

### On your local machine, create deployment files:

```bash
# Copy docker-compose.yml to VM
gcloud compute scp docker-compose.yml cotton-weed-vm:~/ --zone=us-central1-a

# Copy models folder (if needed)
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
```

### On the VM:

```bash
# Pull images
docker pull gcr.io/cotton-weed-detection/api:latest
docker pull gcr.io/cotton-weed-detection/app:latest

# Update docker-compose.yml to use pulled images
# Then run:
docker-compose up -d
```

## Step 8: Get External IP

```bash
# Get VM external IP
gcloud compute instances describe cotton-weed-vm \
    --zone=us-central1-a \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

Access your app at: `http://<EXTERNAL_IP>:8501`

## Step 9: Set Up Domain (Optional)

1. Go to Cloud DNS or use your domain provider
2. Create A record pointing to VM external IP
3. Set up SSL certificate (Let's Encrypt or Google-managed)

## Cost Optimization Tips

1. **Use Preemptible VMs**: Save up to 80% on compute costs
2. **Stop VM when not in use**: Only pay for storage
3. **Use smaller machine types**: Start with e2-small, scale up if needed
4. **Monitor usage**: Set up billing alerts

## Troubleshooting

### Check VM logs:
```bash
gcloud compute instances get-serial-port-output cotton-weed-vm --zone=us-central1-a
```

### Check Docker containers:
```bash
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
docker ps
docker logs cotton-weed-api
docker logs cotton-weed-app
```

### Restart services:
```bash
docker-compose restart
```

## Next Steps

- Set up monitoring and logging
- Configure auto-scaling
- Set up CI/CD pipeline
- Add authentication/authorization
- Set up backup for model files

