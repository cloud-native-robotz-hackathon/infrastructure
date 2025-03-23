## Build

```bash
export VERSION=$(date +"%Y%m%dT%H%M%S")
export IMAGE=quay.io/openshift-examples/ubi-haproxy:$VERSION
podman manifest rm ${IMAGE}
podman build --platform linux/amd64,linux/arm64  --manifest ${IMAGE}  .
podman manifest push ${IMAGE}
```