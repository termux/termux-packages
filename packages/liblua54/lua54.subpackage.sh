TERMUX_SUBPKG_INCLUDE="bin/ share/man/man1/"
TERMUX_SUBPKG_DESCRIPTION="Simple, extensible, embeddable programming language"
TERMUX_SUBPKG_DEPENDS="readline"

termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/lua lua $TERMUX_PREFIX/bin/lua5.4 140
			update-alternatives --install \
				$TERMUX_PREFIX/bin/luac luac $TERMUX_PREFIX/bin/luac5.4 140
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove lua $TERMUX_PREFIX/bin/lua
			update-alternatives --remove luac $TERMUX_PREFIX/bin/luac
		fi
	fi
	EOF
}
