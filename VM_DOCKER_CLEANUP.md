# 🧹 Docker Image Storage on VM

## What Happened When You Pulled the New Image

When you pulled `gcr.io/cotton-weed-detection-app/app:latest` again:

1. ✅ **Old image tag was moved** to the new image
2. ⚠️ **Old image became "dangling"** (untagged but still on disk)
3. 💾 **Both images exist** until you clean them up

## Disk Space Impact

**Short answer:** The old image is still taking up space until you clean it up.

Docker uses layer caching, so:
- If layers are **the same** → Stored once (saves space)
- If layers are **different** → Both stored (uses more space)

Since you only changed one file (`app/main.py`), **most layers are the same** and stored once. Only the changed layer is duplicated.

## Check Current Disk Usage

**On the VM**, run these commands to see what's taking up space:

```bash
# See all images (including dangling ones)
docker images -a

# See disk usage
docker system df

# See detailed disk usage
docker system df -v
```

You'll see something like:
```
Images:    2GB (1 dangling image)
Containers: 500MB
Local Volumes: 100MB
```

## Clean Up Dangling Images (Recommended)

The old image is probably still there. Clean it up:

**Option 1: Remove dangling images only**
```bash
docker image prune -f
```

This removes:
- ✅ Unused images (including the old one)
- ❌ Keeps images being used by containers

**Option 2: Remove all unused images**
```bash
docker image prune -a -f
```

⚠️ **Warning:** This removes ALL images not currently used by running containers.

**Option 3: Full cleanup (recommended)**
```bash
docker system prune -a --volumes -f
```

This removes:
- All unused images
- All unused containers
- All unused volumes
- All unused networks

⚠️ **Warning:** Only do this if you're sure! This will remove everything not currently running.

## Safe Cleanup (Recommended)

To safely clean up **just the old app image**:

```bash
# 1. See what's there
docker images gcr.io/cotton-weed-detection-app/app

# 2. See dangling images
docker images -f "dangling=true"

# 3. Remove dangling images (safe - only removes untagged images)
docker image prune -f

# 4. Check disk space freed
docker system df
```

## Check if Container is Using New Image

Verify your container is using the new image:

```bash
# Check container image ID
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"

# Inspect the app container
docker inspect cotton_weed_app | grep Image

# Check image creation time
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}" | grep app
```

## Expected Disk Space

After cleanup:
- **Before cleanup:** ~4-8GB (old + new images)
- **After cleanup:** ~2-4GB (only new image + shared layers)
- **Space saved:** ~2-4GB

## Quick Cleanup Command (One Line)

If you want to clean up everything unused safely:

```bash
docker system prune -f && docker image prune -a -f
```

This will:
- ✅ Remove all dangling images (old app image)
- ✅ Remove unused containers
- ✅ Keep images used by running containers
- ✅ Free up ~2-4GB of space

## Monitor Disk Usage

To keep an eye on disk usage in the future:

```bash
# Quick check
docker system df

# Detailed breakdown
docker system df -v | grep -E "Images|Containers|Local Volumes"
```

## Automate Cleanup (Optional)

You can set up automatic cleanup on the VM:

```bash
# Add to cron (runs daily at 2 AM)
echo "0 2 * * * docker system prune -f" | crontab -
```

---

## Summary

**What happened:**
- ✅ New image is active and working
- ⚠️ Old image still exists (taking up space)

**What to do:**
- Run `docker image prune -f` on the VM to remove old images
- This will free up ~2-4GB of space
- Your container will continue working normally

**TL;DR:** The old image is still there taking up space. Run `docker image prune -f` on the VM to clean it up safely. 🧹

