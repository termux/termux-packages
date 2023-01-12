TERMUX_PKG_HOMEPAGE=https://github.com/andmarti1424/sc-im
TERMUX_PKG_DESCRIPTION="An improved version of sc, a spreadsheet calculator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.3
TERMUX_PKG_SRCURL=https://github.com/andmarti1424/sc-im/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5568f9987b6d26535c0e7a427158848f1bc03d829f74e41cbcf007d8704e9bd3
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-wordexp, liblua51, libxls, libxlsxwriter, libxml2, libzip, ncurses"
TERMUX_PKG_SUGGESTS="gnuplot"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -I$TERMUX_PREFIX/include/libandroid-support -DGNUPLOT"
	LDFLAGS+=" -landroid-wordexp"
	TERMUX_PKG_BUILDDIR+="/src"
}
