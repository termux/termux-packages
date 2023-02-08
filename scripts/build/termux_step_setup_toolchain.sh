termux_step_setup_toolchain() {
	TERMUX_STANDALONE_TOOLCHAIN="$TERMUX_COMMON_CACHEDIR/android-r${TERMUX_NDK_VERSION}-api-${TERMUX_PKG_API_LEVEL}"
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	# Bump TERMUX_STANDALONE_TOOLCHAIN if a change is made in
	# toolchain setup to ensure that everyone gets an updated
	# toolchain
	if [ "${TERMUX_NDK_VERSION}" = 25c ]; then
		TERMUX_STANDALONE_TOOLCHAIN+="-v1"
		termux_setup_toolchain_25c
	elif [ "${TERMUX_NDK_VERSION}" = 23c ]; then
		TERMUX_STANDALONE_TOOLCHAIN+="-v4"
		termux_setup_toolchain_23c
	else
		termux_error_exit "We do not have a setup_toolchain function for NDK version $TERMUX_NDK_VERSION"
	fi
}
