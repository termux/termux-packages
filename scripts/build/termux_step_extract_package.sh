termux_step_extract_package() {
	if [ -z "${TERMUX_PKG_SRCURL:=""}" ] || [ "${TERMUX_PKG_SKIP_SRC_EXTRACT-false}" = "true" ]; then
		mkdir -p "$TERMUX_PKG_SRCDIR"
		return
	fi
	cd "$TERMUX_PKG_TMPDIR"
	local PKG_SRCURL=(${TERMUX_PKG_SRCURL[@]})
	local PKG_SHA256=(${TERMUX_PKG_SHA256[@]})
	if  [ ! ${#PKG_SRCURL[@]} == ${#PKG_SHA256[@]} ] && [ ! ${#PKG_SHA256[@]} == 0 ]; then
		termux_error_exit "Error: length of TERMUX_PKG_SRCURL isn't equal to length of TERMUX_PKG_SHA256."
	fi
	# STRIP=1 extracts archives straight into TERMUX_PKG_SRCDIR while STRIP=0 puts them in subfolders. zip has same behaviour per default
	# If this isn't desired then this can be fixed in termux_step_post_extract_package.
	local STRIP=1
	for i in $(seq 0 $(( ${#PKG_SRCURL[@]}-1 ))); do
		test "$i" -gt 0 && STRIP=0
		local filename
		filename=$(basename "${PKG_SRCURL[$i]}")
		local file="$TERMUX_PKG_CACHEDIR/$filename"
		# Allow TERMUX_PKG_SHA256 to be empty:
		set +u
		termux_download "${PKG_SRCURL[$i]}" "$file" "${PKG_SHA256[$i]}"
		set -u

		local folder
		set +o pipefail
		if [ "${file##*.}" = zip ]; then
			folder=$(unzip -qql "$file" | head -n1 | tr -s ' ' | cut -d' ' -f5-)
			rm -Rf $folder
			unzip -q "$file"
			mv $folder "$TERMUX_PKG_SRCDIR"
		else
			mkdir -p "$TERMUX_PKG_SRCDIR"
			tar xf "$file" -C "$TERMUX_PKG_SRCDIR" --strip-components=$STRIP
		fi
		set -o pipefail
	done
}
