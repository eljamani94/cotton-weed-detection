# 🚀 Google Cloud Deployment - Step by Step Guide

## ✅ What You've Completed So Far

- ✅ Local development environment set up
- ✅ Model integrated and working
- ✅ API and Streamlit app working locally
- ✅ Docker containers working perfectly
- ✅ Ready for cloud deployment!

## 📋 Phase 3: Google Cloud Deployment

### Prerequisites Checklist

Before starting, make sure you have:
- [ ] Google Cloud account (sign up at https://cloud.google.com)
- [ ] $300 free trial activated
- [ ] Google Cloud SDK installed (we'll do this)
- [ ] Docker Desktop running (you already have this ✅)

---

## Step 1: Install Google Cloud SDK

### Windows Installation:

1. **Download Google Cloud SDK:**
   - Go to: https://cloud.google.com/sdk/docs/install
   - Download the Windows installer
   - Run the installer (it will install to `C:\Program Files (x86)\Google\Cloud SDK\`)

2. **Verify Installation:**
   Open PowerShell and run:
   ```powershell
   gcloud --version
   ```
   
   You should see version information. If not, restart your terminal.

3. **Initialize gcloud:**
   ```powershell
   gcloud init
   ```
   
   This will:
   - Ask you to log in (opens browser)
   - Ask you to select/create a project
   - Set default region

---

## Step 2: Create GCP Project

### Option A: Using gcloud CLI (Recommended)

```powershell
# Login to Google Cloud
gcloud auth login

# Create a new project (replace with your preferred name)
gcloud projects create cotton-weed-detection --name="Cotton Weed Detection"

# Set as active project
gcloud config set project cotton-weed-detection
```

### ⚠️ IMPORTANT: Enable Billing First!

**Before enabling APIs, you MUST enable billing on your project:**

1. **Go to Google Cloud Console:**
   - Visit: https://console.cloud.google.com/billing
   - Or: https://console.cloud.google.com → Billing

2. **Link Billing Account:**
   - Click "Link a billing account"
   - If you don't have one, click "Create billing account"
   - Enter payment information (credit card required)
   - **Don't worry!** You get $300 free credit that will be used first
   - Select your project: `cotton-weed-detection`
   - Click "Set account"

3. **Verify Billing is Enabled:**
   ```powershell
   gcloud billing projects describe cotton-weed-detection
   ```
   
   You should see a billing account ID. If not, billing isn't linked yet.

### Now Enable Required APIs:

```powershell
# Enable required APIs (now that billing is enabled)
gcloud services enable compute.googleapis.com
gcloud services enable containerregistry.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

### Option B: Using Google Cloud Console (Web UI)

1. Go to: https://console.cloud.google.com
2. Click "Select a project" → "New Project"
3. Enter project name: `cotton-weed-detection`
4. Click "Create"
5. Wait for project creation

6. **Enable Billing (REQUIRED):**
   - Go to: https://console.cloud.google.com/billing
   - Click "Link a billing account"
   - If no billing account exists, create one
   - Enter payment information (you get $300 free credit!)
   - Link it to your project

7. **Enable APIs:**
   - Go to "APIs & Services" → "Library"
   - Search and enable:
     - Compute Engine API
     - Container Registry API
     - Artifact Registry API

---

## Step 3: Set Up Docker for GCP

Configure Docker to push images to Google Cloud:

```powershell
# Configure Docker authentication
gcloud auth configure-docker

# This allows Docker to push/pull images from Google Container Registry
```

---

## Step 4: Build and Push Docker Images

**Important:** Replace `cotton-weed-detection` with your actual project ID if different!

```powershell
# Get your project ID
gcloud config get-value project

# Build API image
docker build -f docker/Dockerfile.api -t gcr.io/cotton-weed-detection/api:latest .

# Build App image  
docker build -f docker/Dockerfile.app -t gcr.io/cotton-weed-detection/app:latest .

# Push API image (this may take a few minutes)
docker push gcr.io/cotton-weed-detection/api:latest

# Push App image (this may take a few minutes)
docker push gcr.io/cotton-weed-detection/app:latest
```

**Note:** First push will be slower (uploading ~2GB of images). Subsequent pushes are faster.

---

## Step 5: Create VM Instance

### Using gcloud CLI:

```powershell
# Create VM instance
gcloud compute instances create cotton-weed-vm `
    --zone=us-central1-a `
    --machine-type=e2-medium `
    --image-family=cos-stable `
    --image-project=cos-cloud `
    --boot-disk-size=30GB `
    --tags=http-server

# Allow HTTP traffic on ports 8000 and 8501
gcloud compute firewall-rules create allow-cotton-weed `
    --allow tcp:8501,tcp:8000 `
    --source-ranges 0.0.0.0/0 `
    --target-tags http-server `
    --description "Allow HTTP traffic for Cotton Weed Detection app"
```

### Using Google Cloud Console (Web UI):

1. Go to: https://console.cloud.google.com/compute/instances
2. Click "Create Instance"
3. Configure:
   - **Name:** `cotton-weed-vm`
   - **Region:** `us-central1`
   - **Zone:** `us-central1-a`
   - **Machine type:** `e2-medium` (2 vCPU, 4GB RAM)
   - **Boot disk:** 30GB
   - **Firewall:** Check "Allow HTTP traffic"
4. Click "Create"
5. Wait for VM to start (2-3 minutes)

---

## Step 6: Install Docker on VM

SSH into your VM and install Docker:

```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Once inside the VM, install Docker:
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Log out and back in for group changes to take effect
exit
```

---

## Step 7: Deploy Application on VM

### On your local machine, create a deployment docker-compose file:

Create a new file `docker-compose.prod.yml`:

```yaml
services:
  api:
    image: gcr.io/cotton-weed-detection/api:latest
    container_name: cotton_weed_api
    ports:
      - "8000:8000"
    volumes:
      - ./models:/app/models
    environment:
      - PYTHONUNBUFFERED=1
    restart: unless-stopped

  app:
    image: gcr.io/cotton-weed-detection/app:latest
    container_name: cotton_weed_app
    ports:
      - "8501:8501"
    depends_on:
      - api
    environment:
      - API_URL=http://api:8000
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
```

### Copy files to VM:

```powershell
# Copy docker-compose file
gcloud compute scp docker-compose.prod.yml cotton-weed-vm:~/docker-compose.yml --zone=us-central1-a

# Copy models folder (IMPORTANT: Your trained model!)
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
```

### On the VM (SSH in again):

```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Pull Docker images
docker pull gcr.io/cotton-weed-detection/api:latest
docker pull gcr.io/cotton-weed-detection/app:latest

# Start containers
docker-compose up -d

# Check if containers are running
docker ps

# View logs
docker logs cotton_weed_api
docker logs cotton_weed_app
```

---

## Step 8: Get Your Public IP and Access App

### Get VM External IP:

```powershell
# From your local machine
gcloud compute instances describe cotton-weed-vm `
    --zone=us-central1-a `
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

Or check in Google Cloud Console:
- Go to Compute Engine → VM instances
- Find `cotton-weed-vm`
- Copy the "External IP"

### Access Your Application:

- **Streamlit App:** `http://<EXTERNAL_IP>:8501`
- **API Docs:** `http://<EXTERNAL_IP>:8000/docs`
- **API Health:** `http://<EXTERNAL_IP>:8000/health`

**Note:** It may take 1-2 minutes for containers to fully start.

---

## Step 9: Test from Your Phone

1. Find your VM's external IP (from Step 8)
2. On your phone (anywhere with internet):
   - Open browser: `http://<EXTERNAL_IP>:8501`
   - Test camera functionality
   - Take a photo and see predictions!

---

## 💰 Cost Management

### Estimated Monthly Costs:
- **e2-medium VM:** ~$30-40/month (if running 24/7)
- **Storage (30GB):** ~$1/month
- **Network egress:** ~$0.12/GB (first 1GB free)

### Cost Saving Tips:

1. **Stop VM when not in use:**
   ```powershell
   gcloud compute instances stop cotton-weed-vm --zone=us-central1-a
   ```
   You only pay for storage (~$1/month) when stopped.

2. **Start VM when needed:**
   ```powershell
   gcloud compute instances start cotton-weed-vm --zone=us-central1-a
   ```

3. **Use Preemptible VMs** (80% cheaper, but can be stopped by Google):
   - Add `--preemptible` flag when creating VM
   - Good for testing, not production

4. **Set up billing alerts:**
   - Go to: https://console.cloud.google.com/billing
   - Set alert at $50, $100, etc.

---

## 🔧 Troubleshooting

### VM won't start:
```powershell
# Check VM status
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a

# View VM logs
gcloud compute instances get-serial-port-output cotton-weed-vm --zone=us-central1-a
```

### Containers not running:
```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Check container status
docker ps -a

# View logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Restart containers
docker-compose restart
```

### Can't access from internet:
1. Check firewall rules:
   ```powershell
   gcloud compute firewall-rules list
   ```
2. Verify VM has external IP
3. Check if ports 8000 and 8501 are open

### Model not loading:
- Verify models folder was copied to VM
- Check file permissions: `ls -la ~/models/`
- Check API logs: `docker logs cotton_weed_api`

---

## 📝 Quick Reference Commands

```powershell
# Start VM
gcloud compute instances start cotton-weed-vm --zone=us-central1-a

# Stop VM
gcloud compute instances stop cotton-weed-vm --zone=us-central1-a

# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Get VM IP
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'

# View VM logs
gcloud compute instances get-serial-port-output cotton-weed-vm --zone=us-central1-a
```

---

## 🎉 Success Checklist

- [ ] Google Cloud SDK installed
- [ ] GCP project created
- [ ] Docker images built and pushed
- [ ] VM instance created
- [ ] Docker installed on VM
- [ ] Application deployed
- [ ] Can access from browser
- [ ] Can access from phone
- [ ] Predictions working!

---

## 🚀 Next Steps (Optional Enhancements)

1. **Set up custom domain:**
   - Buy domain (e.g., cottonweed.app)
   - Point DNS to VM IP
   - Set up SSL certificate

2. **Add monitoring:**
   - Google Cloud Monitoring
   - Set up alerts

3. **Backup strategy:**
   - Regular model backups
   - Database backups

4. **CI/CD Pipeline:**
   - Auto-deploy on code changes
   - Automated testing

5. **Scaling:**
   - Load balancer
   - Multiple VM instances
   - Auto-scaling

---

**Ready to deploy? Start with Step 1!** 🚀

If you encounter any issues, check the troubleshooting section or let me know!

