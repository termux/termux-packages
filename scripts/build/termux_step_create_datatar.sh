termux_step_create_datatar() {
	# Create data tarball containing files to package:
	cd "$TERMUX_PKG_MASSAGEDIR"

	local HARDLINKS
	HARDLINKS="$(find . -type f -links +1)"
	if [ -n "$HARDLINKS" ]; then
		termux_error_exit "Package contains hard links: $HARDLINKS"
	fi

	if [ "$TERMUX_PKG_METAPACKAGE" = "true" ]; then
		# Metapackage doesn't have data inside.
		rm -rf data
	else
		if [ "$(find . -type f)" = "" ]; then
			termux_error_exit "No files in package"
		fi
	fi

	tar -cJf "$TERMUX_PKG_PACKAGEDIR/data.tar.xz" .
}
