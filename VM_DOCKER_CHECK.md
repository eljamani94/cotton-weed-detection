# Check Docker Installation on VM

## Step 1: Check if Docker is Already Installed

Run these commands on your VM:

```bash
# Check Docker version
docker --version

# Check Docker Compose version
docker-compose --version

# Test Docker (might need sudo)
sudo docker ps
```

## If Docker is Already Installed:

You can skip the installation and just add your user to the docker group:

```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Verify you're in the group
groups

# If docker group appears, you're good!
# If not, you may need to log out and back in
```

## If Docker is NOT Installed:

The VM image (cos-stable) might have Docker pre-installed. Let's verify:

```bash
# Check if docker service is running
sudo systemctl status docker

# If not running, start it
sudo systemctl start docker
sudo systemctl enable docker
```

## Next Steps After Docker is Confirmed:

1. **Configure Docker for GCP:**
   ```bash
   gcloud auth configure-docker
   ```

2. **Pull your images:**
   ```bash
   docker pull gcr.io/cotton-weed-detection-app/api:latest
   docker pull gcr.io/cotton-weed-detection-app/app:latest
   ```

3. **Copy models folder** (from your local machine in a new terminal):
   ```powershell
   gcloud compute scp --recurse models/ cotton-weed-vm:~/models/ --zone=us-central1-a
   ```

4. **Create docker-compose.yml** on the VM and start containers

