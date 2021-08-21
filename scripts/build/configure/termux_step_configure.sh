termux_step_configure() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	if [ "$TERMUX_PKG_FORCE_CMAKE" = "false" ] && [ -f "$TERMUX_PKG_SRCDIR/configure" ]; then
		if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
			return;
		fi
		termux_step_configure_autotools
	elif [ "$TERMUX_PKG_FORCE_CMAKE" = "true" ] || [ -f "$TERMUX_PKG_SRCDIR/CMakeLists.txt" ]; then
		if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
			termux_setup_cmake
			if [ "$TERMUX_CMAKE_BUILD" = Ninja ]; then
				termux_setup_ninja
			fi
			return;
		fi
		termux_step_configure_cmake
	elif [ -f "$TERMUX_PKG_SRCDIR/meson.build" ]; then
		if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
			return;
		fi
		termux_step_configure_meson
	fi
}
