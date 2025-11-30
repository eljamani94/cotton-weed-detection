# 📸 Image Storage Information

## Current Setup:

### Where Images Are Stored:
- **Location:** Inside the Docker container at `/app/uploads/`
- **Path in code:** `uploads/{timestamp}_{filename}`
- **Storage type:** Container filesystem (temporary)

### ⚠️ Important:

**Images are stored INSIDE the container**, which means:
- ✅ They persist while container is running
- ❌ They're **lost when container is recreated/restarted**
- ❌ They're **lost when VM is stopped/restarted**
- ❌ They take up container disk space

## 📊 Current Behavior:

1. **User uploads image** → Saved to `/app/uploads/` in container
2. **Image is processed** → Predictions made
3. **Image path saved to database** → But file might not exist later
4. **Container restarts** → All images in `uploads/` are lost

## 💾 Storage Options:

### Option 1: Mount Volume (Persistent Storage)

**Modify docker-compose.yml on VM:**

```yaml
services:
  api:
    image: gcr.io/cotton-weed-detection-app/api:latest
    container_name: cotton_weed_api
    ports:
      - "8000:8000"
    volumes:
      - ./models:/app/models
      - ./uploads:/app/uploads    # Add this line
    environment:
      - PYTHONUNBUFFERED=1
    restart: unless-stopped
```

**Benefits:**
- ✅ Images persist on VM disk
- ✅ Survive container restarts
- ✅ Can access from VM filesystem

**Drawbacks:**
- ⚠️ Takes up VM disk space
- ⚠️ Lost if VM is deleted

### Option 2: Google Cloud Storage (Recommended for Production)

Store images in Google Cloud Storage bucket instead of local filesystem.

**Benefits:**
- ✅ Permanent storage
- ✅ Accessible from anywhere
- ✅ Scalable
- ✅ Can set up automatic cleanup

**Implementation:** Would need to modify `api/main.py` to upload to GCS instead of local filesystem.

### Option 3: Don't Store Images (Current - Lightweight)

Just process and return predictions, don't save images.

**Benefits:**
- ✅ No storage needed
- ✅ Faster
- ✅ Lower costs

**Drawbacks:**
- ❌ Can't view history
- ❌ Can't re-analyze old images

## 🔍 Check Current Storage:

### See How Many Images Are Stored:

```bash
# SSH into VM
gcloud compute ssh cotton-weed-vm --zone=us-central1-a

# Check inside container
docker exec cotton_weed_api ls -lh /app/uploads/ | wc -l
docker exec cotton_weed_api du -sh /app/uploads/
```

### Clean Up Old Images:

```bash
# Inside container (removes all uploads)
docker exec cotton_weed_api rm -rf /app/uploads/*

# Or keep last 10
docker exec cotton_weed_api find /app/uploads/ -type f -mtime +7 -delete
```

## 💡 Recommendations:

### For Demo/Testing:
- **Current setup is fine** - images are temporary
- Clean up periodically if needed
- Don't worry about persistence

### For Production:
- **Use Google Cloud Storage** - permanent, scalable
- Or mount volume for persistence
- Set up automatic cleanup of old images

## 🎯 For Your Use Case:

Since you're doing a demo:
- ✅ Current setup works fine
- ✅ Images are processed and predictions returned
- ✅ Images are temporary (cleaned up automatically)
- ⚠️ If you need to show image history, consider mounting a volume

---

**Bottom Line:** Yes, images are stored on the VM, but inside the container (temporary). They'll be lost if the container restarts, but that's usually fine for a demo!

