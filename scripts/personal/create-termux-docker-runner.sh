#!/usr/bin/bash
set -euo pipefail


if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

if (( $# != 2 )); then
	echo "Usage: $0 <architecture> <container_name_suffix>"
	echo "architecture can be one of: aarch64, arm, i686, x86_64"
	exit 1
fi


ARCH="$1"
TERMUX_DOCKER_CONTAINER_PREFIX="termux-docker-container-"
: ${TERMUX_DOCKER_IMAGE_NAME:="termux/termux-docker:$ARCH-base"}
CONTAINER_NAME="${TERMUX_DOCKER_CONTAINER_PREFIX}$2"

__change_container_pid_max() {
	echo "Changing /proc/sys/kernel/pid_max to 65535 for packages that need to run native executables using proot (for 32-bit architectures)"
	if [[ "$($SUDO docker exec $CONTAINER_NAME cat /proc/sys/kernel/pid_max)" -le 65535 ]]; then
		echo "No need to change /proc/sys/kernel/pid_max, current value is $($SUDO docker exec $DOCKER_TTY $CONTAINER_NAME cat /proc/sys/kernel/pid_max)"
	else
		# On kernel versions >= 6.14, the pid_max value is pid namespaced, so we need to set it in the container namespace instead of host.
		# But some distributions may backport the pid namespacing to older kernels, so we check whether it's effective by checking the value in the container after setting it.
		$SUDO docker run --privileged --pid="container:$CONTAINER_NAME" --rm "ubuntu:24.04" sh -c "echo 65535 | tee /proc/sys/kernel/pid_max > /dev/null" || :
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
}

$SUDO docker run \
	-dit \
	--volume $HOME/termux-apt-repo:/apt:ro \
	--volume $PWD:/data/data/com.termux/files/usr/termux-packages:rw \
	--name "$CONTAINER_NAME" \
	"$TERMUX_DOCKER_IMAGE_NAME"

__change_container_pid_max

$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c 'echo "deb file:///apt/termux-main stable main" > $PREFIX/etc/apt/sources.list'
$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c 'mkdir -p $PREFIX/etc/apt/sources.list.d'
$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c 'echo "deb file:///apt/termux-root root stable" > $PREFIX/etc/apt/sources.list.d/root.list'
$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c 'echo "deb file:///apt/termux-x11 x11 main" > $PREFIX/etc/apt/sources.list.d/x11.list'
$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c 'apt-get update && apt-get full-upgrade -o Dpkg::Options::=--force-confnew -y'

# Now install some packages which are handy
PACKAGES=()
# Needed for checking out code
PACKAGES+=("git")
# Runtimes needed for some build scripts
PACKAGES+=("python" "nodejs" "bash")
# The compilers
PACKAGES+=("clang" "llvm" "llvm-tools" "mlir" "rust" "golang" "zig")
# Debugging tools
PACKAGES+=("gdb" "lldb" "strace" "ltrace" "valgrind")
# Build systems
PACKAGES+=("cmake" "ninja" "autoconf" "automake" "make" "autoconf-archive" "build-essential")
# Some editors and stuff
PACKAGES+=("neovim" "vim")
# Change our shell to fish
PACKAGES+=("fish")
# Other utilities
PACKAGES+=("htop" "tree" "ripgrep" "ripgrep-all" "bat" "apt-file" "file")

$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c "apt-get install -y ${PACKAGES[*]}"
$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c "apt-file update"
# Change default shell to fish
$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh bash -c "echo 'exec fish\$@' >> ~/.bashrc"
