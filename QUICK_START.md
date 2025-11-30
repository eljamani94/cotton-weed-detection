# ⚡ Quick Start Guide

## 🖥️ Local - Start in 30 Seconds

```powershell
# Terminal 1
.\scripts\start_api.bat

# Terminal 2 (new window)
.\scripts\start_app.bat
```

**Access:** http://localhost:8501

---

## ☁️ Cloud - Start in 2 Minutes

```powershell
# 1. Start VM
gcloud compute instances start cotton-weed-vm --zone=us-central1-a

# 2. Get IP (wait 1 min first)
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'

# 3. SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

**In VM:**
```bash
# Set alias
alias docker-compose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest'

# Start containers
cd ~
docker-compose up -d

# Check status
docker ps
```

**Access:** http://YOUR_VM_IP:8501

---

## 🛑 Stop Everything

### Local:
Press `Ctrl+C` in both terminals

### Cloud:
```powershell
# Stop containers (in VM)
docker-compose down

# Exit VM
exit

# Stop VM (from local machine)
gcloud compute instances stop cotton-weed-vm --zone=us-central1-a
```

---

## 📞 Need Help?

Check `COMPLETE_WORKFLOW.md` for detailed instructions and troubleshooting.
