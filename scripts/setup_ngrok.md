# 🚇 ngrok Setup for HTTPS Access

## Why ngrok?

- Creates HTTPS tunnel to your HTTP server
- Camera access works automatically
- Free tier available
- Quick setup (5 minutes)

## Step-by-Step Setup

### Step 1: Create ngrok Account

1. Go to: https://ngrok.com
2. Sign up (free)
3. Get your authtoken from dashboard

### Step 2: Install ngrok on VM

SSH into your VM:
```bash
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
```

Then in the VM:
```bash
# Download ngrok
curl -O https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract
tar xvzf ngrok-v3-stable-linux-amd64.tgz

# Move to /usr/local/bin (might need to use home directory on COS)
mkdir -p ~/bin
mv ngrok ~/bin/
chmod +x ~/bin/ngrok
export PATH=$PATH:~/bin

# Configure with your authtoken
~/bin/ngrok config add-authtoken YOUR_AUTH_TOKEN_HERE
```

### Step 3: Start ngrok Tunnel

```bash
# Start tunnel to port 8501 (Streamlit)
~/bin/ngrok http 8501
```

You'll see output like:
```
Forwarding  https://abc123.ngrok-free.app -> http://localhost:8501
```

### Step 4: Use HTTPS URL

- **Access your app:** https://abc123.ngrok-free.app
- **Camera will work!** ✅

## Keep ngrok Running

To keep ngrok running after SSH disconnect:

```bash
# Use screen or nohup
nohup ~/bin/ngrok http 8501 > ngrok.log 2>&1 &

# Or use screen
screen -S ngrok
~/bin/ngrok http 8501
# Press Ctrl+A then D to detach
```

## Get ngrok URL Later

```bash
# Check ngrok status
curl http://localhost:4040/api/tunnels
```

## Notes

- Free ngrok URLs change each time you restart
- For demo, get the URL right before your presentation
- Paid ngrok gives you a fixed domain

