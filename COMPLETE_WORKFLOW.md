# 🚀 Complete Workflow Guide - Local & Cloud

This guide shows you how to run your Cotton Weed Detection app both locally and on Google Cloud, even after restarting your laptop or stopping the VM.

---

## 📋 Table of Contents

1. [Quick Start - Local Development](#quick-start---local-development)
2. [Quick Start - Cloud Deployment](#quick-start---cloud-deployment)
3. [Demo Preparation Checklist](#demo-preparation-checklist)
4. [Troubleshooting](#troubleshooting)

---

## 🖥️ Quick Start - Local Development

### First Time Setup (One-time only)

1. **Activate Virtual Environment:**
   ```powershell
   .\cotton_weed\Scripts\activate.bat
   ```

2. **Verify Dependencies:**
   ```powershell
   pip list | findstr "streamlit fastapi torch ultralytics"
   ```

### Starting the Application Locally

#### Option A: Using Scripts (Easiest)

**Terminal 1 - Start API:**
```powershell
.\scripts\start_api.bat
```

**Terminal 2 - Start App:**
```powershell
.\scripts\start_app.bat
```

#### Option B: Manual Start

**Terminal 1 - Start API:**
```powershell
.\cotton_weed\Scripts\activate.bat
uvicorn api.main:app --reload --host 0.0.0.0 --port 8000
```

**Terminal 2 - Start App:**
```powershell
.\cotton_weed\Scripts\activate.bat
streamlit run app/main.py --server.port 8501
```

### Access Local Application:

- **Streamlit App:** http://localhost:8501
- **API Docs:** http://localhost:8000/docs
- **API Health:** http://localhost:8000/health

### Stopping Local Application:

Press `Ctrl+C` in both terminal windows.

---

## ☁️ Quick Start - Cloud Deployment

### 🚀 First Time Deployment (One-time Setup)

#### Step 1: Set Up Firewall Rules (From Local Machine)

From your local machine (PowerShell), run:

```powershell
# Copy firewall setup script to VM
gcloud compute scp scripts/setup_firewall.sh cotton-weed-vm:~ --zone=us-central1-a

# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Inside VM, run:
chmod +x setup_firewall.sh
./setup_firewall.sh
```

Or manually create firewall rules from your local machine:

```powershell
# Allow Streamlit (port 8501)
gcloud compute firewall-rules create allow-streamlit-app --allow tcp:8501 --source-ranges 0.0.0.0/0 --description "Allow access to Streamlit app"

# Allow FastAPI (port 8000)
gcloud compute firewall-rules create allow-fastapi --allow tcp:8000 --source-ranges 0.0.0.0/0 --description "Allow access to FastAPI backend"
```

#### Step 2: Deploy the Application

**Option A: Using the Deployment Script (Recommended)**

```powershell
# From local machine, copy deployment script to VM
gcloud compute scp scripts/deploy_streamlit_vm.sh cotton-weed-vm:~ --zone=us-central1-a

# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Inside VM, run:
chmod +x deploy_streamlit_vm.sh
./deploy_streamlit_vm.sh
```

This script will:
- ✅ Check and install Docker if needed
- ✅ Set up docker-compose
- ✅ Create docker-compose.yml if missing
- ✅ Pull latest Docker images
- ✅ Start containers
- ✅ Set up auto-start on boot
- ✅ Show you the access URLs

**Option B: Manual Deployment**

```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

Inside the VM:

```bash
# Navigate to home directory
cd ~

# Set up docker-compose alias (add to ~/.bashrc for persistence)
echo 'alias docker-compose="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v \"\$PWD:\$PWD\" -w \"\$PWD\" docker/compose:latest"' >> ~/.bashrc
source ~/.bashrc

# Authenticate with GCP
gcloud auth configure-docker

# Pull images
docker pull gcr.io/cotton-weed-detection-app/api:latest
docker pull gcr.io/cotton-weed-detection-app/app:latest

# Create docker-compose.yml (if not exists)
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

  app:
    image: gcr.io/cotton-weed-detection-app/app:latest
    container_name: cotton_weed_app
    ports:
      - "8501:8501"
    depends_on:
      - api
    environment:
      - API_URL=http://api:8000
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
EOF

# Copy models folder (from local machine, in new PowerShell window)
# gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a

# Start containers
docker-compose up -d

# Verify containers are running
docker ps
```

#### Step 3: Verify Deployment

Inside the VM:

```bash
# Check deployment status
chmod +x scripts/check_deployment.sh
./scripts/check_deployment.sh
```

Or manually:

```bash
# Check containers
docker ps

# Check logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Test API
curl http://localhost:8000/health

# Test Streamlit
curl http://localhost:8501
```

---

### 🔄 Starting the VM (After It's Been Stopped)

#### Step 1: Start the VM

From your local machine (PowerShell):

```powershell
# Start the VM
gcloud compute instances start cotton-weed-vm --zone=us-central1-a

# Wait 1-2 minutes for VM to boot, then check status
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(status)'
```

#### Step 2: Get the VM's IP Address

```powershell
# Get external IP (might have changed if VM was stopped)
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

**Note:** The IP might change if the VM was stopped. Save the new IP!

#### Step 3: Verify Containers Are Running

If you used the deployment script, containers should start automatically. To verify:

```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

Inside VM:

```bash
# Check if containers are running
docker ps

# If not running, start them
cd ~
docker-compose up -d

# Or use the deployment script
./deploy_streamlit_vm.sh
```

### Access Cloud Application:

Use the IP address from Step 2:
- **Streamlit App:** http://YOUR_VM_IP:8501
- **API Docs:** http://YOUR_VM_IP:8000/docs
- **API Health:** http://YOUR_VM_IP:8000/health

### Stopping the VM (To Save Costs)

```powershell
# Stop VM (from your local machine)
gcloud compute instances stop cotton-weed-vm --zone=us-central1-a
```

**Note:** When you stop the VM, the IP address might change. Always get the new IP after starting.

---

## 🎯 Demo Preparation Checklist

### Before Your Demo:

#### Local Demo:
- [ ] Laptop is charged/plugged in
- [ ] Virtual environment activated
- [ ] API running (Terminal 1)
- [ ] App running (Terminal 2)
- [ ] Test with a sample image
- [ ] Have backup images ready
- [ ] Test camera access (if using phone on same network)

#### Cloud Demo:
- [ ] VM is started
- [ ] Containers are running (`docker ps` shows both containers)
- [ ] Have the current VM IP address
- [ ] Test access from browser
- [ ] Test from phone (if needed)
- [ ] Have backup: local version ready as fallback

### Quick Demo Script:

1. **Open the application** (local or cloud URL)
2. **Show the interface:**
   - "This is our Cotton Weed Detection application"
   - "It uses YOLOv8 deep learning model"
3. **Upload an image:**
   - Click "Upload Image" or use camera
   - Show bounding boxes and class labels
4. **Explain the results:**
   - "The model detected X weeds"
   - "Classes: carpetweed, morningglory, palmer_amaranth"
   - "Confidence scores shown"
5. **Show API documentation:**
   - Open `/docs` endpoint
   - Show the API structure

---

## 🔧 Troubleshooting

### Local Issues:

#### "Module not found" errors:
```powershell
# Reactivate virtual environment
.\cotton_weed\Scripts\activate.bat

# Reinstall if needed
pip install -r requirements.txt
```

#### Port already in use:
```powershell
# Find what's using the port
netstat -ano | findstr :8000
netstat -ano | findstr :8501

# Kill the process or use different ports
```

#### API not connecting:
- Check API is running: http://localhost:8000/health
- Check API URL in Streamlit sidebar
- Verify both terminals are running

### Cloud Issues:

#### Can't SSH into VM:
```powershell
# Check VM status
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a

# If stopped, start it
gcloud compute instances start cotton-weed-vm --zone=us-central1-a
```

#### Containers not running:
```bash
# SSH into VM, then:
docker ps -a  # Check all containers

# Restart containers
docker-compose restart

# Or recreate them
docker-compose down
docker-compose up -d
```

#### Can't access from browser:
1. **Check VM is running:**
   ```powershell
   gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(status)'
   ```

2. **Get current IP:**
   ```powershell
   gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
   ```

3. **Check firewall rules:**
   ```powershell
   gcloud compute firewall-rules list
   ```

4. **Check containers are running:**
   ```bash
   # In VM
   docker ps
   docker logs cotton_weed_api
   docker logs cotton_weed_app
   ```

#### Model not loading:
```bash
# In VM, check models folder
ls -la ~/models/

# Verify model file exists
ls -la ~/models/yolov8n_best_model.pt

# Check API logs
docker logs cotton_weed_api | grep -i model
```

---

## 📝 Quick Reference Commands

### Local Commands:

```powershell
# Activate environment
.\cotton_weed\Scripts\activate.bat

# Start API
.\scripts\start_api.bat

# Start App
.\scripts\start_app.bat

# Stop (Ctrl+C in each terminal)
```

### Cloud Commands:

```powershell
# Start VM
gcloud compute instances start cotton-weed-vm --zone=us-central1-a

# Stop VM
gcloud compute instances stop cotton-weed-vm --zone=us-central1-a

# Get VM IP
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'

# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

### VM Commands (Inside VM):

```bash
# Set docker-compose alias
alias docker-compose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest'

# Start containers
cd ~
docker-compose up -d

# Check status
docker ps

# View logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Restart containers
docker-compose restart

# Stop containers
docker-compose down
```

---

## 📷 Camera Access Issue

**Important:** Browsers require HTTPS for camera access. Your app runs on HTTP, so camera won't work by default.

### Quick Fix for Demo:

**Option 1: Browser Flags (Quick)**
- See `CAMERA_FIX.md` for browser-specific instructions
- Enable camera on HTTP for testing

**Option 2: Use ngrok (Recommended)**
- Creates HTTPS tunnel to your HTTP server
- See `scripts/setup_ngrok.md` for setup
- Camera works automatically with HTTPS URL

**For your demo:** Use ngrok to get an HTTPS URL - it's the cleanest solution!

---

## 🎓 For Your Teachers - Demo Guide

### What to Show:

1. **Introduction:**
   - "This is an MLOps application for cotton weed detection"
   - "Built with Streamlit frontend, FastAPI backend, deployed on Google Cloud"

2. **Architecture:**
   - Show the project structure
   - Explain Docker containers
   - Show Google Cloud deployment

3. **Live Demo:**
   - Upload an image
   - Show real-time predictions
   - Explain bounding boxes and classes

4. **Technical Details:**
   - YOLOv8 model
   - API endpoints
   - Real-time sync capability
   - Cloud deployment

### Backup Plan:

- Have local version ready as backup
- Have screenshots/videos ready
- Have the application URL saved
- Test everything 15 minutes before demo

---

## ✅ Pre-Demo Checklist (5 Minutes Before)

### Local:
- [ ] Both terminals running
- [ ] http://localhost:8501 opens
- [ ] Test image upload works
- [ ] API health check passes

### Cloud:
- [ ] VM is running
- [ ] Containers are running
- [ ] Current IP address saved
- [ ] Application accessible from browser
- [ ] Test image upload works

---

## 🚨 Emergency Fixes

### If Local Fails:
1. Stop everything (Ctrl+C)
2. Reactivate virtual environment
3. Restart both services
4. Check ports aren't in use

### If Cloud Fails:
1. Check VM is running
2. SSH into VM
3. Check containers: `docker ps`
4. Restart containers: `docker-compose restart`
5. Check logs: `docker logs cotton_weed_api`

### If Everything Fails:
- Use local version as backup
- Have screenshots ready
- Explain the architecture even if demo doesn't work

---

**Remember:** Always test 15 minutes before your demo! 🎯

