# shellcheck shell=bash

# Title:          docker
# Description:    A library for docker.
# License-SPDX:   MIT

##
# Run trap for `docker exec`.
# .
# This will read the pid stored in DOCKER_EXEC_PID_FILE_PATH by the process
# called by `docker exec`, like via a call to `docker__create_docker_exec_pid_file`
# and then will send kill signals to the process for the pid and all
# its children. This is need like for cases when `--tty` is not passed
# or cannot be passed to `docker exec` like if stdin is not available
# or if output of command is redirected to file instead of terminal,
# like `docker exec cmd &> cmd.log </dev/null`.
# .
# See Also:
# - https://github.com/docker/cli/issues/2607
# - https://github.com/moby/moby/issues/9098
# - https://github.com/moby/moby/pull/41548
# .
# .
# docker__run_docker_exec_trap
##
docker__run_docker_exec_trap() {

    local exit_code=$? # Store the original trap signal
    local signal="${1:-}";
    trap - EXIT  # Remove the EXIT trap so its not called again

    [ -n "${1:-}" ] && trap - "${1:-}"; # If a signal argument was passed, then remove its trap

    if [ -n "${CONTAINER_NAME-}" ] && [ -n "${DOCKER_EXEC_PID_FILE_PATH-}" ]; then

        local docker_exec_trap_command='
# If called process did not store its pid in file path, then just exit
[ ! -f '"$DOCKER_EXEC_PID_FILE_PATH"' ] && exit 0;

docker_killtree() {
    local signal="${1:-}"; local pid="${2:-}"; local cpid; local docker_process
    for cpid in $(pgrep -P "$pid"); do docker_killtree "$signal" "$cpid"; done
    [[ "$pid" != "$$" ]] && \
    docker_process="$(ps -efww --pid "$pid" --no-headers -o pid:1,cmd || :)" && \
    test -n "$docker_process" && \
    #echo "Killing $docker_process" && \
    kill "-${signal:-15}" "$pid" 2>/dev/null || :
}

# Read the pid stored in file path and send kill signals to the process and all its children
DOCKER_PID="$(cat '"$DOCKER_EXEC_PID_FILE_PATH"')" && [[ "$DOCKER_PID" =~ ^[0-9]+$ ]] && \
DOCKER_PROCESS="$(ps -efww --pid "$DOCKER_PID" --no-headers -o pid:1,cmd || :)" && \
test -n "$DOCKER_PROCESS" && \
echo "Docker trap killing DOCKER_PROCESS" && \
docker_killtree "'"$signal"'" "$DOCKER_PID" || :
        '
        # Exec docker_exec_trap_command inside docker context
        $SUDO docker exec "$CONTAINER_NAME" bash -c "$docker_exec_trap_command"

    fi

    exit $exit_code # Exit with the original trap signal exit code

}

##
# Setup traps for `docker exec`.
#
# .This call sets `DOCKER_EXEC_PID_FILE_PATH`, which should be passed to
# processes started with `docker exec`, like with
# `--env "DOCKER_EXEC_PID_FILE_PATH=$DOCKER_EXEC_PID_FILE_PATH"` option,
# so that its available in `docker__create_docker_exec_pid_file` inside the
# called process and in `docker__run_docker_exec_trap` inside the process
# that calls `docker exec`.
# .
# .
# docker__setup_docker_exec_traps
##
docker__setup_docker_exec_traps() {

    DOCKER_EXEC_PID_FILE_PATH="/tmp/docker-exec-pid-$(date +"%Y-%m-%d-%H.%M.%S.")$((RANDOM%1000))"

    trap 'docker__run_docker_exec_trap' EXIT
    trap 'docker__run_docker_exec_trap TERM' TERM
    trap 'docker__run_docker_exec_trap INT' INT
    trap 'docker__run_docker_exec_trap HUP' HUP
    trap 'docker__run_docker_exec_trap QUIT' QUIT

}

##
# Store the pid of current process at DOCKER_EXEC_PID_FILE_PATH so that
# if `docker exec` is killed, like with `ctrl+c`, then all child
# process of current processes are killed by docker__run_docker_exec_trap.
# .
# .
# **Parameters:**
# `pid` - The optional pid to store in file instead of current process pid ($$).
# .
# .
# docker__create_docker_exec_pid_file [`<pid>`]
##
docker__create_docker_exec_pid_file() {

    local pid=${1:-}; pid=${pid:-$$}

    if [ -n "${DOCKER_EXEC_PID_FILE_PATH-}" ] && [ ! -e "${DOCKER_EXEC_PID_FILE_PATH-}" ]; then
        if ! echo "$pid" > "$DOCKER_EXEC_PID_FILE_PATH"; then
            echo "Failed to create docker exec pid file at \"$DOCKER_EXEC_PID_FILE_PATH\""
        fi
    fi

}
