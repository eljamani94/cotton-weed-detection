# 🔧 Fixed: API Connection Error on VM

## Problem
The app container couldn't connect to the API because they were on different Docker networks. The error was:
```
Failed to resolve 'api' ([Errno -2] Name or service not known)
```

## Solution Applied ✅

1. **Created a custom Docker network:**
   ```bash
   docker network create cotton-weed-network
   ```

2. **Recreated containers on the same network:**
   - API container: `--network cotton-weed-network --network-alias api`
   - App container: `--network cotton-weed-network`

3. **Both containers can now communicate:**
   - App can resolve `api` hostname
   - API is accessible at `http://api:8000`

## Current Setup

**Containers:**
- `cotton_weed_api` - Running on `cotton-weed-network` with alias `api`
- `cotton_weed_app` - Running on `cotton-weed-network`

**Network:**
- Name: `cotton-weed-network`
- Type: Bridge network
- Both containers can communicate using container names or network aliases

## Why This Works

When containers are on the same custom Docker network:
- They can resolve each other by container name
- They can resolve each other by network alias
- They have internal DNS resolution
- They can communicate on internal IPs

The default `bridge` network doesn't provide automatic DNS resolution between containers, which is why the app couldn't find 'api'.

## Test the Fix

Try uploading an image now at http://34.134.18.194:8501

The API connection error should be resolved! ✅

---

## If You Need to Recreate Containers in the Future

**API Container:**
```bash
docker run -d \
  --name cotton_weed_api \
  --restart unless-stopped \
  -p 8000:8000 \
  -v ~/models:/app/models \
  -e PYTHONUNBUFFERED=1 \
  --network cotton-weed-network \
  --network-alias api \
  gcr.io/cotton-weed-detection-app/api:latest
```

**App Container:**
```bash
docker run -d \
  --name cotton_weed_app \
  --restart unless-stopped \
  -p 8501:8501 \
  -e API_URL=http://api:8000 \
  -e PYTHONUNBUFFERED=1 \
  --network cotton-weed-network \
  gcr.io/cotton-weed-detection-app/app:latest
```

**Important:** Always use `--network cotton-weed-network` for both containers!




