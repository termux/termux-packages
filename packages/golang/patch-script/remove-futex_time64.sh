sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
	${TERMUX_SCRIPTDIR}/packages/golang/patch-script/remove-futex_time64.diff \
	| patch --silent -p1
