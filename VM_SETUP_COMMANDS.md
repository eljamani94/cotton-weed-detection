# 🖥️ VM Setup Commands

## Your VM Details:
- **Name:** cotton-weed-vm
- **Zone:** us-central1-a
- **External IP:** 34.134.18.194
- **Status:** RUNNING ✅

## Step 1: SSH into VM

```powershell
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

## Step 2: Install Docker (Run these commands INSIDE the VM)

Once you're SSH'd into the VM, run:

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Log out and back in for group changes (or just run: newgrp docker)
exit
```

## Step 3: SSH Back In

```powershell
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

## Step 4: Configure Docker for GCP (Inside VM)

```bash
# Authenticate Docker with GCP
gcloud auth configure-docker

# Pull your images
docker pull gcr.io/cotton-weed-detection-app/api:latest
docker pull gcr.io/cotton-weed-detection-app/app:latest
```

## Step 5: Create docker-compose.yml on VM

Create the file on the VM:

```bash
nano docker-compose.yml
```

Paste this content:

```yaml
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
```

Save: `Ctrl+O`, Enter, `Ctrl+X`

## Step 6: Copy Models Folder to VM

**From your local machine (new PowerShell window):**

```powershell
gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
```

## Step 7: Start Containers (Back in VM)

```bash
# Start containers
docker-compose up -d

# Check if running
docker ps

# View logs
docker logs cotton_weed_api
docker logs cotton_weed_app
```

## Step 8: Access Your App!

- **Streamlit App:** http://34.134.18.194:8501
- **API Docs:** http://34.134.18.194:8000/docs
- **API Health:** http://34.134.18.194:8000/health

## 🔧 Troubleshooting

### Can't SSH into VM:
```powershell
# Check VM status
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a
```

### Containers not starting:
```bash
# Check logs
docker logs cotton_weed_api
docker logs cotton_weed_app

# Restart
docker-compose restart
```

### Can't access from browser:
- Wait 1-2 minutes for containers to start
- Check firewall rule exists: `gcloud compute firewall-rules list`
- Verify external IP: `gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'`

