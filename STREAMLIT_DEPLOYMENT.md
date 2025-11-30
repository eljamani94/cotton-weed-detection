# 🚀 Streamlit App Deployment Guide

This guide shows you how to properly deploy your Streamlit app on Google Cloud VM so it's accessible and runs automatically.

---

## 🎯 Quick Deployment (Recommended)

### Step 1: Set Up Firewall Rules

**From your local machine (PowerShell):**

```powershell
# Copy firewall setup script to VM
gcloud compute scp scripts/setup_firewall.sh cotton-weed-vm:~ --zone=us-central1-a

# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

**Inside the VM:**

```bash
chmod +x setup_firewall.sh
./setup_firewall.sh
```

This creates firewall rules to allow access to ports 8501 (Streamlit) and 8000 (FastAPI).

### Step 2: Deploy the Application

**From your local machine (PowerShell):**

```powershell
# Copy deployment script to VM
gcloud compute scp scripts/deploy_streamlit_vm.sh cotton-weed-vm:~ --zone=us-central1-a

# Copy check script too
gcloud compute scp scripts/check_deployment.sh cotton-weed-vm:~ --zone=us-central1-a

# Make sure models folder is on VM (if not already)
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a

# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

**Inside the VM:**

```bash
# Make scripts executable
chmod +x deploy_streamlit_vm.sh check_deployment.sh

# Run deployment script
./deploy_streamlit_vm.sh
```

The deployment script will:
- ✅ Check Docker installation
- ✅ Set up docker-compose
- ✅ Create docker-compose.yml
- ✅ Pull latest Docker images
- ✅ Start containers
- ✅ Set up auto-start on boot
- ✅ Display access URLs

### Step 3: Verify Deployment

```bash
# Check deployment status
./check_deployment.sh
```

This will show you:
- Container status
- Port availability
- API health
- Streamlit accessibility
- VM IP address
- Access URLs

---

## 📍 Access Your App

After deployment, you'll get the VM IP address. Access your app at:

- **Streamlit App:** `http://YOUR_VM_IP:8501`
- **API Documentation:** `http://YOUR_VM_IP:8000/docs`
- **API Health Check:** `http://YOUR_VM_IP:8000/health`

To get the IP address:

```powershell
# From local machine
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

Or inside the VM:

```bash
curl http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google"
```

---

## 🔄 After VM Restart

When you restart the VM, the containers should start automatically (thanks to the systemd service). To verify:

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

## 🛠️ Manual Deployment (Alternative)

If you prefer to deploy manually:

### 1. SSH into VM

```powershell
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

### 2. Set Up Docker Compose

```bash
# Add alias to .bashrc
echo 'alias docker-compose="docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v \"\$PWD:\$PWD\" -w \"\$PWD\" docker/compose:latest"' >> ~/.bashrc
source ~/.bashrc
```

### 3. Authenticate with GCP

```bash
gcloud auth configure-docker
```

### 4. Pull Images

```bash
docker pull gcr.io/cotton-weed-detection-app/api:latest
docker pull gcr.io/cotton-weed-detection-app/app:latest
```

### 5. Create docker-compose.yml

```bash
cd ~
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
```

### 6. Copy Models (from local machine)

```powershell
# In new PowerShell window
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
```

### 7. Start Containers

```bash
# Back in VM
docker-compose up -d
```

### 8. Verify

```bash
docker ps
docker logs cotton_weed_api
docker logs cotton_weed_app
```

---

## 🔧 Troubleshooting

### Containers Not Starting

```bash
# Check Docker
docker ps

# Check logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Restart containers
cd ~
docker-compose restart
```

### Can't Access from Browser

1. **Check firewall rules:**
   ```powershell
   # From local machine
   gcloud compute firewall-rules list
   ```

2. **Check containers are running:**
   ```bash
   # In VM
   docker ps
   ```

3. **Check ports are listening:**
   ```bash
   # In VM
   netstat -tuln | grep -E "8501|8000"
   ```

4. **Verify VM IP:**
   ```powershell
   # From local machine
   gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
   ```

### Auto-Start Not Working

```bash
# Check systemd service
sudo systemctl status cotton-weed.service

# Enable service
sudo systemctl enable cotton-weed.service

# Start service
sudo systemctl start cotton-weed.service
```

### Model Not Found

```bash
# Check models directory
ls -la ~/models/

# Copy models from local machine
# In PowerShell (local machine):
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
```

---

## 📝 Quick Reference

### Deployment Commands

```bash
# Deploy (first time)
./deploy_streamlit_vm.sh

# Check status
./check_deployment.sh

# Restart containers
cd ~
docker-compose restart

# View logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Stop containers
docker-compose down

# Start containers
docker-compose up -d
```

### Get VM IP

```powershell
# From local machine
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

```bash
# Inside VM
curl http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google"
```

---

## ✅ Deployment Checklist

- [ ] Firewall rules created (ports 8501 and 8000)
- [ ] Docker installed and running
- [ ] docker-compose.yml created
- [ ] Models folder copied to VM
- [ ] Docker images pulled
- [ ] Containers running
- [ ] Auto-start service enabled
- [ ] Can access app from browser
- [ ] API health check passes

---

**🎉 Your Streamlit app is now deployed and accessible!**

