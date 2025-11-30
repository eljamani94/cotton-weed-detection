# 📦 GitHub Repository Setup Guide

This guide shows you how to push your code to GitHub so you can deploy to Streamlit Cloud.

---

## 🎯 Step 1: Create GitHub Repository

### Option A: Create Repository on GitHub Website

1. **Go to GitHub:**
   - Visit https://github.com
   - Sign in (or create account if needed)

2. **Create New Repository:**
   - Click the **"+"** icon in top right → **"New repository"**
   - Repository name: `cotton-weed-detection` (or any name you like)
   - Description: "Cotton Weed Detection MLOps Application"
   - Choose **Public** (required for free Streamlit Cloud)
   - **DO NOT** check "Initialize with README" (we already have files)
   - Click **"Create repository"**

3. **Copy the repository URL:**
   - You'll see a page with instructions
   - Copy the repository URL (e.g., `https://github.com/yourusername/cotton-weed-detection.git`)

### Option B: Create Repository via GitHub CLI

```powershell
# Install GitHub CLI if not installed
# Download from: https://cli.github.com/

# Authenticate
gh auth login

# Create repository
gh repo create cotton-weed-detection --public --source=. --remote=origin --push
```

---

## 🎯 Step 2: Initialize Git in Your Project

**Open PowerShell in your project directory:**

```powershell
# Navigate to your project
cd C:\Users\Aymen\Desktop\cotton_weed_project

# Initialize git (if not already done)
git init

# Check if .gitignore exists, if not we'll create it
```

---

## 🎯 Step 3: Create .gitignore File

Create a `.gitignore` file to exclude unnecessary files:

```powershell
# Create .gitignore file
@"
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
cotton_weed/
venv/
env/
ENV/

# Virtual Environment
cotton_weed/
*.egg-info/
dist/
build/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
desktop.ini

# Project specific
*.db
*.sqlite
uploads/
*.pt
models/*.pt
!models/.gitkeep

# Logs
*.log

# Environment variables
.env
.env.local

# Docker
.dockerignore

# Jupyter
.ipynb_checkpoints/

# Temporary files
*.tmp
*.temp
"@ | Out-File -FilePath .gitignore -Encoding utf8
```

**Note:** We're excluding the model file (`*.pt`) because it's large. You'll need to upload it separately or use a different method.

---

## 🎯 Step 4: Add Files to Git

```powershell
# Add all files (respecting .gitignore)
git add .

# Check what will be committed
git status

# Commit files
git commit -m "Initial commit: Cotton Weed Detection App"
```

---

## 🎯 Step 5: Connect to GitHub Repository

```powershell
# Add remote repository (replace with YOUR repository URL)
git remote add origin https://github.com/YOUR_USERNAME/cotton-weed-detection.git

# Verify remote
git remote -v
```

**Replace `YOUR_USERNAME` with your actual GitHub username!**

---

## 🎯 Step 6: Push to GitHub

```powershell
# Push to GitHub (first time)
git push -u origin main

# If you get an error about branch name, try:
git branch -M main
git push -u origin main

# Or if your default branch is 'master':
git push -u origin master
```

**If prompted for credentials:**
- **Username:** Your GitHub username
- **Password:** Use a **Personal Access Token** (not your GitHub password)
  - Create token: https://github.com/settings/tokens
  - Click "Generate new token (classic)"
  - Select scopes: `repo` (all)
  - Copy the token and use it as password

---

## 🎯 Step 7: Verify on GitHub

1. Go to your repository on GitHub
2. You should see all your files
3. Check that:
   - ✅ `app/main.py` is there
   - ✅ `requirements.txt` is there
   - ✅ `.gitignore` is there
   - ✅ `models/` folder exists (but `.pt` files are excluded)

---

## 🔄 Updating Your Repository

When you make changes:

```powershell
# Check what changed
git status

# Add changed files
git add .

# Commit changes
git commit -m "Description of changes"

# Push to GitHub
git push
```

---

## 📝 Quick Reference Commands

```powershell
# Check status
git status

# Add files
git add .

# Commit
git commit -m "Your message"

# Push
git push

# Pull latest changes
git pull

# View commit history
git log

# Create new branch
git checkout -b feature-name

# Switch branches
git checkout main
```

---

## ⚠️ Important Notes

1. **Model File:** The `.pt` model file is excluded by `.gitignore` because it's large. For Streamlit Cloud, you'll need to either:
   - Upload model to a cloud storage (Google Cloud Storage, AWS S3)
   - Use a different method to load the model
   - Or we can modify the setup to include it (if it's not too large)

2. **Environment Variables:** Don't commit `.env` files with secrets. Use Streamlit Cloud's secrets management.

3. **Public Repository:** Streamlit Cloud free tier requires a public repository.

---

## 🆘 Troubleshooting

### "Repository not found"
- Check the repository URL is correct
- Make sure the repository exists on GitHub
- Verify you have access to the repository

### "Authentication failed"
- Use Personal Access Token instead of password
- Create token: https://github.com/settings/tokens

### "Branch name error"
```powershell
# Rename branch to main
git branch -M main
git push -u origin main
```

### "Large file error"
- Make sure `.gitignore` excludes large files
- If you already committed large files:
  ```powershell
  git rm --cached large-file.pt
  git commit -m "Remove large file"
  git push
  ```

---

**✅ Once your code is on GitHub, proceed to `STREAMLIT_CLOUD_DEPLOYMENT.md` for deployment!**

