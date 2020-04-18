termux_step_handle_hostbuild() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return
	[ "$TERMUX_PKG_HOSTBUILD" = "false" ] && return

	cd "$TERMUX_PKG_SRCDIR"
	if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
		for patch in $TERMUX_PKG_BUILDER_DIR/*.patch.beforehostbuild; do
			test -f "$patch" && sed "s%\@TERMUX_PREFIX\@%${TERMUX_PREFIX}%g" "$patch" | patch --silent -p1
		done
	fi

	local TERMUX_HOSTBUILD_MARKER="$TERMUX_PKG_HOSTBUILD_DIR/TERMUX_BUILT_FOR_$TERMUX_PKG_VERSION"
	if [ ! -f "$TERMUX_HOSTBUILD_MARKER" ]; then
		if [ "$TERMUX_PKG_QUICK_REBUILD" = "false" ]; then
			rm -Rf "$TERMUX_PKG_HOSTBUILD_DIR"
			mkdir -p "$TERMUX_PKG_HOSTBUILD_DIR"
		fi
		cd "$TERMUX_PKG_HOSTBUILD_DIR"
		termux_step_host_build
		touch "$TERMUX_HOSTBUILD_MARKER"
	fi
}
