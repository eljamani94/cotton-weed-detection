# 🐍 Virtual Environment Setup Guide

## Why Use a Virtual Environment?

A virtual environment keeps your project's dependencies separate from other Python projects on your computer. This prevents conflicts between different projects.

## Quick Setup (Windows)

### Option 1: Use the Setup Script (Easiest)

1. Open PowerShell in the project folder
2. Run:
   ```powershell
   .\scripts\setup_venv.bat
   ```
3. Follow the prompts
4. The script will automatically activate the environment

### Option 2: Manual Setup

1. Open PowerShell in the project folder
2. Create virtual environment:
   ```powershell
   python -m venv cotton_weed
   ```
3. Activate it:
   ```powershell
   cotton_weed\Scripts\activate.bat
   ```
4. You should see `(cotton_weed)` at the start of your prompt
5. Upgrade pip:
   ```powershell
   python -m pip install --upgrade pip
   ```

## How to Use the Virtual Environment

### Activating (Every time you work on the project)

Open PowerShell in the project folder and run:
```powershell
cotton_weed\Scripts\activate.bat
```

You'll see `(cotton_weed)` appear in your prompt, which means it's active.

### Installing Packages

Once activated, install project dependencies:
```powershell
pip install -r requirements.txt
```

### Deactivating

When you're done working:
```powershell
deactivate
```

## Important Notes

✅ **Always activate the virtual environment** before:
- Installing packages
- Running the API
- Running the Streamlit app
- Running any Python scripts

✅ **You'll know it's active** when you see `(cotton_weed)` in your PowerShell prompt

✅ **The virtual environment is project-specific** - it only affects this project

## Troubleshooting

**Problem:** "python is not recognized"
- Solution: Install Python and make sure to check "Add Python to PATH" during installation

**Problem:** "cotton_weed\Scripts\activate.bat" not found
- Solution: Make sure you're in the project folder and the cotton_weed folder exists

**Problem:** Packages not installing
- Solution: Make sure the virtual environment is activated (you should see `(cotton_weed)`)

## Next Steps

After setting up the virtual environment:

1. ✅ Activate it: `cotton_weed\Scripts\activate.bat`
2. ✅ Install dependencies: `pip install -r requirements.txt`
3. ✅ Add your model to the `models/` folder
4. ✅ Test the application

---

**Ready?** Run `.\scripts\setup_venv.bat` to get started! 🚀

