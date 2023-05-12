termux_step_configure() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	# This check should be above autotools check as haskell package too makes use of configure scripts which
	# should be executed by its own build system.
	if ls "${TERMUX_PKG_SRCDIR}"/*.cabal &>/dev/null; then
		[ "$TERMUX_CONTINUE_BUILD" == "true" ] && return
		termux_step_configure_haskell_build
	elif [ "$TERMUX_PKG_FORCE_CMAKE" = "false" ] && [ -f "$TERMUX_PKG_SRCDIR/configure" ]; then
		if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
			return
		fi
		termux_step_configure_autotools
	elif [ "$TERMUX_PKG_FORCE_CMAKE" = "true" ] || [ -f "$TERMUX_PKG_SRCDIR/CMakeLists.txt" ]; then
		termux_setup_cmake
		if [ "$TERMUX_CMAKE_BUILD" = Ninja ]; then
			termux_setup_ninja
		fi

		# Some packages, for example swift, uses cmake
		# internally, but cannot be configured with our
		# termux_step_configure_cmake function (CMakeLists.txt
		# is not in src dir)
		if [ -f "$TERMUX_PKG_SRCDIR/CMakeLists.txt" ] &&
			[ "$TERMUX_CONTINUE_BUILD" == "false" ]; then
			termux_step_configure_cmake
		fi
	elif [ -f "$TERMUX_PKG_SRCDIR/meson.build" ]; then
		if [ "$TERMUX_CONTINUE_BUILD" == "true" ]; then
			return
		fi
		termux_step_configure_meson
	fi
}
