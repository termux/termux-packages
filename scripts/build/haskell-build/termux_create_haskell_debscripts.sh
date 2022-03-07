termux_create_haskell_debscripts() {
	if [ "${TERMUX_PKG_IS_HASKELL_LIB}" = true ]; then
		cat <<-EOF >./postinst
			#!${TERMUX_PREFIX}/bin/sh
				sh ${TERMUX_PREFIX}/share/haskell/register/${TERMUX_PKG_NAME}.sh
		EOF

		cat <<-EOF >./prerm
			#!${TERMUX_PREFIX}/bin/sh
			if  [ "${TERMUX_PACKAGE_FORMAT}" = "pacman" ] || [ "\$1" = "remove" ] || [ "\$1" = "update" ]; then
					sh ${TERMUX_PREFIX}/share/haskell/unregister/${TERMUX_PKG_NAME}.sh
			fi
		EOF
	else
		return 0
	fi
}
