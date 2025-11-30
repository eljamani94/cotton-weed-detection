# ⚡ Quick Deploy to Streamlit Cloud

This is a condensed guide to deploy your Streamlit app to Streamlit Cloud in 3 steps.

---

## 📋 Prerequisites Checklist

- [ ] GitHub account
- [ ] Streamlit Cloud account (sign up at https://streamlit.io/cloud)
- [ ] FastAPI backend running on VM
- [ ] VM IP address

---

## 🚀 Step 1: Push to GitHub

### 1.1 Create GitHub Repository

1. Go to https://github.com → Click **"+"** → **"New repository"**
2. Name: `cotton-weed-detection`
3. Make it **Public** ✅
4. Click **"Create repository"**

### 1.2 Push Your Code

**Open PowerShell in your project folder:**

```powershell
cd C:\Users\Aymen\Desktop\cotton_weed_project

# Initialize git (if not done)
git init

# Add files
git add .

# Commit
git commit -m "Initial commit: Cotton Weed Detection App"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/cotton-weed-detection.git

# Push
git branch -M main
git push -u origin main
```

**If asked for password:** Use a GitHub Personal Access Token (not your password)
- Create token: https://github.com/settings/tokens
- Select `repo` scope
- Use token as password

---

## 🚀 Step 2: Get VM API URL

```powershell
# Get your VM IP
gcloud compute instances describe cotton-weed-vm --zone=us-central1-a --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

**Save this IP!** Your API URL: `http://YOUR_VM_IP:8000`

**Verify API is accessible:**
- Open: `http://YOUR_VM_IP:8000/health` in browser
- Should return: `{"status":"healthy","model_loaded":true}`

---

## 🚀 Step 3: Deploy to Streamlit Cloud

### 3.1 Sign In

1. Go to **https://streamlit.io/cloud**
2. Click **"Sign in"** → Use **GitHub** account

### 3.2 Create App

1. Click **"New app"**
2. Fill in:
   - **App name:** `cotton-weed-detection`
   - **Repository:** Select your repository
   - **Branch:** `main`
   - **Main file path:** `app/main.py`
3. Click **"Advanced settings"** or **"Secrets"**
4. Add secret:
   ```
   API_URL = http://YOUR_VM_IP:8000
   ```
   (Replace `YOUR_VM_IP` with your actual IP)
5. Click **"Deploy"**

### 3.3 Wait for Deployment

- Usually takes 1-2 minutes
- Watch the logs for any errors
- Your app will be at: `https://cotton-weed-detection.streamlit.app`

---

## ✅ Step 4: Update FastAPI CORS (Important!)

Your FastAPI backend needs to allow requests from Streamlit Cloud.

**The code is already updated!** Just restart your API container on the VM:

```bash
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Restart API
cd ~
docker-compose restart api

# Or if you need to rebuild:
docker-compose up -d --build api
```

---

## 🎉 Done!

Your app is now live at:
- **Streamlit App:** `https://your-app-name.streamlit.app`
- **API Backend:** `http://YOUR_VM_IP:8000`

---

## 🔄 Updating Your App

When you make changes:

```powershell
git add .
git commit -m "Your changes"
git push
```

Streamlit Cloud will auto-deploy in 1-2 minutes!

---

## 🆘 Troubleshooting

### "Connection refused"
- Check VM is running
- Check API is running: `docker ps` on VM
- Verify firewall allows port 8000

### "CORS error"
- Restart API container on VM (Step 4)
- Check API logs: `docker logs cotton_weed_api`

### "App failed to deploy"
- Check repository is public
- Check `app/main.py` exists
- Check deployment logs in Streamlit Cloud

---

## 📚 Detailed Guides

- **GitHub Setup:** See `GITHUB_SETUP.md` for detailed GitHub instructions
- **Streamlit Cloud:** See `STREAMLIT_CLOUD_DEPLOYMENT.md` for detailed deployment guide

---

**🎉 That's it! Your app is now on Streamlit Cloud!**

