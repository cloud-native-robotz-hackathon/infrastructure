IMAGE=docs-local

podman build -t $IMAGE facilitator-guide/
podman run -ti --user 0 --rm \
  -v $(pwd):/opt/app-root/src:z \
  --workdir /opt/app-root/src/facilitator-guide/ \
  -p 8080:8080 docs-local

