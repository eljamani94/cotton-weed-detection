# How to Restart After Taking a Break

## Quick Start (After Turning On Your Laptop)

### Option 1: Using Docker (Recommended - What You Were Using)
```bash
# Navigate to project folder
cd C:\Users\Aymen\Desktop\cotton_weed_project

# Start both API and App containers
docker-compose up -d

# Check if they're running
docker ps
```

**Access the app at:** `http://localhost:8501`

### Option 2: Using Local Streamlit (Alternative)
```bash
# Navigate to project folder
cd C:\Users\Aymen\Desktop\cotton_weed_project

# Start API (in one terminal)
.\scripts\start_api.bat

# Start App (in another terminal)
.\scripts\start_app.bat
```

## What Happens When You Turn Off Your Laptop?

- ✅ **Docker containers stop automatically** - This is normal and expected
- ✅ **All your code and changes are saved** - Nothing is lost
- ✅ **Just restart the containers when you come back** - Everything will work again

## To Stop Everything Before Shutting Down (Optional)

If you want to cleanly stop everything:
```bash
docker-compose down
```

But it's not necessary - shutting down your laptop will stop them anyway.

## When You Return

1. Turn on your laptop
2. Open a terminal/PowerShell
3. Run: `docker-compose up -d`
4. Wait 10-15 seconds
5. Open browser to `http://localhost:8501`
6. You'll see the new black/green AR-style design! 🎉

## Note

- The Docker containers use the code that was built when you ran `docker-compose build`
- If you make changes to `app/main.py` and want to see them in Docker, you need to rebuild:
  ```bash
  docker-compose build app
  docker-compose up -d app
  ```

