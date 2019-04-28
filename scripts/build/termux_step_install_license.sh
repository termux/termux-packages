termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME"
	local COUNTER=0
	for LICENSE in $(echo $TERMUX_PKG_LICENSE | sed 's/,/ /g'); do
		if [ -f "$TERMUX_SCRIPTDIR/packages/termux-licenses/LICENSES/${LICENSE}.txt" ]; then
			if [[ $COUNTER > 0 ]]; then
				ln -s "../licenses/${LICENSE}.txt" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/LICENSE.${COUNTER}"
			else
				ln -s "../licenses/${LICENSE}.txt" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/LICENSE"
			fi
		else
			for POSSIBLE_LICENSE in "LICENSE*" "license*" "COPYRIGHT" "copyright"; do
				if [ -f "$TERMUX_PKG_SRCDIR/$POSSIBLE_LICENSE" ]; then
					cp "$TERMUX_PKG_SRCDIR/$POSSIBLE_LICENSE" "$TERMUX_PREFIX/share/$TERMUX_PKG_NAME/"
					break
				fi
			done
		fi
		COUNTER=$((COUNTER + 1))
	done
}
