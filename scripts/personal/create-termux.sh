#!/usr/bin/bash
set -euo pipefail

if (( $# != 2 )); then
	echo "Usage: $0 <architecture> <container_name_suffix>"
	echo "architecture can be one of: aarch64, arm, i686, x86_64"
	exit 1
fi

ARCH="$1"
TERMUX_DOCKER_CONTAINER_PREFIX="termux-docker-container-"
TERMUX_DOCKER_IMAGE_NAME="termux/termux-docker:$ARCH-base"
CONTAINER_NAME="${TERMUX_DOCKER_CONTAINER_PREFIX}$2"

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

$SUDO docker run \
	-dit \
	--volume $HOME/termux-apt-repo:/apt:ro \
	--volume $PWD:/data/data/com.termux/files/home/termux-packages:rw \
	--name "$CONTAINER_NAME" \
	"$TERMUX_DOCKER_IMAGE_NAME"

$SUDO docker container stop "$CONTAINER_NAME"
