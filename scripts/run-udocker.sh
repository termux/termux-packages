#!/bin/sh
set -e -u

# Find the root directory of the script's repository.
# This is more robust than using ${PWD} as it works regardless of where the script is called from.
TERMUX_SCRIPTDIR=$(cd "$(realpath "$(dirname "$0")")"; cd ..; pwd)

BUILDSCRIPT_NAME="build-package.sh"

# Pre-check logic to see if any packages would be built.
if [ "${1:-}" = "-p" ] || [ "${1:-}" = "--pre-check-if-will-build-packages" ]; then
	shift 1
	TERMUX_DOCKER__CONTAINER_EXEC_COMMAND__PRE_CHECK_IF_WILL_BUILD_PACKAGES="true"
fi

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

# === udocker configuration ===

# Define a constant for the home directory inside the container.
CONTAINER_HOME_DIR=/home/builder

# Define the path to the mounted packages directory inside the container.
CONTAINER_PACKAGES_DIR="$CONTAINER_HOME_DIR/termux-packages"

# Define the volume mount using the robustly calculated repository root.
VOLUME="$TERMUX_SCRIPTDIR:$CONTAINER_PACKAGES_DIR"

# Set default image and container names if they are not already set.
: ${TERMUX_BUILDER_IMAGE_NAME:=ghcr.io/termux/package-builder}
: ${CONTAINER_NAME:=termux-package-builder}

# --- DYNAMIC WORKDIR LOGIC ---
# Calculate the relative path from the repository root to the current directory.
RELATIVE_PATH_FROM_ROOT="${PWD#$TERMUX_SCRIPTDIR}"
# Construct the target working directory inside the container.
WORKDIR_IN_CONTAINER="$CONTAINER_PACKAGES_DIR$RELATIVE_PATH_FROM_ROOT"


# --- udocker is designed to be rootless, so 'sudo' is not required. ---

echo "Preparing container '$CONTAINER_NAME' from image '$TERMUX_BUILDER_IMAGE_NAME' with udocker..."

# 1. Pull the image if it doesn't exist locally.
if ! udocker images | grep -q "$TERMUX_BUILDER_IMAGE_NAME"; then
    echo "Image '$TERMUX_BUILDER_IMAGE_NAME' not found. Pulling..."
    udocker pull "$TERMUX_BUILDER_IMAGE_NAME"
fi

# 2. Create the container from the image if it doesn't already exist.
if ! udocker ps | grep -q "\\b${CONTAINER_NAME}\\b"; then
    echo "Creating new container '$CONTAINER_NAME'..."
    udocker create --name="$CONTAINER_NAME" "$TERMUX_BUILDER_IMAGE_NAME"
fi

# === Execution ===

# If no arguments are provided, default to starting an interactive bash shell.
if [ "$#" -eq "0" ]; then
	set -- /bin/bash -i
fi

echo "Running command in container '$CONTAINER_NAME' (workdir: $WORKDIR_IN_CONTAINER)..."

# Set CI environment variable option if applicable.
CI_OPT=""
if [ "${CI:-}" = "true" ]; then
	CI_OPT="--env=CI=true"
fi

# Execute the command.
# This version uses a dynamically calculated working directory to mirror the
# host's current directory, making the script much more flexible.
udocker run \
    --user="builder" \
    --workdir="$WORKDIR_IN_CONTAINER" \
    $CI_OPT \
    --volume="$VOLUME" \
    "$CONTAINER_NAME" \
    "$@"