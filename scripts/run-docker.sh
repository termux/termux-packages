#!/bin/bash
set -euo pipefail

TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)
: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}
: ${TERMUX_DOCKER_RUN_EXTRA_ARGS:=}
: ${TERMUX_DOCKER_EXEC_EXTRA_ARGS:=}
BUILDSCRIPT_NAME=build-package.sh
CONTAINER_HOME_DIR=/home/builder

# Detect container runtime.
# Explicit choice via TERMUX_CONTAINER_RUNTIME takes priority.
# Otherwise, auto-detect: prefer docker if available, fall back to podman.
_detect_runtime() {
	if [ -n "${TERMUX_CONTAINER_RUNTIME:-}" ]; then
		case "$TERMUX_CONTAINER_RUNTIME" in
			docker|podman) echo "$TERMUX_CONTAINER_RUNTIME"; return;;
			*) echo "Error: TERMUX_CONTAINER_RUNTIME must be 'docker' or 'podman'" >&2; exit 1;;
		esac
	fi
	if command -v docker &>/dev/null; then
		echo "docker"
	elif command -v podman &>/dev/null; then
		echo "podman"
	else
		echo "Error: Neither docker nor podman found in PATH" >&2
		exit 1
	fi
}

# Detect superuser command.
# If running as root, no sudo is needed. Otherwise, check for sudo.
_detect_sudo() {
	if [ "$(id -u)" = "0" ]; then
		echo ""
	elif command -v sudo &>/dev/null; then
		echo "sudo"
	elif command -v doas &>/dev/null; then
		echo "doas"
	elif command -v run0 &>/dev/null; then
		echo "run0"
	else
		echo "Error: This script must be run as root or with sudo/doas available in PATH" >&2
		exit 1
	fi
}

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
	echo ""
	echo "Supported environment variables:"
	echo "  TERMUX_BUILDER_IMAGE_NAME     The name of the Docker image to use"
	echo "  CONTAINER_NAME                The name of the Docker container to create/use"
	echo "  TERMUX_CONTAINER_RUNTIME      Set to 'docker' or 'podman' to override auto-detection"
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
	echo "- When using Podman (via TERMUX_CONTAINER_RUNTIME=podman),"
	echo "  the container runs rootless. No sudo is required, and host file"
	echo "  permissions are never altered. Container runs as root in the user namespace"
	echo "  (which maps to your unprivileged host user)."
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
		-*) echo "Error: Unknown option '$1'" >&2; shift 1; exit 1;;
		*) break;;
	esac
done

RUNTIME=$(_detect_runtime) || exit 1

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
				echo "$OUTPUT" >&2
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
if [ "$RUNTIME" = "podman" ]; then
	REPOROOT="$(dirname $(readlink -f $0))/../"
	# No custom seccomp profile: Docker's profile.json blocks chmod/fchmodat
	# in rootless Podman's user-namespace context.  Podman's default seccomp
	# profile already allows the needed syscalls (personality, mount, umount2)
	# when CAP_SYS_ADMIN is granted.
	# CAP_SYS_ADMIN (within user namespace) and /dev/fuse are needed for
	# fuse-overlayfs mounts used by the build system.
	SEC_OPT=" --cap-add CAP_SYS_ADMIN --device /dev/fuse"
elif [ "$RUNTIME" = "docker" ]; then
	if [ "$UNAME" = Darwin ]; then
		# Workaround for mac readlink not supporting -f.
		REPOROOT=$PWD
		SEC_OPT=""
	else
		REPOROOT="$(dirname $(readlink -f $0))/../"
		SEC_OPT=" --security-opt seccomp=$REPOROOT/scripts/profile.json --security-opt apparmor=_custom-termux-package-builder-$CONTAINER_NAME --cap-add CAP_SYS_ADMIN --device /dev/fuse"
	fi
else
	echo "Error: Unsupported runtime '$RUNTIME'" >&2
	exit 1
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
SUDO_CMD=$(_detect_sudo) || exit 1

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO=$SUDO_CMD
else
	SUDO=""
fi

echo "Running container '$CONTAINER_NAME' from image '$TERMUX_BUILDER_IMAGE_NAME' (runtime: $RUNTIME)..."

# Check whether attached to tty and adjust docker flags accordingly.
if [ -t 1 ]; then
	DOCKER_TTY=" --tty"
else
	DOCKER_TTY=""
fi

# AppArmor (Docker only)
if [ "$RUNTIME" = "docker" ]; then
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
			cat "$profile_path" | sed -e "s/{{CONTAINER_NAME}}/$CONTAINER_NAME/g" | $SUDO_CMD "$APPARMOR_PARSER" -rK
		fi
	}

	# Load the relaxed AppArmor profile first as we might need to change permissions
	load_apparmor_profile ./scripts/profile-relaxed.apparmor
fi

__change_builder_uid_gid() {
	if [ "$UNAME" != Darwin ]; then
		if [ $(id -u) -ne 1001 -a $(id -u) -ne 0 ]; then
			echo "Changed builder uid/gid... (this may take a while)"
			$SUDO $RUNTIME exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo chown -R $(id -u):$(id -g) $CONTAINER_HOME_DIR
			$SUDO $RUNTIME exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo chown -R $(id -u):$(id -g) /data
			$SUDO $RUNTIME exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo usermod -u $(id -u) builder
			$SUDO $RUNTIME exec $DOCKER_TTY $TERMUX_DOCKER_EXEC_EXTRA_ARGS $CONTAINER_NAME sudo groupmod -g $(id -g) builder
		fi
	fi
}

__change_container_pid_max() {
	if [ "$UNAME" != Darwin ]; then
		echo "Changing /proc/sys/kernel/pid_max to 65535 for packages that need to run native executables using proot (for 32-bit architectures)"
		if [[ "$($SUDO $RUNTIME exec $CONTAINER_NAME cat /proc/sys/kernel/pid_max)" -le 65535 ]]; then
			echo "No need to change /proc/sys/kernel/pid_max, current value is $($SUDO $RUNTIME exec $DOCKER_TTY $CONTAINER_NAME cat /proc/sys/kernel/pid_max)"
		else
			# On kernel versions >= 6.14, the pid_max value is pid namespaced, so we need to set it in the container namespace instead of host.
			# But some distributions may backport the pid namespacing to older kernels, so we check whether it's effective by checking the value in the container after setting it.
			$SUDO $RUNTIME run --privileged --pid="container:$CONTAINER_NAME" --rm "$TERMUX_BUILDER_IMAGE_NAME" sh -c "echo 65535 | sudo tee /proc/sys/kernel/pid_max > /dev/null" || :
			if [[ "$($SUDO $RUNTIME exec $CONTAINER_NAME cat /proc/sys/kernel/pid_max)" -eq 65535 ]]; then
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

if ! $SUDO $RUNTIME container inspect $CONTAINER_NAME &>/dev/null; then
	echo "Creating new container..."

	RUNTIME_RUN_ARGS=" \
		--detach \
		--init \
		--name $CONTAINER_NAME \
		--volume $VOLUME \
		$SEC_OPT \
		--tty \
		$TERMUX_DOCKER_RUN_EXTRA_ARGS"

	if [ "$RUNTIME" = "podman" ]; then
		# In rootless Podman the default user-namespace mapping is:
		#   container root (0)  →  host user ($UID)
		#   container 1-N       →  host subuid range
		#
		# We run as root *inside* the container so that:
		#   • chmod/chown (used by tar, dpkg, etc.) work within the userns
		#   • the image's builder-owned toolchain files are accessible (root can read all)
		#   • files written to the bind-mounted repo volume land as the host user on disk
		#
		# This is safe — "root" in a rootless container is the unprivileged host user;
		# the user namespace already provides the sandbox.  No host permissions are altered.
		$SUDO $RUNTIME run \
			$RUNTIME_RUN_ARGS \
			--pids-limit=-1 \
			--user root \
			--env HOME=$CONTAINER_HOME_DIR \
			$TERMUX_BUILDER_IMAGE_NAME
	elif [ "$RUNTIME" = "docker" ]; then
		$SUDO $RUNTIME run \
			$RUNTIME_RUN_ARGS \
			$TERMUX_BUILDER_IMAGE_NAME
		__change_builder_uid_gid
	else
		echo "Error: Unsupported runtime '$RUNTIME'" >&2
		exit 1
	fi
	__change_container_pid_max
fi

if [[ "$($SUDO $RUNTIME container inspect -f '{{ .State.Running }}' $CONTAINER_NAME)" == "false" ]]; then
	$SUDO $RUNTIME start $CONTAINER_NAME &>/dev/null
	__change_container_pid_max
fi

# Load restricted AppArmor profile (Docker only)
if [ "$RUNTIME" = "docker" ]; then
	load_apparmor_profile ./scripts/profile-restricted.apparmor "Loading restricted AppArmor profile"
fi

# Set traps to ensure that the process started with docker exec and all its children are killed.
. "$TERMUX_SCRIPTDIR/scripts/utils/docker/docker.sh"; docker__setup_docker_exec_traps

if [ "$#" -eq "0" ]; then
	set -- bash
fi

# Execute command in container
RUNTIME_EXEC_ARGS=" \
	$CI_OPT \
	--env \"DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH\" \
	--interactive $DOCKER_TTY \
	$TERMUX_DOCKER_EXEC_EXTRA_ARGS"

if [ "$RUNTIME" = "podman" ]; then
	$SUDO $RUNTIME exec \
		$RUNTIME_EXEC_ARGS \
		--user root \
		--env HOME=$CONTAINER_HOME_DIR \
		$CONTAINER_NAME \
		"$@"
elif [ "$RUNTIME" = "docker" ]; then
	$SUDO $RUNTIME exec \
		$RUNTIME_EXEC_ARGS \
		$CONTAINER_NAME \
		"$@"
else
	echo "Error: Unsupported runtime '$RUNTIME'" >&2
	exit 1
fi
