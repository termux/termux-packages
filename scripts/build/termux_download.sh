#!/usr/bin/bash

termux_download() {
	if [[ $# != 2 ]] && [[ $# != 3 ]]; then
		echo "termux_download(): Invalid arguments - expected <URL> <DESTINATION> [<CHECKSUM>]" 1>&2
		return 1
	fi
	local URL="$1"
	local DESTINATION="$2"
	local CHECKSUM="${3:-SKIP_CHECKSUM}"

	if [[ "$URL" =~ ^file://(/[^/]+)+$ ]]; then
		local source="${URL:7}" # Remove `file://` prefix

		if [ -d "$source" ]; then
			# Create tar file from local directory
			echo "Downloading local source directory at '$source'"
			rm -f "$DESTINATION"
			(cd "$(dirname "$source")" && tar -cf "$DESTINATION" --exclude=".git" "$(basename "$source")")
			return 0
		elif [ ! -f "$source" ]; then
			echo "No local source file found at path of URL '$URL'"
			return 1
		else
			ln -sf "$source" "$DESTINATION"
			return 0
		fi
	fi

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
	)
	TMPFILE=$(mktemp "$TERMUX_PKG_TMPDIR/download.${TERMUX_PKG_NAME-unnamed}.XXXXXXXXX")
	if [[ "${TERMUX_QUIET_BUILD-}" == "true" ]]; then
		CURL_OPTIONS+=(--no-progress-meter) # Don't print out transfer statistics
	fi

	echo "Downloading ${URL}"
	if ! curl "${CURL_OPTIONS[@]}" --output "$TMPFILE" "$URL"; then
		local error=1
		local retry=2
		local delay=60
		local try
		for (( try=1; try <= retry; try++ )); do
			echo "Retrying #${try} download ${URL} in ${delay}"
			sleep "${delay}"
			if curl "${CURL_OPTIONS[@]}" --output "$TMPFILE" "$URL"; then
				error=0
				break
			fi
		done
		if [[ "${error}" != 0 ]]; then
			echo "Failed to download $URL" 1>&2
			return 1
		fi
	fi

	local ACTUAL_CHECKSUM
	ACTUAL_CHECKSUM=$(sha256sum "$TMPFILE" | cut -d' ' -f1)
	if [[ -z "$CHECKSUM" ]]; then
		printf "WARNING: No checksum check for %s:\nActual: %s\n" \
			"$URL" "$ACTUAL_CHECKSUM"
	elif [[ "$CHECKSUM" == "SKIP_CHECKSUM" ]]; then
		:
	elif [[ "$CHECKSUM" != "$ACTUAL_CHECKSUM" ]]; then
		printf "Wrong checksum for %s\nExpected: %s\nActual:   %s\n" \
			"$URL" "$CHECKSUM" "$ACTUAL_CHECKSUM" 1>&2
		return 1
	fi
	mv "$TMPFILE" "$DESTINATION"
	return 0
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
