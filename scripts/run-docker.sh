#!/bin/bash
set -e -u

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)
: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}

BUILDSCRIPT_NAME="build-package.sh"

: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}
: ${TERMUX_DOCKER_RUN_EXTRA_ARGS:=}
: ${TERMUX_DOCKER_EXEC_EXTRA_ARGS:=}
CONTAINER_HOME_DIR=/home/builder

_show_usage() {
	echo "Usage: $0 [OPTIONS] [COMMAND]"
	echo ""
	echo "Run a command in the Termux package builder container. If no command is given, an interactive shell will be started."
	echo ""
	echo "Options:"
	echo "  -h, --help                 Show this help message and exit"
	echo "  -d, --dry-run              Run 'build-package-dry-run-simulation.sh' before"
	echo "                             building any package. This is useful for CI to"
	echo "                             skip unnecessary docker runs."
	echo "  -m, --mount-termux-dirs    Mount /data and ~/.termux-build into the container."
	echo "                             This is useful for building locally for development"
	echo "                             with host IDE and editors."
	echo "Supported environment variables:"
	echo "  TERMUX_BUILDER_IMAGE_NAME     The name of the Docker image to use"
	echo "  CONTAINER_NAME                The name of the Docker container to create/use"
	echo "  TERMUX_DOCKER_RUN_EXTRA_ARGS  Extra arguments to pass to 'docker run' while"
	echo "                                creating the container"
	echo "  TERMUX_DOCKER_EXEC_EXTRA_ARGS Extra arguments to pass to 'docker exec' while"
	echo "                                running the command in the container"
	echo "  TERMUX_DOCKER_USE_SUDO        If set to any non-empty value, 'sudo' will be"
	echo "                                used to run 'docker' commands"
	echo ""
	echo ""
	echo "Kindly note that:"
	echo "- TERMUX_DOCKER_RUN_EXTRA_ARGS is only considered when creating the container,"
	echo "  and will not be applied when running the command in the container if the"
	echo "  container already exists."
	echo "- To apply new TERMUX_DOCKER_RUN_EXTRA_ARGS, the existing container needs to be"
	echo "  removed first."
	echo "- The above rules also apply to -m/--mount-termux-dirs option as it adds the"
	echo "  mount arguments to TERMUX_DOCKER_RUN_EXTRA_ARGS."
	echo "- The dry-run option will only work if the first argument passed to this script"
	echo "  which runs docker contains '$BUILDSCRIPT_NAME', and it will run"
	echo "  'build-package-dry-run-simulation.sh' with arguments passed to this script."
	exit 0
}

dry_run="false"

while (( $# != 0 )); do
	case "$1" in
		-h|--help) shift 1; _show_usage;;
		-d|--dry-run)
			dry_run="true"
			shift 1;;
		-m|--mount-termux-dirs)
			TERMUX_DOCKER_RUN_EXTRA_ARGS="--volume /data:/data --volume $HOME/.termux-build:$CONTAINER_HOME_DIR/.termux-build $TERMUX_DOCKER_RUN_EXTRA_ARGS"
			shift 1;;
		--) shift 1; break;;
		-*) echo "Error: Unknown option '$1'" 1>&2; shift 1; exit 1;;
		*) break;;
	esac
done

# If 'build-package-dry-run-simulation.sh' does not return 85 (EX_C__NOOP), or if
# $1 (the first argument passed to this script which runs docker) does not contain
# $BUILDSCRIPT_NAME, this condition will evaluate false and this script which
# runs docker will continue.
if [ "${dry_run}" = "true" ]; then
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

UNAME=$(uname)
if [ "$UNAME" = Darwin ]; then
	# Workaround for mac readlink not supporting -f.
	REPOROOT=$PWD
	SEC_OPT=""
else
	REPOROOT="$(dirname $(readlink -f $0))/../"
	SEC_OPT=" --security-opt seccomp=$REPOROOT/scripts/profile.json --security-opt apparmor=_custom-termux-package-builder-$CONTAINER_NAME --cap-add CAP_SYS_ADMIN --device /dev/fuse"
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

APPARMOR_PARSER=""
if command -v apparmor_parser > /dev/null; then
	APPARMOR_PARSER="apparmor_parser"
fi

if [ -z "$APPARMOR_PARSER" ] || ! $SUDO aa-status --enabled; then
	echo "WARNING: apparmor_parser not found, AppArmor profiles will not be loaded!"
	echo "         This is not recommended, as it may cause security issues and unexpected behavior"
	echo "         Avoid executing untrusted code in the container"
	APPARMOR_PARSER=""
fi

load_apparmor_profile() {
	local profile_path="$1"
	local msg="${2:-}"
	if [ -n "$APPARMOR_PARSER" ]; then
		if [ -n "$msg" ]; then
			echo "$msg..."
		fi
		cat "$profile_path" | sed -e "s/{{CONTAINER_NAME}}/$CONTAINER_NAME/g" | sudo "$APPARMOR_PARSER" -rK
	fi
}

# Load the relaxed AppArmor profile first as we might need to change permissions
load_apparmor_profile ./scripts/profile-relaxed.apparmor

$SUDO docker start $CONTAINER_NAME >/dev/null 2>&1 || {
	echo "Creating new container..."
	$SUDO docker run \
		--detach \
		--init \
		--name $CONTAINER_NAME \
		--volume $VOLUME \
		$SEC_OPT \
		--tty \
		$TERMUX_DOCKER_RUN_EXTRA_ARGS \
		$TERMUX_BUILDER_IMAGE_NAME
	if [ "$UNAME" != Darwin ]; then
		if [ $(id -u) -ne 1001 -a $(id -u) -ne 0 ]; then
			echo "Changed builder uid/gid... (this may take a while)"
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo chown -R $(id -u):$(id -g) $CONTAINER_HOME_DIR
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo chown -R $(id -u):$(id -g) /data
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo usermod -u $(id -u) builder
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo groupmod -g $(id -g) builder
		fi
	fi
}

load_apparmor_profile ./scripts/profile-restricted.apparmor "Loading restricted AppArmor profile"

# Set traps to ensure that the process started with docker exec and all its children are killed.
. "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__setup_docker_exec_traps

if [ "$#" -eq "0" ]; then
	set -- bash
fi

$SUDO docker exec $CI_OPT --env "DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH" --interactive $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME "$@"
