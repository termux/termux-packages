termux_step_extract_into_massagedir() {
	local TARBALL_ORIG=$TERMUX_PKG_PACKAGEDIR/${TERMUX_PKG_NAME}_orig.tar.gz

	# Build diff tar with what has changed during the build:
	cd $TERMUX_PREFIX
	tar -N "$TERMUX_BUILD_TS_FILE" -czf "$TARBALL_ORIG" .

	# Extract tar in order to massage it
	mkdir -p "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"
	cd "$TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX"

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		# Tar on android-5 may show error like 'Cannot change mode to ...: No such file or directory'
		# when extracting symlinks. Using bsdtar instead as workaround.
		bsdtar xf "$TARBALL_ORIG"
	else
		tar xf "$TARBALL_ORIG"
	fi

	rm "$TARBALL_ORIG"
}
