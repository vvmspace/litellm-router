#!/bin/bash

set -e

REPO_URL="https://github.com/vvmspace/litellm-router.git"
REPO_NAME="litellm-router"

HOUR=$(date +%H)
if [ $HOUR -ge 4 ] && [ $HOUR -lt 12 ]; then
    GREETING="Good morning"
elif [ $HOUR -ge 12 ] && [ $HOUR -lt 18 ]; then
    GREETING="Good afternoon"
else
    GREETING="Good evening"
fi
echo "🎩 $GREETING. Pray allow me to assist you with this endeavour."
echo "📦 I shall now procure the litellm-router project for your convenience..."

# Check if git is available
if command -v git &> /dev/null; then
    if [ -d "$REPO_NAME" ]; then
        echo "📂 I observe the repository is already present. Permit me to fetch the latest amendments..."
        cd "$REPO_NAME"
        git pull
    else
        echo "📥 Commencing the cloning procedure..."
        git clone "$REPO_URL"
        cd "$REPO_NAME"
    fi
else
    echo "⚠️ I regret to inform you that git appears to be absent. I shall endeavour to acquire the files via alternative means..."
    if [ -d "$REPO_NAME" ]; then
        echo "📂 The directory already exists, I'm afraid. I shall remove it to make way for the fresh acquisition..."
        rm -rf "$REPO_NAME"
    fi
    mkdir "$REPO_NAME"
    cd "$REPO_NAME"
    
    # Download main files
    echo "📥 Acquiring the setup script..."
    curl -fsSL https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/setup.sh -o setup.sh
    
    echo "📥 Procuring the docker composition..."
    curl -fsSL https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/docker-compose.yml -o docker-compose.yml
    
    echo "📥 Fetching the environment configuration template..."
    curl -fsSL https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/.env.example -o .env
    
    echo "📥 Attempting to acquire the Dockerfile..."
    curl -fsSL https://raw.githubusercontent.com/vvmspace/litellm-router/refs/heads/main/Dockerfile -o Dockerfile 2>/dev/null || true
fi

echo "✅ The project has been successfully procured."
echo "🚀 I shall now proceed to execute the setup script..."

chmod +x setup.sh
./setup.sh
