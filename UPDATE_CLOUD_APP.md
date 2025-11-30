# 🚀 Update App on Cloud VM

This guide shows you how to update the app running on your cloud VM with your local changes.

## 📋 Quick Update Steps

### Option 1: Automated Script (Easiest)

1. **Run the update script:**
   ```powershell
   .\scripts\update_cloud_app.bat
   ```

   The script will:
   - ✅ Build the new Docker image with your local changes
   - ✅ Push it to Google Container Registry
   - ✅ Update the container on the VM

2. **The script will ask if you want to update automatically** - just type `Y` and press Enter.

That's it! Your updated app will be live on the cloud VM.

---

### Option 2: Manual Steps

If you prefer to do it manually:

#### Step 1: Build New Image (on your local machine)

```powershell
# Build the app image with your local changes
docker build -f docker/Dockerfile.app -t gcr.io/cotton-weed-detection-app/app:latest .
```

#### Step 2: Push Image to Google Container Registry

```powershell
# Push the image (this may take a few minutes)
docker push gcr.io/cotton-weed-detection-app/app:latest
```

#### Step 3: Update Container on VM

**Option A: SSH into VM and update**

```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Once inside VM, pull new image and restart container
docker pull gcr.io/cotton-weed-detection-app/app:latest
docker-compose restart app

# Exit VM
exit
```

**Option B: Update remotely (one command)**

```powershell
# Update remotely without SSH
gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="cd ~ && docker pull gcr.io/cotton-weed-detection-app/app:latest && docker-compose restart app"
```

---

## 🔍 Verify the Update

1. **Check container logs:**
   ```powershell
   gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker logs cotton_weed_app"
   ```

2. **Access your app:**
   - Get VM IP: `gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'`
   - Open in browser: `http://<VM_IP>:8501`
   - You should see your updated frontend!

---

## ⚠️ Troubleshooting

### Build fails:
- Make sure Docker Desktop is running
- Check you're in the project directory

### Push fails:
- Authenticate: `gcloud auth configure-docker`
- Check your project ID: `gcloud config get-value project`

### Update on VM fails:
- SSH into VM: `gcloud compute ssh cotton-weed-vm --zone=us-central1-a`
- Check Docker: `docker ps`
- Check logs: `docker logs cotton_weed_app`

### Container won't restart:
```powershell
# Stop and remove old container
docker-compose down app

# Start with new image
docker-compose up -d app
```

---

## 📝 Notes

- **Update only app:** This process updates only the frontend app container. The API container remains unchanged.
- **Zero downtime:** The container restart is fast (< 10 seconds), so there's minimal downtime.
- **Model stays:** Your model files are mounted as volumes, so they won't be affected.
- **Changes persist:** Your local changes are now in the cloud container!

---

## 🎯 Quick Command Reference

```powershell
# Build and push
docker build -f docker/Dockerfile.app -t gcr.io/cotton-weed-detection-app/app:latest .
docker push gcr.io/cotton-weed-detection-app/app:latest

# Update on VM (one line)
gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="cd ~ && docker pull gcr.io/cotton-weed-detection-app/app:latest && docker-compose restart app"

# Check status
gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker ps"
```

---

**Ready to update? Run the script: `.\scripts\update_cloud_app.bat`** 🚀

