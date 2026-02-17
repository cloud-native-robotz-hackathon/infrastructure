# Facilitator guide

```shell
export VERSION=$(date +%Y%m%d%H%M)
export IMAGE="quay.io/cloud-native-robotz-hackathon/facilitator-guide-builder:${VERSION}"

podman build --platform linux/amd64,linux/arm64  --manifest ${IMAGE}  .
podman manifest push ${IMAGE}


```
