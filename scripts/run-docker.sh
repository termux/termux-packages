#!/bin/bash
set -euo pipefail

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)
: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}
: ${TERMUX_DOCKER_RUN_EXTRA_ARGS:=}
: ${TERMUX_DOCKER_EXEC_EXTRA_ARGS:=}
BUILDSCRIPT_NAME=build-package.sh
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
	SEC_OPT=" --security-opt seccomp=$REPOROOT/scripts/profile.json --device /dev/fuse"
	if [ -r /sys/module/apparmor/parameters/enabled ] && grep -q '^Y' /sys/module/apparmor/parameters/enabled; then
		SEC_OPT+=" --security-opt apparmor=unconfined"
	fi
fi

if [ "${CI:-}" = "true" ]; then
	CI_OPT="--env CI=true"
else
	CI_OPT=""
fi

mkdir -p "$REPOROOT/output"

if [ -n "$(command -v getenforce)" ] && [ "$(getenforce)" = Enforcing ]; then
	REPO_MOUNT=(--volume "$REPOROOT:$CONTAINER_HOME_DIR/termux-packages:ro,z")
else
	REPO_MOUNT=(--mount "type=bind,src=$REPOROOT,dst=$CONTAINER_HOME_DIR/termux-packages,readonly,bind-recursive=disabled")
fi
OUTPUT_MOUNT=(--volume "$REPOROOT/output:$CONTAINER_HOME_DIR/termux-packages/output")

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


__change_builder_uid_gid() {
	if [ "$UNAME" != Darwin ]; then
		if [ $(id -u) -ne 1001 -a $(id -u) -ne 0 ]; then
			echo "Changing builder uid/gid... (this may take a while)"
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo find $CONTAINER_HOME_DIR -xdev ! -path $CONTAINER_HOME_DIR/termux-packages -exec chown $(id -u):$(id -g) {} +
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo chown -R $(id -u):$(id -g) /data
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo usermod -u $(id -u) builder
			$SUDO docker exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo groupmod -g $(id -g) builder
		fi
	fi
}

__change_container_pid_max() {
	if [ "$UNAME" != Darwin ]; then
		echo "Changing /proc/sys/kernel/pid_max to 65535 for packages that need to run native executables using proot (for 32-bit architectures)"
		if [[ "$($SUDO docker exec $CONTAINER_NAME cat /proc/sys/kernel/pid_max)" -le 65535 ]]; then
			echo "No need to change /proc/sys/kernel/pid_max, current value is $($SUDO docker exec $DOCKER_TTY $CONTAINER_NAME cat /proc/sys/kernel/pid_max)"
		else
			# On kernel versions >= 6.14, the pid_max value is pid namespaced, so we need to set it in the container namespace instead of host.
			# But some distributions may backport the pid namespacing to older kernels, so we check whether it's effective by checking the value in the container after setting it.
			$SUDO docker run --privileged --pid="container:$CONTAINER_NAME" --rm "$TERMUX_BUILDER_IMAGE_NAME" sh -c "echo 65535 | sudo tee /proc/sys/kernel/pid_max > /dev/null" || :
			if [[ "$($SUDO docker exec $CONTAINER_NAME cat /proc/sys/kernel/pid_max)" -eq 65535 ]]; then
				echo "Successfully changed /proc/sys/kernel/pid_max for container namespace"
			else
				echo "Failed to change /proc/sys/kernel/pid_max for container, falling back to setting it on host..."
				if ( echo 65535 | sudo tee /proc/sys/kernel/pid_max >/dev/null ); then
					echo "Successfully changed /proc/sys/kernel/pid_max on host, but it may affect other processes on the host system"
				else
					echo "Failed to change /proc/sys/kernel/pid_max on host as well, some packages that need to run native executables using proot (for 32-bit architectures) may not work properly"
				fi
			fi
		fi
	fi
}

NAMESPACE_HOLDER_PID_FILE=/tmp/termux-build-namespace.pid

__get_namespace_holder_pid() {
	local pid
	pid="$($SUDO docker exec $CONTAINER_NAME cat $NAMESPACE_HOLDER_PID_FILE 2>/dev/null || :)"
	if [[ "$pid" =~ ^[0-9]+$ ]] && $SUDO docker exec $CONTAINER_NAME test -r /proc/$pid/ns/user; then
		echo "$pid"
		return 0
	fi
	return 1
}

__ensure_namespace_holder() {
	if [ "$UNAME" = Darwin ]; then
		return
	fi
	if __get_namespace_holder_pid >/dev/null; then
		return
	fi

	echo "Creating persistent user/mount namespace for package builds..."
	$SUDO docker exec --detach --privileged --user 0 $CONTAINER_NAME \
		capsh --keep=1 --user=builder --caps=cap_sys_admin+eip --addamb=cap_sys_admin -- -c \
		"exec unshare -U --map-current-user --keep-caps -m --propagation unchanged sh -c 'echo \$\$ > $NAMESPACE_HOLDER_PID_FILE; exec sleep infinity'"

	local i
	for i in {1..50}; do
		if __get_namespace_holder_pid >/dev/null; then
			return
		fi
		sleep 0.1
	done
	echo "Failed to create persistent build namespace" >&2
	exit 1
}


if ! $SUDO docker container inspect $CONTAINER_NAME > /dev/null 2>&1; then
	echo "Creating new container..."
	$SUDO docker run \
		--detach \
		--init \
		--name $CONTAINER_NAME \
		"${REPO_MOUNT[@]}" \
		"${OUTPUT_MOUNT[@]}" \
		$SEC_OPT \
		--tty \
		$TERMUX_DOCKER_RUN_EXTRA_ARGS \
		$TERMUX_BUILDER_IMAGE_NAME
	__change_builder_uid_gid
	__change_container_pid_max
	__ensure_namespace_holder
fi

if [[ "$($SUDO docker container inspect -f '{{ .State.Running }}' $CONTAINER_NAME)" == "false" ]]; then
	$SUDO docker start $CONTAINER_NAME >/dev/null 2>&1
	__change_container_pid_max
	__ensure_namespace_holder
fi

__ensure_namespace_holder

# Set traps to ensure that the process started with docker exec and all its children are killed.
. "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__setup_docker_exec_traps

if [ "$#" -eq "0" ]; then
	set -- bash
fi

if [ "$UNAME" = Darwin ]; then
	$SUDO docker exec $CI_OPT --env "DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH" --interactive $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME "$@"
else
	NAMESPACE_HOLDER_PID="$(__get_namespace_holder_pid)"
	$SUDO docker exec $CI_OPT --env "DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH" --interactive $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME \
		nsenter --target "$NAMESPACE_HOLDER_PID" --user -m --preserve-credentials --keep-caps --wdns="$CONTAINER_HOME_DIR/termux-packages" "$@"
fi
