# ⏰ ngrok URL Expiration - Important Info

## Free ngrok URLs:

### ❌ Will Expire/Change When:
- **ngrok process stops** (you close SSH, VM restarts, etc.)
- **Connection is idle** for extended period (free tier has limits)
- **You restart ngrok** (new URL each time)
- **Session ends** (free tier sessions are temporary)

### ✅ Stays Active When:
- ngrok is running continuously
- Connection is active
- VM is running
- You don't restart ngrok

## 📊 Free vs Paid ngrok:

### Free Tier:
- ✅ Temporary HTTPS URLs
- ✅ Good for testing/demos
- ❌ URL changes each restart
- ❌ Session time limits
- ❌ No reserved domains

### Paid Plans ($8/month+):
- ✅ Reserved domains (fixed URL)
- ✅ Longer sessions
- ✅ More stable
- ✅ Custom domains

## 🎯 For Your Demo:

### Option 1: Keep ngrok Running
- Start ngrok before your demo
- Keep it running during demo
- Get the URL right before presentation
- URL will work for the duration of your demo

### Option 2: Use Browser Flags (No Expiration)
- Enable camera on HTTP in browsers
- Use direct IP: `http://34.134.18.194:8501`
- No expiration, but requires browser configuration

### Option 3: Set Up Permanent HTTPS (Best for Production)
- Get a domain name (free or paid)
- Set up SSL certificate
- Point domain to VM IP
- Permanent URL that never expires

## 🔧 Keep ngrok Running for Demo:

### Start ngrok in background:
```bash
# Start in background
docker run -d --name ngrok-tunnel --restart unless-stopped -p 4040:4040 --network host -e NGROK_AUTHTOKEN=35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE ngrok/ngrok http 8501

# Get the URL
docker logs ngrok-tunnel | grep -o 'https://[^"]*\.ngrok[^"]*'
```

### Add to docker-compose.yml (Auto-start):
You can add ngrok as a service in your docker-compose.yml so it starts automatically with your app.

## 💡 Recommendation for Your Demo:

**Best Approach:**
1. **Before demo:** Start ngrok and get the URL
2. **Save the URL** somewhere
3. **Keep ngrok running** during demo
4. **Use the URL** for your presentation

**Alternative:**
- Use browser flags method (see `CAMERA_FIX.md`)
- Use direct IP: `http://34.134.18.194:8501`
- No expiration, works as long as VM is running

## 🚀 Permanent Solution (If Needed Later):

If you need a permanent URL:
1. Get a domain (free: Freenom, or paid)
2. Set up Let's Encrypt SSL
3. Configure Nginx reverse proxy
4. Point domain to VM IP
5. Permanent HTTPS URL!

But for your demo, ngrok is perfect - just start it before your presentation!

