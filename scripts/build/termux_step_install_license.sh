termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME"
	if [ ! "${TERMUX_PKG_LICENSE_FILE}" = "" ]; then
		for LICENSE in $TERMUX_PKG_LICENSE_FILE; do
			if [ ! -f "$TERMUX_PKG_SRCDIR/$LICENSE" ]; then termux_error_exit "$TERMUX_PKG_SRCDIR/$LICENSE does not exist"; fi
			cp ${TERMUX_PKG_SRCDIR}/${LICENSE} ${TERMUX_PREFIX}/share/${TERMUX_PKG_NAME}
		done
	else
		local COUNTER=0
		for LICENSE in $(echo $TERMUX_PKG_LICENSE | sed 's/,/ /g'); do
			echo "checking for $TERMUX_SCRIPTDIR/packages/termux-licenses/LICENSES/${LICENSE}.txt"
			if [ -f "$TERMUX_SCRIPTDIR/packages/termux-licenses/LICENSES/${LICENSE}.txt" ]; then
				if [[ $COUNTER > 0 ]]; then
					ln -sf "../LICENSES/${LICENSE}.txt" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/LICENSE.${COUNTER}"
				else
					ln -sf "../LICENSES/${LICENSE}.txt" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/LICENSE"
				fi
			fi
			COUNTER=$((COUNTER + 1))
		done
	fi
}
