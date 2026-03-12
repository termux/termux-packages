#!/usr/bin/bash
set -euo pipefail

TERMUX_DOCKER_CONTAINER_PREFIX="termux-docker-container-"

if [ -n "${TERMUX_DOCKER_USE_SUDO-}" ]; then
	SUDO="sudo"
else
	SUDO=""
fi

if (( $# < 1 )); then
	echo "No container name specified"
	echo "Available containers:"
	for container in $($SUDO docker ps --format '{{.Names}}' | grep "^${TERMUX_DOCKER_CONTAINER_PREFIX}"); do
		echo "  ${container#"${TERMUX_DOCKER_CONTAINER_PREFIX}"}"
	done
	exit 1
fi

CONTAINER_NAME="${TERMUX_DOCKER_CONTAINER_PREFIX}$1"
shift

if ! $SUDO docker inspect "$CONTAINER_NAME" > /dev/null 2>&1; then
	echo "Container '$CONTAINER_NAME' does not exist"
	exit 1
fi

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

if [[ "$($SUDO docker container inspect -f '{{ .State.Running }}' $CONTAINER_NAME)" == "false" ]]; then
	$SUDO docker start "$CONTAINER_NAME" > /dev/null 2>&1
	__change_container_pid_max
fi

$SUDO docker exec -it $CONTAINER_NAME /entrypoint.sh "$@"
