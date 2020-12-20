TERMUX_PKG_HOMEPAGE='https://craigbarnes.gitlab.io/dte/'
TERMUX_PKG_DESCRIPTION='A small, configurable console text editor'
TERMUX_PKG_LICENSE='GPL-2.0'
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.1
TERMUX_PKG_SRCURL="https://craigbarnes.gitlab.io/dist/dte/dte-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256='80d2732269a308b5e1126ecc16c28cda032864f625a95184821a73c054f81a2d'
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-glob, libiconv, ncurses"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	make \
		-j$TERMUX_MAKE_PROCESSES V=1 \
		LDLIBS='-landroid-support -landroid-glob -liconv -lcurses'
}

termux_step_make_install() {
    make install V=1 prefix="$TERMUX_PREFIX"
}
