#!/bin/bash
set -e

# Build RPi Image Locally (dev)
# Refactored from .vscode/tasks.json

echo "Starting Local Build (dev)..."

# Fix permissions on tmp (from original task)
# Warning: This is broad, but preserved from original task logic.
if id "vscode" &>/dev/null; then
    echo "Ensuring /tmp ownership for vscode user..."
    sudo chown -R vscode /tmp
fi

# Clean previous artifacts
echo "Cleaning previous artifacts..."
rm -rf /tmp/artifacts

# Run act
echo "Running act workflow (variant: dev)..."
# Using time to measure duration
time act -j build \
    --matrix variant:dev \
    -P ubuntu-latest=catthehacker/ubuntu:act-latest \
    --container-options "--privileged" \
    --artifact-server-path /tmp/artifacts

echo "Extracting and Renaming..."

# Define target directory
# Using relative path for portability
TARGET_DIR="netalertx-rpi-image-dev"
# Cleanup target directory to avoid confusion with previous builds
sudo rm -rf "$TARGET_DIR"
mkdir -p "$TARGET_DIR"

# Extract artifacts from the act artifact server output
if [ -d "/tmp/artifacts" ]; then
    # Look for the specific matrix artifact
    ARTIFACT_ZIP=$(find /tmp/artifacts -name "*artifacts-dev*.zip" | head -n 1)
    if [ -n "$ARTIFACT_ZIP" ]; then
        echo "Found artifact: $ARTIFACT_ZIP"
        unzip -oj "$ARTIFACT_ZIP" -d "$TARGET_DIR"
    else
        echo "Dev artifact not found, extracting all zips..."
        find /tmp/artifacts -name "*.zip" -exec unzip -oj {} -d "$TARGET_DIR" \;
    fi
else
    echo "Warning: /tmp/artifacts not found. Did the build succeed?"
    exit 1
fi

echo "Directory contents:"
ls -la "$TARGET_DIR"

# Generate repo_local.json from fragment
FRAGMENT="$TARGET_DIR/fragment_local_dev.json"
if [ -f "$FRAGMENT" ]; then
    echo "Generating repo_local.json from fragment..."
    # We need jq installed locally for this to work elegantly, 
    # but we can do simple wrapping since we know the structure.
    if command -v jq &> /dev/null; then
        jq -n '{os_list: [inputs]}' "$FRAGMENT" > "$TARGET_DIR/repo_local.json"
    else
        # Fallback if jq is missing: manual concatenation
        echo "{ \"os_list\": [" > "$TARGET_DIR/repo_local.json"
        cat "$FRAGMENT" >> "$TARGET_DIR/repo_local.json"
        echo "] }" >> "$TARGET_DIR/repo_local.json"
    fi
    echo "Created repo_local.json"
    
    # Cleanup fragments locally
    sudo rm "$TARGET_DIR"/fragment_*.json
else
    echo "Warning: fragment_local_dev.json not found. repo_local.json cannot be generated."
fi

# Validation output
IMG_FILE=$(find "$TARGET_DIR" -name "*.img.xz" | head -n 1)

if [ -f "$IMG_FILE" ]; then
    echo "Found image: $IMG_FILE"
else
    echo "Error: No .img.xz file found in $TARGET_DIR"
    exit 1
fi

# Set broad permissions for local access
chmod -R 777 "$TARGET_DIR"

echo "Done! Artifacts ready in $TARGET_DIR/"
ls -lh "$TARGET_DIR"
