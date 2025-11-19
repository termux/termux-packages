#!/bin/sh
set -e -u

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)

BUILDSCRIPT_NAME="build-package.sh"

if [ "${1:-}" = "-p" ] || [ "${1:-}" = "--pre-check-if-will-build-packages" ]; then
	shift 1
	TERMUX_DOCKER__CONTAINER_EXEC_COMMAND__PRE_CHECK_IF_WILL_BUILD_PACKAGES="true"
fi

# If 'build-package-dry-run-simulation.sh' does not return 85 (EX_C__NOOP), or if
# $1 (the first argument passed to this script which runs docker) does not contain
# $BUILDSCRIPT_NAME, this condition will evaluate false and this script which
# runs docker will continue.
if [ "${TERMUX_DOCKER__CONTAINER_EXEC_COMMAND__PRE_CHECK_IF_WILL_BUILD_PACKAGES:-}" = "true" ]; then
	case "${1:-}" in
		*"/$BUILDSCRIPT_NAME")
			RETURN_VALUE=0
			OUTPUT="$("$TERMUX_SCRIPTDIR/scripts/bin/build-package-dry-run-simulation.sh" "$@" 2>&1)" || RETURN_VALUE=$?
			if [ $RETURN_VALUE -ne 0 ]; then
				echo "$OUTPUT" 1>&2
				if [ $RETURN_VALUE -eq 85 ]; then # EX_C__NOOP
					echo "$0: Exiting since '$BUILDSCRIPT_NAME' would not have built any packages"
					exit 0
				fi
				exit $RETURN_VALUE
			fi
			;;
	esac
fi

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

if [ "${CI:-}" = "true" ]; then
	CI_OPT="--env CI=true"
else
	CI_OPT=""
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

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

echo "Running container '$CONTAINER_NAME' from image '$TERMUX_BUILDER_IMAGE_NAME'..."

# Check whether attached to tty and adjust docker flags accordingly.
if [ -t 1 ]; then
	DOCKER_TTY=" --tty"
else
	DOCKER_TTY=""
fi

$SUDO docker start $CONTAINER_NAME >/dev/null 2>&1 || {
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
		if [ $(id -u) -ne 1001 -a $(id -u) -ne 0 ]; then
			echo "Changed builder uid/gid... (this may take a while)"
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo chown -R $(id -u) $CONTAINER_HOME_DIR
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo chown -R $(id -u) /data
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo usermod -u $(id -u) builder
			$SUDO docker exec $DOCKER_TTY $CONTAINER_NAME sudo groupmod -g $(id -g) builder
		fi
	fi
}

# Set traps to ensure that the process started with docker exec and all its children are killed. 
. "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__setup_docker_exec_traps

if [ "$#" -eq "0" ]; then
	set -- bash
fi

$SUDO docker exec $CI_OPT --env "DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH" --interactive $DOCKER_TTY $CONTAINER_NAME "$@"
