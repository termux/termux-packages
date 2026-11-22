termux_download_src_archive() {
	local PKG_SRCURL=(${TERMUX_PKG_SRCURL[@]})
	local PKG_SHA256=(${TERMUX_PKG_SHA256[@]})
	if [ ! ${#PKG_SRCURL[@]} == ${#PKG_SHA256[@]} ] && [ ! ${#PKG_SHA256[@]} == 0 ]; then
		termux_error_exit "length of TERMUX_PKG_SRCURL isn't equal to length of TERMUX_PKG_SHA256."
	fi

	for i in $(seq 0 $(( ${#PKG_SRCURL[@]}-1 ))); do
		local file="$TERMUX_PKG_CACHEDIR/$(basename "${PKG_SRCURL[$i]}")"
		local checksum="${PKG_SHA256[$i]:-}"

		if termux_download "${PKG_SRCURL[$i]}" "$file" ${checksum:+"$checksum"}; then
			continue
		fi

		if (( ${#PKG_SRCURL[@]} == 1 )) && [[ -n "${TERMUX_PKG_SRCURL_FALLBACKS[*]-}" ]]; then
			echo "Primary download failed: ${PKG_SRCURL[$i]}" >&2
			echo "Attempting fallback mirrors..." >&2
			local fallback_url
			for fallback_url in "${TERMUX_PKG_SRCURL_FALLBACKS[@]}"; do
				[[ -z "$fallback_url" ]] && continue
				if termux_download "$fallback_url" "$file" ${checksum:+"$checksum"}; then
					continue 2
				fi
			done
		fi

		termux_error_exit "Failed to download source archive for ${PKG_SRCURL[$i]}"
	done
}
