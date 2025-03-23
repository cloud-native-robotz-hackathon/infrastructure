export VERSION=$(date +"%Y%m%dT%H%M%S")
export IMAGE=quay.io/cloud-native-robotz-hackathon/ubi-traefik:$VERSION
echo "Build $IMAGE"
podman manifest rm ${IMAGE} 2>/dev/null

podman build --platform linux/amd64,linux/arm64  --manifest ${IMAGE}  .
podman manifest push ${IMAGE}
echo "Done $IMAGE"
