# Fix Docker Compose Installation

## Option 1: Check if Docker Compose Plugin is Available (Easier!)

Modern Docker often includes compose as a plugin. Try:

```bash
# Check if docker compose (with space) works
docker compose version
```

If that works, you can use `docker compose` instead of `docker-compose`!

## Option 2: Install Standalone Docker Compose

If the plugin doesn't work, install the standalone version:

```bash
# Create the directory if it doesn't exist
sudo mkdir -p /usr/local/bin

# Now install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Make it executable
sudo chmod +x /usr/local/bin/docker-compose

# Verify
docker-compose --version
```

## Option 3: Use Docker Compose Plugin (Recommended)

If `docker compose version` works, you can use:

```bash
# Instead of: docker-compose up -d
docker compose up -d

# Instead of: docker-compose ps
docker compose ps

# etc.
```

The plugin is built into Docker and doesn't need separate installation!

