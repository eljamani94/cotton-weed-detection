# Install Docker Compose on Container-Optimized OS

The VM uses Container-Optimized OS which has a read-only root filesystem. Install docker-compose in your home directory instead.

## Solution: Install in Home Directory

```bash
# Install docker-compose in your home directory
mkdir -p ~/bin
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o ~/bin/docker-compose

# Make it executable
chmod +x ~/bin/docker-compose

# Add to PATH (for current session)
export PATH=$PATH:~/bin

# Verify
~/bin/docker-compose --version
```

## Make it Permanent (Optional)

To make it available every time you SSH in:

```bash
# Add to .bashrc
echo 'export PATH=$PATH:~/bin' >> ~/.bashrc
source ~/.bashrc
```

## Alternative: Use Docker Compose via Docker

You can also run docker-compose as a Docker container:

```bash
# Create an alias
alias docker-compose='docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w "$PWD" docker/compose:latest'

# Then use it normally
docker-compose --version
docker-compose up -d
```

