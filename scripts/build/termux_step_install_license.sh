termux_step_install_license() {
	[ "$TERMUX_PKG_METAPACKAGE" = "true" ] && return

	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"

	if [ ! "${TERMUX_PKG_LICENSE_FILE}" = "" ]; then
		local LICENSE
		for LICENSE in $TERMUX_PKG_LICENSE_FILE; do
			if [ ! -f "$TERMUX_PKG_SRCDIR/$LICENSE" ]; then
				termux_error_exit "$TERMUX_PKG_SRCDIR/$LICENSE does not exist"
			fi
			cp -f "${TERMUX_PKG_SRCDIR}/${LICENSE}" "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}"/
		done
	else
		local COUNTER=0
		local LICENSE
		while read -r LICENSE; do
			if [ -f "$TERMUX_SCRIPTDIR/packages/termux-licenses/LICENSES/${LICENSE}.txt" ]; then
				if [[ $COUNTER -gt 0 ]]; then
					ln -sf "../../LICENSES/${LICENSE}.txt" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE.${COUNTER}"
				else
					ln -sf "../../LICENSES/${LICENSE}.txt" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE"
				fi
			fi
			COUNTER=$((COUNTER + 1))
		done < <(echo "$TERMUX_PKG_LICENSE" | sed "s/,/\n/g")

		for LICENSE in "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"/LICENSE*; do
			if [ "$LICENSE" = "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/LICENSE*" ]; then
				termux_error_exit "No LICENSE file was installed for $TERMUX_PKG_NAME"
			fi
		done
	fi
}
