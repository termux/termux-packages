termux_download_src_archive() {
	local PKG_SRCURL=(${TERMUX_PKG_SRCURL[@]})
	local PKG_SHA256=(${TERMUX_PKG_SHA256[@]})
	if  [ ! ${#PKG_SRCURL[@]} == ${#PKG_SHA256[@]} ] && [ ! ${#PKG_SHA256[@]} == 0 ]; then
		termux_error_exit "length of TERMUX_PKG_SRCURL isn't equal to length of TERMUX_PKG_SHA256."
	fi

	for i in $(seq 0 $(( ${#PKG_SRCURL[@]}-1 ))); do
		local file="$TERMUX_PKG_CACHEDIR/$(basename "${PKG_SRCURL[$i]}")"
		if termux_download_source_mirror "${TERMUX_PKG_NAME}" \
				"${PKG_SRCURL[$i]}" "$file" "${PKG_SHA256[$i]:-SKIP_CHECKSUM}"; then
			true
		elif termux_download "${PKG_SRCURL[$i]}" "$file" "${PKG_SHA256[$i]:-SKIP_CHECKSUM}"; then
			if [ "$TERMUX_COPY_TO_SOURCE_MIRROR" = "true" ]; then
				mkdir -p "${TERMUX_OUTPUT_DIR}/source"
				cp -f "$file" "${TERMUX_OUTPUT_DIR}/source/${TERMUX_PKG_NAME}_$(basename ${PKG_SRCURL[$i]})"
			fi
		fi
	done
}
