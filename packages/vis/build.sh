TERMUX_PKG_HOMEPAGE=https://www.brain-dump.org/projects/vis/
TERMUX_PKG_DESCRIPTION="Modern, legacy free, simple yet efficient vim-like editor"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.6
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/martanne/vis/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9ab4a3f1c5953475130b3c286af272fe5cfdf7cbb7f9fbebd31e9ea4f34e487d
TERMUX_PKG_DEPENDS="liblua53, libtermkey, lua-lpeg, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -I$TERMUX_PREFIX/include/lua5.3"
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ] || [ "\$1" = "abort-upgrade" ]; then
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
	if [ "\$1" != "upgrade" ]; then
		if [ -x "$TERMUX_PREFIX/bin/update-alternatives" ]; then
			update-alternatives --remove editor $TERMUX_PREFIX/bin/vis
			update-alternatives --remove vi $TERMUX_PREFIX/bin/vis
		fi
	fi
	EOF
}
