#!/bin/sh
set -e -u

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)

CONTAINER_HOME_DIR=/home/builder
UNAME=$(uname)
if [ "$UNAME" = Darwin ]; then
	# Workaround for mac readlink not supporting -f.
	REPOROOT=$PWD
	SEC_OPT=""
else
	REPOROOT="$(dirname $(readlink -f $0))/../"
	SEC_OPT=" --security-opt seccomp=$REPOROOT/scripts/profile.json"
fi

# Required for Linux with SELinux and btrfs to avoid permission issues, eg: Fedora
# To reset, use "restorecon -Fr ."
# To check, use "ls -Z ."
if [ -n "$(command -v getenforce)" ] && [ "$(getenforce)" = Enforcing ]; then
	VOLUME=$REPOROOT:$CONTAINER_HOME_DIR/termux-packages:z
else
	VOLUME=$REPOROOT:$CONTAINER_HOME_DIR/termux-packages
fi

: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}

USER=builder

if [ $(id -u) -ne 0 ]; then
	SUDO="sudo"
else
	SUDO=""
fi

if [ "$#" -eq "0" ]; then
	set -- bash
fi
STOP_CONTAINER=false
if [ "$1" = "--stop" ]; then
	STOP_CONTAINER=true
fi

if [ "$STOP_CONTAINER" = "false" ]; then
	echo "Running container '$CONTAINER_NAME' from image '$TERMUX_BUILDER_IMAGE_NAME'..."
fi

# Check whether attached to tty and adjust docker flags accordingly.
if [ -t 1 ]; then
	DOCKER_TTY=" --tty"
else
	DOCKER_TTY=""
fi

$SUDO docker start $CONTAINER_NAME >/dev/null 2>&1 || {
	if [ "$STOP_CONTAINER" = "true" ]; then
		echo "Container is not running."
		exit 1
	fi
	echo "Creating new container..."
	$SUDO docker run \
		--detach \
		--init \
		--name $CONTAINER_NAME \
		--volume $VOLUME \
		$SEC_OPT \
		--tty \
		$TERMUX_BUILDER_IMAGE_NAME
	if [ "$UNAME" != Darwin ]; then
		REPO_UID="$(stat -c %u $REPOROOT)"
		REPO_GID="$(stat -c %g $REPOROOT)"
		if [ "$REPO_UID" -eq "0" ]; then
			echo "Warning, the repository is cloned by root. Because of this, some script functions will not work in container."
		elif [ $REPO_UID -ne 1001 ]; then
			echo "Changed builder uid/gid... (this may take a while)"
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo chown -R $REPO_UID $CONTAINER_HOME_DIR
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo chown -R $REPO_UID /data
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo usermod -u $REPO_UID builder
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo groupmod -g $REPO_GID builder
		fi
	fi
}

if [ "$STOP_CONTAINER" = "true" ]; then
	echo "Stopping container '$CONTAINER_NAME'..."
	$SUDO docker stop $CONTAINER_NAME >/dev/null 2>&1
	$SUDO docker rm $CONTAINER_NAME >/dev/null 2>&1
else
	# Set traps to ensure that the process started with docker exec and all its children are killed.
	. "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__setup_docker_exec_traps
	$SUDO docker exec --env "DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH" --interactive $DOCKER_TTY $CONTAINER_NAME "$@"
fi
