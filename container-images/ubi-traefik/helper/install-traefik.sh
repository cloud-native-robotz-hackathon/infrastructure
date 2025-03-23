#!/usr/bin/env bash

ARCH=$(uname -i)


case $ARCH in

  aarch64)
    GO_ARCH=arm64
    ;;

  x86_64)
    GO_ARCH=amd64
    ;;
  *)
    exit 99
    ;;
esac

echo "Download traefik_v2.11.21_linux_${GO_ARCH}.tar.gz"
curl -# -L -O https://github.com/traefik/traefik/releases/download/v2.11.21/traefik_v2.11.21_linux_${GO_ARCH}.tar.gz
tar xzvf traefik_v2.11.21_linux_${GO_ARCH}.tar.gz
mv -v traefik /usr/local/bin/
rm -v traefik_v2.11.21_linux_${GO_ARCH}.tar.gz
