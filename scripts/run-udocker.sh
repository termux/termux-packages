#!/bin/sh
set -e -u

# Set TERMUX_PREFIX, falling back to the default Termux directory if not already defined.
TERMUX_PREFIX="${TERMUX_PREFIX:-/data/data/com.termux/files/usr}"

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

# --- ARCHITECTURE DETECTION ---
# Detect host architecture to set the appropriate default image
HOST_ARCH=$(uname -m)
case "$HOST_ARCH" in
	x86_64|i?86)
		DEFAULT_IMAGE_NAME="ghcr.io/termux/package-builder"
		DEFAULT_CONTAINER_NAME="termux-package-builder"
		;;
	aarch64|arm64|armv*l)
		DEFAULT_IMAGE_NAME="ghcr.io/nonamewasdefined/termux-package-builder"
		DEFAULT_CONTAINER_NAME="termux-package-builder-arm"
		;;
	*)
		echo "Error: Unsupported architecture: $HOST_ARCH" 1>&2
		exit 1
		;;
esac

# Set default image and container names if they are not already set by environment variables.
: ${TERMUX_BUILDER_IMAGE_NAME:=$DEFAULT_IMAGE_NAME}
: ${CONTAINER_NAME:=$DEFAULT_CONTAINER_NAME}

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
	# On ARM/Android-based containers, /bin/bash does not exist inside the container.
	# Use 'bash' from PATH (which resolves to the Termux bash on Android) instead.
	case "$HOST_ARCH" in
		aarch64|arm64|armv*l)
			set -- bash -i
			;;
		*)
			# Use /bin/bash if available (standard on x86_64 Linux).
			# Otherwise, look for bash under Termux's prefix (for native ARM/Termux devices).
			if [ -x "/bin/bash" ]; then
				set -- /bin/bash -i
			elif [ -x "$TERMUX_PREFIX/bin/bash" ]; then
				set -- "$TERMUX_PREFIX/bin/bash" -i
			else
				# Fall back to relying on $PATH to find bash.
				set -- bash -i
			fi
			;;
	esac
fi

# === Fix interpreter for scripts ===
# The ARM container image (ghcr.io/nonamewasdefined/termux-package-builder)
# is Android-based and does not have /bin/bash or /bin/sh at standard paths.
# Bash is available at /data/data/com.termux/files/usr/bin/bash (via PATH).
# If the command is a script with a standard shebang that won't work inside
# the container, prepend 'bash' which is available via PATH.
if [ "$#" -gt 0 ] && [ -f "$1" ]; then
	if [ "$(head -c 2 "$1" 2>/dev/null)" = "#!" ]; then
		SHEBANG=$(head -1 "$1")
		case "$SHEBANG" in
			"#!/bin/bash"|"#!/bin/sh")
				# Prepend 'bash' which is available inside the container
				# either at /bin/bash (x86_64) or via PATH (ARM/Android).
				set -- bash "$@"
				;;
		esac
	fi
fi

echo "Running command in container '$CONTAINER_NAME' (workdir: $WORKDIR_IN_CONTAINER)..."

# Set CI environment variable option if applicable.
CI_OPT=""
if [ "${CI:-}" = "true" ]; then
	CI_OPT="--env=CI=true"
fi

# === DNS configuration ===
# The ARM64 container image (ghcr.io/nonamewasdefined/termux-package-builder)
# is Android-based and uses bionic libc. Bionic does NOT read /etc/resolv.conf
# for DNS resolution - it uses Android system properties (net.dns*) and
# /system/etc/hosts instead. Since there's no Android system server running
# in the container, DNS resolution fails in non-root mode.
#
# Our workaround:
#   1. Create a custom /etc/resolv.conf (for tools/glibc that might use it).
#   2. Create a custom /system/etc/hosts with commonly needed host entries,
#      resolved dynamically from the host (where DNS works).
#   3. Use --novol to prevent udocker from bind-mounting host's /etc/resolv.conf,
#      /etc/hosts, and /etc/host.conf (which contain the broken stub resolver).
#   4. Set TERMUX_ON_DEVICE_BUILD=false so the build scripts use the GitHub
#      download fallback instead of apt for tools like termux-elf-cleaner.
#
# Users can add extra host entries via the TERMUX_EXTRA_HOSTS environment
# variable (space-separated list of hostnames).

# --- Create /etc/resolv.conf ---
DNS_RESOLV_CONF=""
if [ -f "/run/systemd/resolve/resolv.conf" ]; then
	DNS_NAMESERVERS=$(grep -E "^nameserver\s+" /run/systemd/resolve/resolv.conf | grep -v "127\." | head -3 || true)
	if [ -n "$DNS_NAMESERVERS" ]; then
		DNS_RESOLV_CONF=$(mktemp)
		echo "# Generated by run-udocker.sh from /run/systemd/resolve/resolv.conf" > "$DNS_RESOLV_CONF"
		echo "$DNS_NAMESERVERS" >> "$DNS_RESOLV_CONF"
	fi
fi

if [ -z "$DNS_RESOLV_CONF" ] && [ -f "/etc/resolv.conf" ]; then
	DNS_NAMESERVERS=$(grep -E "^nameserver\s+" /etc/resolv.conf | grep -v "127\." | head -3 || true)
	if [ -n "$DNS_NAMESERVERS" ]; then
		DNS_RESOLV_CONF=$(mktemp)
		echo "# Generated by run-udocker.sh from /etc/resolv.conf (loopback-filtered)" > "$DNS_RESOLV_CONF"
		echo "$DNS_NAMESERVERS" >> "$DNS_RESOLV_CONF"
	fi
fi

if [ -z "$DNS_RESOLV_CONF" ]; then
	DNS_RESOLV_CONF=$(mktemp)
	echo "# Generated by run-udocker.sh (fallback)" > "$DNS_RESOLV_CONF"
	echo "nameserver 8.8.8.8" >> "$DNS_RESOLV_CONF"
	echo "nameserver 8.8.4.4" >> "$DNS_RESOLV_CONF"
fi

# --- Create /system/etc/hosts ---
# Android's bionic libc reads /system/etc/hosts for hostname resolution.
# We pre-populate it with commonly needed Termux build hosts, resolved
# dynamically from the host (where DNS works).
DNS_HOSTS_FILE=$(mktemp)
cat > "$DNS_HOSTS_FILE" << 'EOF'
127.0.0.1 localhost
::1 ip6-localhost
EOF

# Helper function: resolve a hostname to IPv4 and add to hosts file
_resolve_host() {
	local host="$1"
	local ips
	ips=$(getent ahosts "$host" 2>/dev/null | grep -E "^[0-9.]+\s" | head -1 | awk '{print $1}')
	if [ -n "$ips" ]; then
		for ip in $ips; do
			echo "$ip $host" >> "$DNS_HOSTS_FILE"
		done
	fi
}

# Resolve commonly needed hosts for Termux package building
for host in \
	packages.termux.dev \
	github.com \
	raw.githubusercontent.com \
	objects.githubusercontent.com \
	codeload.github.com \
; do
	_resolve_host "$host"
done

# Also resolve any extra hosts specified by the user
if [ -n "${TERMUX_EXTRA_HOSTS:-}" ]; then
	for host in $TERMUX_EXTRA_HOSTS; do
		_resolve_host "$host"
	done
fi

# Clean up temp files on script exit
trap "rm -f \"$DNS_RESOLV_CONF\" \"$DNS_HOSTS_FILE\"" EXIT

# --- Build novol options ---
# Prevent udocker from bind-mounting host's system files that would override
# our custom configurations.
NOVOL_OPT="--novol=/etc/resolv.conf --novol=/etc/hosts"
if [ -f "/etc/host.conf" ]; then
	NOVOL_OPT="$NOVOL_OPT --novol=/etc/host.conf"
fi

# Set LD_PRELOAD for Android-based containers (ARM) to support termux-exec.
# The ARM container image is Android-based and on-device builds require
# termux-exec to be loaded via LD_PRELOAD.
LD_PRELOAD_OPT=""
case "$HOST_ARCH" in
	aarch64|arm64|armv*l)
		TERMUX_EXEC_LIB="${TERMUX_PREFIX}/lib/libtermux-exec.so"
		LD_PRELOAD_OPT="--env=LD_PRELOAD=$TERMUX_EXEC_LIB"
		;;
esac

# Execute the command.
# This version uses a dynamically calculated working directory to mirror the
# host's current directory, making the script much more flexible.
udocker run \
    --user="builder" \
    --workdir="$WORKDIR_IN_CONTAINER" \
    $CI_OPT \
    $LD_PRELOAD_OPT \
    $NOVOL_OPT \
    --volume="$VOLUME" \
    --volume="$DNS_RESOLV_CONF:/etc/resolv.conf" \
    --volume="$DNS_HOSTS_FILE:/system/etc/hosts" \
    "$CONTAINER_NAME" \
    "$@"
