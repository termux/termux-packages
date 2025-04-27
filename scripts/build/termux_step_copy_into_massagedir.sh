termux_step_copy_into_massagedir() {
	local DEST="$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
	cd "$TERMUX_PREFIX_CLASSICAL"
	mkdir -p "$DEST"
	# Recreate each new directory and copy its metadata in one go
	find . -path ./tmp -prune -o -type d -newer "$TERMUX_BUILD_TS_FILE" \
		-exec mkdir -p "$DEST"/{} \; -exec chmod --reference="{}" "$DEST"/{} \;
	# Copy only files modified during the build preserving original modes in order to massage them
	# xargs is needed to avoid exceeding ARG_MAX
	find . -path ./tmp -prune -o -newer "$TERMUX_BUILD_TS_FILE" \( -type f -o -type l \) \
		-exec cp -P --preserve=all --parents -t "$DEST" {} +
}
