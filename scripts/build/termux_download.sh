termux_download() {
	if [ $# != 3 ]; then
		termux_error_exit "termux_download(): Invalid arguments - expected \$URL \$DESTINATION \$CHECKSUM"
	fi
	local URL="$1"
	local DESTINATION="$2"
	local CHECKSUM="$3"

	if [ -f "$DESTINATION" ] && [ "$CHECKSUM" != "SKIP_CHECKSUM" ]; then
		# Keep existing file if checksum matches.
		local EXISTING_CHECKSUM
		EXISTING_CHECKSUM=$(sha256sum "$DESTINATION" | cut -f 1 -d ' ')
		if [ "$EXISTING_CHECKSUM" = "$CHECKSUM" ]; then return; fi
	fi

	local TMPFILE
	TMPFILE=$(mktemp "$TERMUX_PKG_TMPDIR/download.$TERMUX_PKG_NAME.XXXXXXXXX")
	echo "Downloading ${URL}"
	if curl --fail --retry 10 --retry-connrefused --retry-delay 30 --location --output "$TMPFILE" "$URL"; then
		local ACTUAL_CHECKSUM
		ACTUAL_CHECKSUM=$(sha256sum "$TMPFILE" | cut -f 1 -d ' ')
		if [ "$CHECKSUM" != "SKIP_CHECKSUM" ]; then
			if [ "$CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then
				>&2 printf "Wrong checksum for %s:\nExpected: %s\nActual:   %s\n" \
					   "$URL" "$CHECKSUM" "$ACTUAL_CHECKSUM"
				exit 1
			fi
		else
			printf "WARNING: No checksum check for %s:\nActual: %s\n" \
			       "$URL" "$ACTUAL_CHECKSUM"
		fi
		mv "$TMPFILE" "$DESTINATION"
		return
	fi

	termux_error_exit "Failed to download $URL"
}

# Make script standalone executable as well as sourceable
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
	termux_download "$@"
fi
