#!/bin/bash
cd /opt/netalertx || exit 1

# Extract image name (handling potential quotes or comments)
IMAGE=$(grep "image:" docker-compose.yml | head -n 1 | awk '{print $2}' | tr -d '"' | tr -d "'")

if [ -z "$IMAGE" ]; then
    echo "Could not find image in docker-compose.yml"
    exit 1
fi

echo "Checking for updates for $IMAGE..."
/usr/bin/docker pull "$IMAGE"
