termux_step_extract_into_massagedir() {
	local TARBALL_ORIG=$TERMUX_PKG_PACKAGEDIR/${TERMUX_PKG_NAME}_orig.tar.gz

	# Build diff tar with what has changed during the build:
	cd $TERMUX_PREFIX
	tar -N "$TERMUX_BUILD_TS_FILE" \
		--exclude='lib/libutil.so' \
		-czf "$TARBALL_ORIG" .

	# Extract tar in order to massage it
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	tar xf "$TARBALL_ORIG"
	rm "$TARBALL_ORIG"
}
