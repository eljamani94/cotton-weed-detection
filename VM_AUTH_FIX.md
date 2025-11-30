# Fix Authentication on Container-Optimized OS

## Option 1: Try Pulling Directly (Easiest)

The VM's service account might already have permissions. Try:

```bash
# Try pulling directly (might work if service account has permissions)
docker pull gcr.io/cotton-weed-detection-app/api:latest
docker pull gcr.io/cotton-weed-detection-app/app:latest
```

If this works, skip authentication!

## Option 2: Install gcloud on COS

If pulling fails, install gcloud:

```bash
# Download and install gcloud
curl https://sdk.cloud.google.com | bash

# Restart shell or source
exec -l $SHELL

# Initialize (will ask you to log in)
gcloud init --no-launch-browser

# Configure Docker
gcloud auth configure-docker
```

## Option 3: Use Service Account Key (Alternative)

If gcloud installation is problematic, we can use a service account key file, but this is more complex.

## Option 4: Make Images Public (Quick Fix)

As a temporary solution, you can make the images public in Google Cloud Console, then pull without authentication.

---

**Try Option 1 first!** The VM's service account might already have access.

