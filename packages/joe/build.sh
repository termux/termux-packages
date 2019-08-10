TERMUX_PKG_HOMEPAGE=http://joe-editor.sourceforge.net
TERMUX_PKG_DESCRIPTION="Wordstar like text editor"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_DEPENDS="ncurses"
TERMUX_PKG_CONFLICTS="jupp"
TERMUX_PKG_VERSION=4.6
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/joe-editor/files/JOE%20sources/joe-${TERMUX_PKG_VERSION}/joe-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=495a0a61f26404070fe8a719d80406dc7f337623788e445b92a9f6de512ab9de
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-termcap"

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/joe 10
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/joe
		fi
	fi
	EOF
}
