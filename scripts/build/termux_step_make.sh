termux_step_make() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	local QUIET_BUILD=
	if [ "$TERMUX_QUIET_BUILD" = true ]; then
		QUIET_BUILD="-s"
	fi

	if test -f build.ninja; then
		ninja -j $TERMUX_PKG_MAKE_PROCESSES
	elif ls ./*.cabal &>/dev/null; then
		cabal --config="$TERMUX_CABAL_CONFIG" build
	elif ls ./*akefile &>/dev/null || [ ! -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
		if [ -z "$TERMUX_PKG_EXTRA_MAKE_ARGS" ]; then
			make -j $TERMUX_PKG_MAKE_PROCESSES $QUIET_BUILD
		else
			make -j $TERMUX_PKG_MAKE_PROCESSES $QUIET_BUILD ${TERMUX_PKG_EXTRA_MAKE_ARGS}
		fi
	elif test -f dub.json; then
		termux_setup_ldc
		dub build \
			-b release \
			--compiler=ldc2 \
			--arch "$TERMUX_LDC_TRIPLE"\
			${TERMUX_PKG_EXTRA_CONFIGURE_ARGS:+ $TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
	fi
}

termux_step_make_multilib() {
	termux_step_make
}
