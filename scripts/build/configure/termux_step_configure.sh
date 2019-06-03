termux_step_configure() {
	if [ "$TERMUX_PKG_FORCE_CMAKE" == 'no' ] && [ -f "$TERMUX_PKG_SRCDIR/configure" ]; then
		termux_step_configure_autotools
	elif [ -f "$TERMUX_PKG_SRCDIR/CMakeLists.txt" ]; then
		termux_step_configure_cmake
	elif [ -f "$TERMUX_PKG_SRCDIR/meson.build" ]; then
		termux_step_configure_meson
	fi
}
