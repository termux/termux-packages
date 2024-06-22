termux_step_replace_guess_scripts() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	cd "$TERMUX_PKG_SRCDIR"
	find . -name config.sub -exec chmod u+w '{}' \; -exec cp "$TERMUX_SCRIPTDIR/scripts/config.sub" '{}' \;
	find . -name config.guess -exec chmod u+w '{}' \; -exec cp "$TERMUX_SCRIPTDIR/scripts/config.guess" '{}' \;

	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		local list_files=$(grep -s -r -l '^#!.*/bin/' $TERMUX_PKG_SRCDIR)
		if [ -n "$list_files" ]; then
			sed -i "s|#\!.*/bin/|#\!$TERMUX_PREFIX_CLASSICAL/bin/|" $list_files
		fi
	fi
}
