# Fix ngrok Permissions

## Fix the Permission Issue:

```bash
# Check if file exists
ls -la ~/bin/ngrok

# Fix permissions
chmod +x ~/bin/ngbin/ngrok

# Verify permissions
ls -la ~/bin/ngrok
# Should show: -rwxr-xr-x (executable)

# Try again
~/bin/ngrok config add-authtoken 35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE
```

## Alternative: Install in Different Location

If permissions still don't work, try installing in home directory:

```bash
# Download to home directory
cd ~
curl -O https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz

# Extract
tar xvzf ngrok-v3-stable-linux-amd64.tgz

# Make executable
chmod +x ngrok

# Configure
./ngrok config add-authtoken 35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE

# Test
./ngrok version
```

## Start ngrok Tunnel:

```bash
# From home directory
./ngrok http 8501

# Or if in ~/bin
~/bin/ngrok http 8501
```

