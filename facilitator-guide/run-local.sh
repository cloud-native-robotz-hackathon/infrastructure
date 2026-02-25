#!/bin/bash

IMAGE=quay.io/cloud-native-robotz-hackathon/facilitator-guide-builder:202602141820

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change to the facilitator-guide directory
cd "$SCRIPT_DIR"

# Verify mkdocs.yml exists
if [ ! -f "mkdocs.yml" ]; then
    echo "Error: mkdocs.yml not found in $SCRIPT_DIR"
    echo "Please run this script from the facilitator-guide directory or ensure mkdocs.yml exists."
    exit 1
fi

echo "Starting documentation server with live reload on http://localhost:8080"
echo "Press Ctrl+C to stop the server"
echo ""
echo "The server will automatically reload when you make changes to:"
echo "  - content/"
echo "  - mkdocs.yml" 
echo "  - overrides/"
echo ""
echo "Working directory: $SCRIPT_DIR"
echo ""

podman run -ti --rm \
  -v "$SCRIPT_DIR":/opt/app-root/src:z \
  --workdir /opt/app-root/src \
  -p 8080:8080 \
  --name docs-local \
  $IMAGE

