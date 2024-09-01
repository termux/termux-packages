TERMUX_PKG_HOMEPAGE=https://www.brain-dump.org/projects/vis/
TERMUX_PKG_DESCRIPTION="Modern, legacy free, simple yet efficient vim-like editor"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/martanne/vis/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=bd37ffba5535e665c1e883c25ba5f4e3307569b6d392c60f3c7d5dedd2efcfca
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="liblua54, libunibilium, libtermkey, lua-lpeg, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -I$TERMUX_PREFIX/include -I$TERMUX_PREFIX/include/lua/5.4"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --install \
				$TERMUX_PREFIX/bin/editor editor $TERMUX_PREFIX/bin/vis 30
			update-alternatives --install \
				$TERMUX_PREFIX/bin/vi vi $TERMUX_PREFIX/bin/vis 10
		fi
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "$TERMUX_PACKAGE_FORMAT" = "pacman" ] || [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/vis
			update-alternatives --remove vi $TERMUX_PREFIX/bin/vis
		fi
	fi
	EOF
}
