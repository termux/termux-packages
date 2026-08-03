#!/usr/bin/bash

# Use Github releases as source file mirrors.
# Github limits the amount of files in a single release to 1000, so we need several mirrors.
# The repository should have releases and git tags with following names:
# source-mirror-lib
# source-mirror-0-9-a-d
# source-mirror-e-j
# source-mirror-k-m
# source-mirror-n-p
# source-mirror-q-s
# source-mirror-t-z
# Packages are sorted into the mirror by the first letter of the package name,
# with 'lib' a separate category.
# Source files are named as <package_name>-<last_element_of_download_url>,
# so it's easy to sort by name and remove outdated source files,
# and the download URL generally contains package version
# and the archive file extension (.tar.gz or .tar.xz or .zip).
# When downloading from the mirror, the file checksum is verified as with regular download.
# Git repositories (with URL git+https://) are archived into .tar.xz file,
# Git commit hash is not checked - some packages implement such checks
# inside termux_step_post_get_source() in ad-hoc and unreliable way.
# Termux packages count divided by the name as of 2026-07-22:
# lib: 550
# 0-9,a-d: 448
# e-j: 473
# k-m: 496
# n-p: 353
# q-s: 334
# t-z: 463

termux_get_source_mirror_name() {
	if [[ $# != 1 ]]; then
		echo "termux_get_source_mirror_name(): Invalid arguments - expected <PACKAGE>" 1>&2
		return 1
	fi
	if [[ "$1" =~ ^lib.* ]]; then
		echo "source-mirror-lib"
	elif [[ "$1" =~ ^[0-9a-d].* ]]; then
		echo "source-mirror-0-9-a-d"
	elif [[ "$1" =~ ^[e-j].* ]]; then
		echo "source-mirror-e-j"
	elif [[ "$1" =~ ^[k-m].* ]]; then
		echo "source-mirror-k-m"
	elif [[ "$1" =~ ^[n-p].* ]]; then
		echo "source-mirror-n-p"
	elif [[ "$1" =~ ^[q-s].* ]]; then
		echo "source-mirror-q-s"
	elif [[ "$1" =~ ^[t-z].* ]]; then
		echo "source-mirror-t-z"
	else
		echo "termux_get_source_mirror_name(): Invalid package name $1" 1>&2
		return 1
	fi
}

termux_download_source_mirror() {
	local SOURCE_MIRROR_BASE_URL="https://github.com/termux/termux-packages/releases/download"

	if [[ $# != 3 ]] && [[ $# != 4 ]]; then
		echo "termux_download_source_mirror(): Invalid arguments - expected <PACKAGE> <URL> <DESTINATION> [<CHECKSUM>]" 1>&2
		return 1
	fi
	local PKG="$1"
	local PKG_URL="$2"
	local DESTINATION="$3"
	local CHECKSUM="${4:-SKIP_CHECKSUM}"
	local SOURCE_MIRROR_NAME="$(termux_get_source_mirror_name ${PKG})"
	local SOURCE_MIRROR_URL="${SOURCE_MIRROR_BASE_URL}/${SOURCE_MIRROR_NAME}/${PKG}_$(basename ${PKG_URL})"

	# Same as termux_download but without retries, and with partial download enabled
	if [ -f "$DESTINATION" ] && [ "$CHECKSUM" != "SKIP_CHECKSUM" ]; then
		# Keep existing file if checksum matches.
		local EXISTING_CHECKSUM
		EXISTING_CHECKSUM=$(sha256sum "$DESTINATION" | cut -d' ' -f1)
		[[ "$EXISTING_CHECKSUM" == "$CHECKSUM" ]] && return
	fi

	local TMPFILE
	local -a CURL_OPTIONS=(
		--fail               # Consider 4xx and 5xx responses as failures
		--retry 5            # Retry up to 5 times on transient failures
		--retry-connrefused  # Also retry on refused connections
		--retry-delay 5      # Wait 5 seconds between retries
		--connect-timeout 30 # Wait at most 30 seconds for a connection to be established
		--retry-max-time 120 # Stop retrying if it's still failing after 120 seconds
		--speed-limit 1000   # Expect at least 1000 Bytes per second
		--speed-time 60      # Fail if the minimum speed isn't met for at least 60 seconds
		--location           # Follow redirects
		--continue-at -      # Resume interrupted download from the middle
	)
	TMPFILE=$(mktemp "$TERMUX_PKG_TMPDIR/download.${TERMUX_PKG_NAME-unnamed}.XXXXXXXXX")
	if [[ "${TERMUX_QUIET_BUILD-}" == "true" ]]; then
		CURL_OPTIONS+=(--no-progress-meter) # Don't print out transfer statistics
	fi

	echo "Downloading ${SOURCE_MIRROR_URL}"
	if ! curl "${CURL_OPTIONS[@]}" --output "${TMPFILE}" "${SOURCE_MIRROR_URL}"; then
		echo "Failed to download ${SOURCE_MIRROR_URL}" 1>&2
		return 1
	fi

	local ACTUAL_CHECKSUM
	ACTUAL_CHECKSUM=$(sha256sum "$TMPFILE" | cut -d' ' -f1)
	if [[ -z "$CHECKSUM" ]]; then
		printf "WARNING: No checksum check for %s:\nActual: %s\n" \
			"$SOURCE_MIRROR_URL" "$ACTUAL_CHECKSUM"
	elif [[ "$CHECKSUM" == "SKIP_CHECKSUM" ]]; then
		:
	elif [[ "$CHECKSUM" != "$ACTUAL_CHECKSUM" ]]; then
		printf "Wrong checksum for %s\nExpected: %s\nActual:   %s\n" \
			"$SOURCE_MIRROR_URL" "$CHECKSUM" "$ACTUAL_CHECKSUM" 1>&2
		return 1
	fi
	mv "$TMPFILE" "$DESTINATION"
	return 0
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	if [ "$1" = "--mirror-name" ]; then
		termux_get_source_mirror_name "$2"
	else
		termux_download_source_mirror "$@"
	fi
fi
