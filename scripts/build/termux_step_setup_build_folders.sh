termux_step_setup_build_folders() {
	# Following directories may contain files with read-only permissions which
	# makes them undeletable. We need to fix that.
	[ -d "$TERMUX_PKG_BUILDDIR" ] && chmod +w -R "$TERMUX_PKG_BUILDDIR"
	[ -d "$TERMUX_PKG_SRCDIR" ] && chmod +w -R "$TERMUX_PKG_SRCDIR"

	# Cleanup old build state:
	rm -Rf "$TERMUX_PKG_BUILDDIR" \
		"$TERMUX_PKG_SRCDIR"

	# Cleanup old packaging state:
	rm -Rf "$TERMUX_PKG_PACKAGEDIR" \
		"$TERMUX_PKG_TMPDIR" \
		"$TERMUX_PKG_MASSAGEDIR"

	# Ensure folders present (but not $TERMUX_PKG_SRCDIR, it will be created in build)
	mkdir -p "$TERMUX_COMMON_CACHEDIR" \
		 "$TERMUX_DEBDIR" \
		 "$TERMUX_PKG_BUILDDIR" \
		 "$TERMUX_PKG_PACKAGEDIR" \
		 "$TERMUX_PKG_TMPDIR" \
		 "$TERMUX_PKG_CACHEDIR" \
		 "$TERMUX_PKG_MASSAGEDIR" \
		 $TERMUX_PREFIX/{bin,etc,lib,libexec,share,share/LICENSES,tmp,include}
}
