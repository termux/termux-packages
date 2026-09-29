sed -e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|" \
	${TERMUX_SCRIPTDIR}/packages/golang/patch-script/remove-pidfd.diff \
	| patch --silent -p1
