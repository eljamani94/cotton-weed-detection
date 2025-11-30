# 🚀 Streamlit Deployment Scripts

This directory contains scripts to properly deploy your Streamlit app on Google Cloud VM.

## 📋 Scripts Overview

### 1. `deploy_streamlit_vm.sh`
**Main deployment script** - Run this on your VM to deploy the Streamlit app.

**What it does:**
- ✅ Checks and installs Docker if needed
- ✅ Sets up docker-compose
- ✅ Creates docker-compose.yml if missing
- ✅ Authenticates with GCP
- ✅ Pulls latest Docker images
- ✅ Starts containers
- ✅ Sets up auto-start on boot (systemd service)
- ✅ Shows access URLs

**Usage:**
```bash
chmod +x deploy_streamlit_vm.sh
./deploy_streamlit_vm.sh
```

### 2. `setup_firewall.sh`
**Firewall configuration** - Sets up Google Cloud firewall rules to allow access.

**What it does:**
- ✅ Creates firewall rule for port 8501 (Streamlit)
- ✅ Creates firewall rule for port 8000 (FastAPI)
- ✅ Allows access from anywhere (0.0.0.0/0)

**Usage:**
```bash
chmod +x setup_firewall.sh
./setup_firewall.sh
```

**Note:** Run this from your local machine or inside the VM. It uses `gcloud` commands.

### 3. `check_deployment.sh`
**Deployment verification** - Checks if your app is properly deployed.

**What it checks:**
- ✅ Docker is running
- ✅ Containers are running
- ✅ Ports are listening
- ✅ API health endpoint
- ✅ Streamlit accessibility
- ✅ VM IP address
- ✅ Shows access URLs

**Usage:**
```bash
chmod +x check_deployment.sh
./check_deployment.sh
```

### 4. `deploy_to_vm.bat` (Windows)
**Helper script for Windows** - Copies deployment scripts to VM.

**What it does:**
- ✅ Copies all deployment scripts to VM
- ✅ Copies models folder (if exists)
- ✅ Provides next steps instructions

**Usage:**
```powershell
.\scripts\deploy_to_vm.bat
```

---

## 🎯 Quick Deployment Guide

### Step 1: Copy Scripts to VM

**From your local machine (PowerShell):**

```powershell
# Option A: Use the helper script
.\scripts\deploy_to_vm.bat

# Option B: Manual copy
gcloud compute scp scripts/deploy_streamlit_vm.sh cotton-weed-vm:~ --zone=us-central1-a
gcloud compute scp scripts/check_deployment.sh cotton-weed-vm:~ --zone=us-central1-a
gcloud compute scp scripts/setup_firewall.sh cotton-weed-vm:~ --zone=us-central1-a
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
```

### Step 2: SSH into VM

```powershell
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

### Step 3: Set Up Firewall (First Time Only)

**Inside the VM:**

```bash
chmod +x setup_firewall.sh
./setup_firewall.sh
```

**Or from local machine:**

```powershell
gcloud compute firewall-rules create allow-streamlit-app --allow tcp:8501 --source-ranges 0.0.0.0/0
gcloud compute firewall-rules create allow-fastapi --allow tcp:8000 --source-ranges 0.0.0.0/0
```

### Step 4: Deploy Application

**Inside the VM:**

```bash
chmod +x deploy_streamlit_vm.sh
./deploy_streamlit_vm.sh
```

### Step 5: Verify Deployment

**Inside the VM:**

```bash
chmod +x check_deployment.sh
./check_deployment.sh
```

---

## 📍 Access Your App

After deployment, the script will show you the VM IP. Access your app at:

- **Streamlit App:** `http://YOUR_VM_IP:8501`
- **API Docs:** `http://YOUR_VM_IP:8000/docs`
- **API Health:** `http://YOUR_VM_IP:8000/health`

---

## 🔄 After VM Restart

The deployment script sets up auto-start, so containers should start automatically. To verify:

```bash
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Check status
./check_deployment.sh

# Or manually
docker ps
```

If containers aren't running:

```bash
cd ~
docker-compose up -d
```

---

## 🛠️ Troubleshooting

### Scripts Not Executable

```bash
chmod +x *.sh
```

### Containers Not Starting

```bash
# Check logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Restart
cd ~
docker-compose restart
```

### Can't Access from Browser

1. Check firewall rules:
   ```powershell
   gcloud compute firewall-rules list
   ```

2. Check containers:
   ```bash
   docker ps
   ```

3. Get VM IP:
   ```powershell
   gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
   ```

---

## 📚 More Information

- See `STREAMLIT_DEPLOYMENT.md` for detailed deployment guide
- See `COMPLETE_WORKFLOW.md` for complete workflow documentation

---

**🎉 Your Streamlit app is now properly deployed and accessible!**

