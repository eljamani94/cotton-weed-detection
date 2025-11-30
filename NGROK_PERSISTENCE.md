# 🔗 ngrok Link Persistence After SSH Close

## ✅ Good News:

If you started ngrok with `-d` (detached) flag or via docker-compose, **it will keep running** even after you close SSH!

## ⚠️ Important Considerations:

### 1. How You Started ngrok Matters:

**✅ Will Keep Running:**
```bash
# Detached mode (-d flag)
docker run -d --name ngrok-tunnel ...

# Or via docker-compose
docker-compose up -d
```

**❌ Will Stop When SSH Closes:**
```bash
# Interactive mode (-it flag, no -d)
docker run -it --rm ...
```

### 2. Free Tier Limitations:

Even if ngrok keeps running, the **free tier has limits:**
- **Session time limits** (usually 2-8 hours)
- **Inactivity timeout** (disconnects after idle period)
- **Connection limits** (number of connections)

### 3. VM Restart:

If the VM restarts (maintenance, crash, etc.):
- All containers stop
- ngrok stops
- You'll need to restart everything
- **New ngrok URL** (URLs change on restart)

## 🔍 Check if ngrok is Still Running:

### From Your Local Machine:

```powershell
# Check if ngrok container is running
gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker ps | grep ngrok"
```

### Or SSH Back In:

```powershell
gcloud compute ssh cotton-weed-vm --zone=us-central1-a
docker ps | grep ngrok
```

## 📊 Expected Behavior:

### Best Case Scenario:
- ✅ ngrok keeps running for hours/days
- ✅ URL stays the same
- ✅ Works until free tier limit or VM restart

### Worst Case Scenario:
- ⚠️ ngrok disconnects after inactivity (free tier)
- ⚠️ URL changes if ngrok restarts
- ⚠️ Need to restart and get new URL

## 🎯 For Your Demo:

### Before Demo:
1. **Check ngrok is running:**
   ```powershell
   gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker ps | grep ngrok"
   ```

2. **Get current URL:**
   ```powershell
   gcloud compute ssh cotton-weed-vm --zone=us-central1-a --command="docker logs ngrok-tunnel 2>&1 | grep -o 'https://[^ ]*\.ngrok[^ ]*' | head -1"
   ```

3. **Test the URL** to make sure it works

### If ngrok Stops:

**Restart it:**
```powershell
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Restart ngrok
docker start ngrok-tunnel
# Or if container doesn't exist:
docker run -d --name ngrok-tunnel --restart unless-stopped -p 4040:4040 --network host -e NGROK_AUTHTOKEN=35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE ngrok/ngrok http 8501

# Get new URL
docker logs ngrok-tunnel | grep -o 'https://[^ ]*\.ngrok[^ ]*' | head -1
```

## 💡 Recommendation:

### For Reliable Demo:

**Option 1: Check Before Demo**
- 15 minutes before demo, SSH in and verify ngrok is running
- Get the current URL
- Test it works
- Have it ready for your presentation

**Option 2: Use Browser Flags (More Reliable)**
- Enable camera on HTTP in browsers
- Use direct IP: `http://34.134.18.194:8501`
- No dependency on ngrok
- Works as long as VM is running

**Option 3: Add ngrok to docker-compose.yml**
- Auto-starts with your app
- Auto-restarts if it crashes
- More reliable

## 🔧 Make ngrok Auto-Start:

Add to your `docker-compose.yml` on VM:

```yaml
  ngrok:
    image: ngrok/ngrok:latest
    container_name: ngrok_tunnel
    command: http 8501
    ports:
      - "4040:4040"
    network_mode: host
    environment:
      - NGROK_AUTHTOKEN=35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE
    restart: unless-stopped
    depends_on:
      - app
```

Then:
```bash
docker-compose up -d
```

ngrok will start automatically and restart if it crashes!

---

## ✅ Summary:

- **If started with `-d` flag:** Will keep running after SSH close ✅
- **Free tier limits:** May disconnect after inactivity ⚠️
- **VM restart:** Will stop everything, need to restart ⚠️
- **Best practice:** Check before demo, or use browser flags for reliability

