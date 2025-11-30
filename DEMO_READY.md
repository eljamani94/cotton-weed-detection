# 🎓 Demo Ready Checklist

## ✅ Everything You Need for Your Demo

### 📋 Pre-Demo (15 Minutes Before)

#### Local Demo:
```powershell
# Terminal 1
.\scripts\start_api.bat

# Terminal 2
.\scripts\start_app.bat
```

**Test:** http://localhost:8501

#### Cloud Demo:
```powershell
# Start VM and get IP
.\scripts\start_cloud_demo.bat

# Or manually:
gcloud compute instances start cotton-weed-vm --zone=us-central1-a
.\scripts\get_vm_ip.bat
```

Then SSH and start containers (see QUICK_START.md)

---

## 🎯 Demo Script

### 1. Introduction (30 seconds)
- "This is an MLOps application for cotton weed detection"
- "Built with YOLOv8 deep learning model"
- "Deployed on Google Cloud Platform"

### 2. Show Architecture (1 minute)
- Frontend: Streamlit
- Backend: FastAPI
- Model: YOLOv8
- Deployment: Docker containers on GCP

### 3. Live Demo (2 minutes)
- Open application
- Upload test image
- Show bounding boxes
- Explain classes and confidence scores

### 4. Technical Details (1 minute)
- Real-time predictions
- API endpoints
- Cloud deployment
- Cost-effective solution

---

## 🔗 Quick Access Links

### Local:
- App: http://localhost:8501
- API: http://localhost:8000/docs

### Cloud:
- Get IP: `.\scripts\get_vm_ip.bat`
- App: http://YOUR_VM_IP:8501
- API: http://YOUR_VM_IP:8000/docs

---

## 🚨 Backup Plan

1. **Have screenshots ready** of the application working
2. **Have local version running** as backup
3. **Have the architecture diagram** ready to explain
4. **Test 15 minutes before** your demo time

---

## 📞 Quick Help

- **Local not working?** → See `COMPLETE_WORKFLOW.md` → Troubleshooting → Local Issues
- **Cloud not working?** → See `COMPLETE_WORKFLOW.md` → Troubleshooting → Cloud Issues
- **Need quick commands?** → See `QUICK_START.md`

---

**You're ready! Good luck with your demo! 🚀**

