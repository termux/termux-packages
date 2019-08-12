termux_step_make() {
	local QUIET_BUILD=
	if [ "$TERMUX_QUIET_BUILD" = true ]; then
		QUIET_BUILD="-s"
	fi

	if test -f build.ninja; then
		ninja -w dupbuild=warn -j $TERMUX_MAKE_PROCESSES
	elif ls ./*akefile &> /dev/null || [ ! -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD
		else
			make -j $TERMUX_MAKE_PROCESSES $QUIET_BUILD ${TERMUX_PKG_EXTRA_MAKE_ARGS}
		fi
	fi
}
