TERMUX_PKG_HOMEPAGE=https://github.com/andmarti1424/sc-im
TERMUX_PKG_DESCRIPTION="An improved version of sc, a spreadsheet calculator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.1
TERMUX_PKG_SRCURL=https://github.com/andmarti1424/sc-im/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=73958f2adf2548be138f90a1fa2cb3a9c316a6d8d78234ebb1dc408cbf83bac7
TERMUX_PKG_DEPENDS="libandroid-support, libzip, ncurses"
TERMUX_PKG_SUGGESTS="gnuplot"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -I$TERMUX_PREFIX/include/libandroid-support -DGNUPLOT -DNO_WORDEXP"
	TERMUX_PKG_BUILDDIR+="/src"
}
