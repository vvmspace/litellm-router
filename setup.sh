#!/bin/bash

# Exiting promptly should matters go terribly pear-shaped.
set -e

ENV_FILE=".env"
CONFIG_FILE="config.yaml"

# Function to sanitize and extract keys, ensuring they are strictly comma-separated.
extract_keys() {
    local cleaned
    # Strip potential 'VAR=' prefixes and quotation marks
    cleaned=$(echo "$1" | sed 's/^[^=]*=//; s/["'\'']//g')
    # Convert spaces and semicolons to commas, squeeze multiple commas, and trim the edges
    echo "$cleaned" | tr ' ;' ',' | tr -s ',' | sed 's/^,//; s/,$//'
}

echo "🎩 Good morning. Let us attend to your affairs with due diligence."

# 1. Procuring the environment variables.
if [ -f "$ENV_FILE" ]; then
    echo "📂 Found an existing .env file. Using it for our proceedings."
    # A much more elegant way to source variables without breaking quotes or tripping over hyphens.
    set -a
    source "$ENV_FILE"
    set +a
fi

if [ -z "$GOOGLE_API_KEYS" ]; then
    read -p "🔑 No keys found. Please enter your GOOGLE_API_KEYS: " RAW_INPUT
    GOOGLE_API_KEYS=$(extract_keys "$RAW_INPUT")
    echo "GOOGLE_API_KEYS=\"$GOOGLE_API_KEYS\"" >> "$ENV_FILE"
fi

# 2. Managing the port preference.
CURRENT_PORT=$(grep -E '^PORT=' "$ENV_FILE" | cut -d '=' -f 2 || echo "7070")
read -p "⚙️  Specify a port [Current/Default: $CURRENT_PORT]: " CUSTOM_PORT
PORT=${CUSTOM_PORT:-$CURRENT_PORT}

if grep -q '^PORT=' "$ENV_FILE"; then
    sed -i "s/^PORT=.*/PORT=$PORT/" "$ENV_FILE"
else
    echo "PORT=$PORT" >> "$ENV_FILE"
fi
echo "✅ Port $PORT has been secured in your .env file."

# 3. Security and Redis configuration.
read -p "🔐 Shall we establish a Master Key to fortify your proxy? [y/N]: " SET_MASTER_KEY
if [[ "$SET_MASTER_KEY" =~ ^[Yy]$ ]]; then
    read -p "Enter your secret key [Default: sk-vibe-super-secret-key]: " MASTER_KEY
    MASTER_KEY=${MASTER_KEY:-sk-vibe-super-secret-key}
    echo "✅ Master Key configured: $MASTER_KEY"
    
    cat <<EOF > "$CONFIG_FILE"
general_settings:
  master_key: "$MASTER_KEY" # Key for Vibe IDE
  # Enable caching at the LiteLLM level (via Redis)
  enable_cache: true

EOF
else
    echo "🛡️ The proxy shall remain open; all tokens will be accepted."
    cat <<EOF > "$CONFIG_FILE"
general_settings:
  # Enable caching at the LiteLLM level (via Redis)
  enable_cache: true

EOF
fi

# Append router settings (Redis and Caching strategy)
cat <<EOF >> "$CONFIG_FILE"
router_settings:
  # Retention strategy: routes requests to a single active key,
  # safeguarding the Gemini context cache from frequent resets.
  routing_strategy: "least-busy"
  redis_host: "redis"
  redis_port: 6379

model_list:
EOF

echo "📝 Commissioning the $CONFIG_FILE..."

# 4. Assembling the model list.
# We set the Internal Field Separator (IFS) to a comma to properly read the array.
IFS=',' read -ra RAW_KEYS <<< "$GOOGLE_API_KEYS"
MODELS=("gemini-3.5-pro" "gemini-3.5-flash" "gemma-4")

for model in "${MODELS[@]}"; do
    for key in "${RAW_KEYS[@]}"; do
        # We ensure no empty strings make their way into the config
        if [ -n "$key" ]; then
            cat <<EOF >> "$CONFIG_FILE"
  - model_name: $model
    litellm_params:
      model: gemini/$model
      api_key: "$key"
EOF
        fi
    done
done

# 5. Finalizing the architecture.
echo "✨ The arrangements have been flawlessly concluded."

if ! docker info > /dev/null 2>&1; then
    echo "⚠️ Your Docker daemon is presently taking a nap. Do awaken it and run 'docker compose up -d'."
else
    read -p "🚀 Shall we set sail immediately? [Y/n]: " START_DOCKER
    START_DOCKER=${START_DOCKER:-Y} 

    if [[ "$START_DOCKER" =~ ^[Yy]$ ]]; then
        docker compose up -d
        echo "==================================================="
        echo "🎩 SERVICE SUCCESSFULLY COMMISSIONED ON PORT $PORT"
        echo "==================================================="
    fi
fi