IMAGE=docs-local

podman build -t $IMAGE .
podman run -ti --user 0 --rm \
  -v $(pwd):/opt/app-root/src:z \
  -p 8080:8080 docs-local

