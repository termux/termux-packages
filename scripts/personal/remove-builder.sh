#!/usr/bin/bash
set -euo pipefail
TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ../..; pwd)

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

: ${CONTAINER_NAME:=termux-package-builder}


_remove_container() {
	$SUDO docker container rm -f "$1"
	rm -rf "output/_builder/$1"
}

if (( "$#" > 1 )); then
	for CONTAINER_NAME in "$@"; do
		_remove_container "$CONTAINER_NAME"
	done
else
	_remove_container "$CONTAINER_NAME"
fi
