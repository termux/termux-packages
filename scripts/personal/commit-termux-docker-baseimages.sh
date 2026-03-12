#!/usr/bin/bash
set -euo pipefail

TERMUX_DOCKER_CONTAINER_PREFIX="termux-docker-container-"

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

for ARCH in i686 x86_64; do
	TERMUX_DOCKER_IMAGE_NAME="termux/termux-docker:$ARCH" ./scripts/personal/create-termux-docker-runner.sh "$ARCH" "$ARCH-base"
	$SUDO docker commit "${TERMUX_DOCKER_CONTAINER_PREFIX}${ARCH}-base" "termux/termux-docker:${ARCH}-base"
done
