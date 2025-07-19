termux_step_setup_toolchain() {
	if [ "$TERMUX_PACKAGE_LIBRARY" = "bionic" ]; then
		TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"
		[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

		# Bump TERMUX_STANDALONE_TOOLCHAIN if a change is made in
		# toolchain setup to ensure that everyone gets an updated
		# toolchain
		if [ "${TERMUX_NDK_VERSION}" = "28c" ]; then
			TERMUX_STANDALONE_TOOLCHAIN+="-v1"
			termux_setup_toolchain_28c
		elif [ "${TERMUX_NDK_VERSION}" = 23c ]; then
			TERMUX_STANDALONE_TOOLCHAIN+="-v8"
			termux_setup_toolchain_23c
		else
			termux_error_exit "We do not have a setup_toolchain function for NDK version $TERMUX_NDK_VERSION"
		fi
	elif [ "$TERMUX_PACKAGE_LIBRARY" = "glibc" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_PREFIX"
		else
			TERMUX_STANDALONE_TOOLCHAIN="${CGCT_DIR}/${TERMUX_ARCH}"
		fi
		termux_setup_toolchain_gnu
	fi
}

termux_step_setup_multilib_environment() {
	termux_conf_multilib_vars
	if [ "$TERMUX_PKG_BUILD_ONLY_MULTILIB" = "false" ]; then
		TERMUX_PKG_BUILDDIR="$TERMUX_PKG_MULTILIB_BUILDDIR"
	fi
	termux_step_setup_arch_variables
	termux_step_setup_pkg_config_libdir
	termux_step_setup_toolchain
	cd $TERMUX_PKG_BUILDDIR
}
