# Automation

```bash
export KUBECONFIG=kubeconfig-data-center
oc login -u admin --insecure-skip-tls-verify https://api.cluster-...
```

## Rebuild execution environment

```bash
podman login registry.redhat.io
export VERSION=$(date +%Y%m%d%H%M)

ansible-builder build \
    --verbosity 3 \
    --container-runtime podman \
    --file execution-environment-fedora-based.yml \
    --extra-build-cli-args "--platform linux/amd64,linux/arm64  --manifest quay.io/cloud-native-robotz-hackathon/infrastructure-robot-execution-environment:$VERSION"

    --tag quay.io/cloud-native-robotz-hackathon/infrastructure-robot-execution-environment:$VERSION \
podman login quay.io
podman push quay.io/cloud-native-robotz-hackathon/infrastructure-robot-execution-environment:$VERSION
```

## Ansible-navigator via Podman Desktop (for example MacOS)

```
podman machine init \
    --volume /private:/private \
    --volume /Volumes/Development:/Volumes/Development \
    --volume /Users:/Users \
    --volume /var/folders:/var/folders \
    --memory 4096 podman-machine-default
```
