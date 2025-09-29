#!/bin/bash

IMAGE=docs-local

echo "Building documentation container..."
podman build -t $IMAGE .

echo "Starting documentation server with live reload on http://localhost:8080"
echo "Press Ctrl+C to stop the server"
echo ""
echo "The server will automatically reload when you make changes to:"
echo "  - content/"
echo "  - mkdocs.yml" 
echo "  - overrides/"
echo ""

podman run -ti --rm \
  -v $(pwd):/opt/app-root/src:z \
  -p 8080:8080 \
  --name docs-local \
  $IMAGE

