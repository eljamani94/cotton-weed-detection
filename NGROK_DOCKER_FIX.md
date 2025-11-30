# Fix ngrok Docker Permission Issue

## Solution: Create Directory First

```bash
# Create the ngrok config directory with proper permissions
mkdir -p ~/.ngrok2
chmod 755 ~/.ngrok2

# Now try the config command again
docker run -it --rm -v ~/.ngrok2:/home/ngrok/.ngrok2 ngrok/ngrok config add-authtoken 35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE
```

## Alternative: Use Environment Variable

```bash
# Configure using environment variable (no file needed)
docker run -it --rm -e NGROK_AUTHTOKEN=35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE ngrok/ngrok http 8501
```

This way you don't need to save the config file, just pass it as an environment variable each time.

## Start Tunnel (After Config):

```bash
# If config worked, start tunnel
docker run -it --rm -p 4040:4040 --network host -v ~/.ngrok2:/home/ngrok/.ngrok2 ngrok/ngrok http 8501
```

## Or Use Environment Variable Method (Easier):

```bash
# Start tunnel with auth token as environment variable
docker run -it --rm -p 4040:4040 --network host -e NGROK_AUTHTOKEN=35eWfnSH6RpchTuzemgzmKMepBt_4gFYXzpXZ6w7uFBotcpzE ngrok/ngrok http 8501
```

This is simpler - no config file needed!

