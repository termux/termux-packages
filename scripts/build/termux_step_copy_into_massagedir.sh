termux_step_copy_into_massagedir() {
	local DEST="$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX_CLASSICAL"
	mkdir -p "$DEST"
	# Copy files changed during the build into massagedir in order to massage them
	tar -C "$TERMUX_PREFIX_CLASSICAL" -N "$TERMUX_BUILD_TS_FILE" --exclude='tmp' --exclude='__pycache__' -cf - . | \
		tar -C "$DEST" -xf -
}
