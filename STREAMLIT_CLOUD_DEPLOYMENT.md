# ☁️ Streamlit Cloud Deployment Guide

This guide shows you how to deploy your Streamlit frontend to Streamlit Cloud while keeping your FastAPI backend on Google Cloud VM.

---

## 🎯 Overview

**Architecture:**
- **Frontend (Streamlit):** Deployed on Streamlit Cloud → `your-app.streamlit.app`
- **Backend (FastAPI):** Running on Google Cloud VM → `http://YOUR_VM_IP:8000`

The Streamlit app will call your VM's FastAPI backend for predictions.

---

## 📋 Prerequisites

1. ✅ Code pushed to GitHub (see `GITHUB_SETUP.md`)
2. ✅ GitHub repository is **Public** (required for free tier)
3. ✅ FastAPI backend running on VM
4. ✅ VM IP address (or static IP configured)

---

## 🚀 Step 1: Prepare Your Repository

### 1.1 Create Streamlit-Specific Requirements

Create a `requirements-streamlit.txt` file (lighter version without backend dependencies):

```txt
# Streamlit Frontend Requirements (for Streamlit Cloud)
streamlit>=1.28.0
Pillow>=10.2.0,<11.0.0
requests>=2.31.0
```

**Or use your existing `requirements.txt`** - Streamlit Cloud will install what's needed.

### 1.2 Create Streamlit Configuration

Create `.streamlit/config.toml`:

```toml
[server]
headless = true
port = 8501
enableCORS = false
enableXsrfProtection = false

[theme]
primaryColor = "#F4D03F"
backgroundColor = "#556B2F"
secondaryBackgroundColor = "#8B7355"
textColor = "#F9F9F9"
font = "sans serif"
```

### 1.3 Update .gitignore (if needed)

Make sure `.gitignore` doesn't exclude important files:

```gitignore
# Keep these files:
# app/
# requirements.txt
# .streamlit/

# Exclude these:
__pycache__/
*.pyc
cotton_weed/
.env
*.db
uploads/
models/*.pt
```

---

## 🚀 Step 2: Get Your VM API URL

You need your VM's external IP address:

```powershell
# From your local machine
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

**Save this IP!** Your API URL will be: `http://YOUR_VM_IP:8000`

**Important:** Make sure:
- ✅ Firewall rule allows port 8000 from anywhere
- ✅ FastAPI is running on the VM
- ✅ API is accessible: `http://YOUR_VM_IP:8000/health`

---

## 🚀 Step 3: Deploy to Streamlit Cloud

### 3.1 Sign Up / Sign In

1. Go to **https://streamlit.io/cloud**
2. Click **"Sign up"** or **"Sign in"**
3. Sign in with your **GitHub account** (required)

### 3.2 Create New App

1. Click **"New app"** button
2. Fill in the details:
   - **App name:** `cotton-weed-detection` (or your choice)
   - **Repository:** Select your GitHub repository
   - **Branch:** `main` (or `master`)
   - **Main file path:** `app/main.py`
   - **Python version:** `3.9` (or latest available)

### 3.3 Configure Secrets (API URL)

1. Click **"Advanced settings"** or **"Secrets"** tab
2. Add your VM API URL as a secret:

```
API_URL = http://YOUR_VM_IP:8000
```

**Replace `YOUR_VM_IP` with your actual VM IP!**

**Or** you can set it in the app's environment variables section.

### 3.4 Deploy

1. Click **"Deploy"** or **"Save"**
2. Wait for deployment (usually 1-2 minutes)
3. Your app will be available at: `https://your-app-name.streamlit.app`

---

## 🎯 Step 4: Update Your Streamlit App (if needed)

Your app already uses `os.getenv("API_URL")`, which is perfect! Streamlit Cloud will use the secret you set.

**Verify in `app/main.py`:**
```python
API_URL = os.getenv("API_URL", "http://localhost:8000")
```

This will automatically use the `API_URL` secret from Streamlit Cloud.

---

## 🔧 Step 5: Configure CORS on FastAPI (Important!)

Your FastAPI backend needs to allow requests from Streamlit Cloud. Update your FastAPI code:

**In `api/main.py`, add CORS middleware:**

```python
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://*.streamlit.app",  # Allow all Streamlit Cloud apps
        "http://localhost:8501",     # For local testing
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
```

**Then rebuild and redeploy your API container on the VM:**

```bash
# On VM
cd ~
docker-compose restart api
# Or rebuild if needed
docker-compose up -d --build api
```

---

## ✅ Step 6: Test Your Deployment

1. **Open your Streamlit app:** `https://your-app-name.streamlit.app`
2. **Upload an image**
3. **Check if predictions work**

**If you get CORS errors:**
- Make sure CORS is configured in FastAPI (Step 5)
- Check API is accessible: `http://YOUR_VM_IP:8000/health`
- Verify firewall rules allow access

**If you get connection errors:**
- Check VM IP hasn't changed
- Verify FastAPI is running: `docker ps` on VM
- Test API directly: `http://YOUR_VM_IP:8000/health`

---

## 🔄 Updating Your App

When you make changes:

1. **Commit and push to GitHub:**
   ```powershell
   git add .
   git commit -m "Update app"
   git push
   ```

2. **Streamlit Cloud auto-deploys** (usually within 1-2 minutes)

3. **Or manually trigger:** Go to Streamlit Cloud dashboard → Click "Reboot app"

---

## 🔧 Managing Secrets

To update your API URL:

1. Go to Streamlit Cloud dashboard
2. Click on your app
3. Go to **"Settings"** → **"Secrets"**
4. Update `API_URL`
5. Click **"Save"**
6. App will restart automatically

---

## 📍 Your App URLs

After deployment:

- **Streamlit App:** `https://your-app-name.streamlit.app`
- **API Backend:** `http://YOUR_VM_IP:8000`
- **API Docs:** `http://YOUR_VM_IP:8000/docs`

---

## 🆘 Troubleshooting

### "App failed to deploy"

**Check:**
- Repository is public
- `app/main.py` exists
- `requirements.txt` is valid
- Check deployment logs in Streamlit Cloud dashboard

### "Connection refused" or "API Error"

**Check:**
- VM is running
- FastAPI is running: `docker ps` on VM
- Firewall allows port 8000
- API URL in secrets is correct
- CORS is configured in FastAPI

### "CORS error"

**Fix:**
- Add CORS middleware to FastAPI (see Step 5)
- Restart API container on VM

### "Module not found"

**Fix:**
- Check `requirements.txt` includes all dependencies
- Streamlit Cloud installs from `requirements.txt` in root

### VM IP Changed

**Fix:**
1. Get new IP:
   ```powershell
   gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
   ```
2. Update secret in Streamlit Cloud: `API_URL = http://NEW_IP:8000`

---

## 💡 Pro Tips

1. **Use Static IP:** Configure a static IP for your VM so it doesn't change:
   ```powershell
   gcloud compute addresses create cotton-weed-ip --region=us-central1
   gcloud compute instances add-access-config cotton-weed-vm --zone=us-central1-a --address=cotton-weed-ip
   ```

2. **Monitor Logs:** Check Streamlit Cloud logs and VM API logs for debugging

3. **Health Checks:** Add health check endpoint in Streamlit app to verify API connection

4. **Error Handling:** Add better error messages in Streamlit app for API connection issues

---

## 📝 Quick Reference

**Deploy:**
1. Push code to GitHub
2. Sign in to Streamlit Cloud
3. Create new app → Select repository
4. Set `API_URL` secret
5. Deploy!

**Update:**
1. Push changes to GitHub
2. Streamlit Cloud auto-deploys

**Access:**
- App: `https://your-app-name.streamlit.app`
- API: `http://YOUR_VM_IP:8000`

---

**🎉 Your Streamlit app is now live on Streamlit Cloud!**

