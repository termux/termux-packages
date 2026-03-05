#!/usr/bin/bash
set -eou pipefail
TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ../..; pwd)

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}
: ${TERMUX_DOCKER_RUN_EXTRA_ARGS:=}
: ${TERMUX_DOCKER_EXEC_EXTRA_ARGS:=}


cd "$(dirname "$0")"

if [[ ! -d lib/ ]]; then
	mkdir lib/
fi

if [[ ! -d "lib/${TERMUX_BUILDER_IMAGE_NAME//\//_}" ]]; then
	mkdir "lib/${TERMUX_BUILDER_IMAGE_NAME//\//_}"
	(
		cd "$TERMUX_SCRIPTDIR"
		./scripts/run-docker.sh echo "Copying lib from container to host for the first time. This may take a while..."
		cd "$(dirname "$0")"
	)
	$SUDO docker cp "$CONTAINER_NAME:/home/builder/lib" "lib/${TERMUX_BUILDER_IMAGE_NAME//\//_}/"
	$SUDO docker container rm -f "$CONTAINER_NAME"
fi

cd "$TERMUX_SCRIPTDIR"

# Make sure output directory is tmpfs to not fuck disk with unnecessary I/O
if ! mountpoint -q ./output; then
	sudo mount -t tmpfs -o size=64G termux-docker ./output/
fi

TERMUX_DOCKER_RUN_EXTRA_ARGS+=" --volume $HOME/termux-apt-repo:/apt:ro"
TERMUX_DOCKER_RUN_EXTRA_ARGS+=" --volume $PWD/output/${CONTAINER_NAME}/home:/home/builder/"
TERMUX_DOCKER_RUN_EXTRA_ARGS+=" --volume $PWD/scripts/personal/lib/${TERMUX_BUILDER_IMAGE_NAME//\//_}/lib:/home/builder/lib"
TERMUX_DOCKER_RUN_EXTRA_ARGS+=" --volume $PWD/output/${CONTAINER_NAME}/data:/data" \

env \
	CONTAINER_NAME="$CONTAINER_NAME" \
	TERMUX_BUILDER_IMAGE_NAME="$TERMUX_BUILDER_IMAGE_NAME" \
	TERMUX_DOCKER_RUN_EXTRA_ARGS="$TERMUX_DOCKER_RUN_EXTRA_ARGS" \
	TERMUX_DOCKER_EXEC_EXTRA_ARGS="$TERMUX_DOCKER_EXEC_EXTRA_ARGS" \
	./scripts/run-docker.sh "$@"
