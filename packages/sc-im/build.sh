TERMUX_PKG_HOMEPAGE=https://github.com/andmarti1424/sc-im
TERMUX_PKG_DESCRIPTION="An improved version of sc, a spreadsheet calculator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.4"
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/andmarti1424/sc-im/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ebb1f10006fe49f964a356494f96d86a4f06eb018659e3b9bde63b25c03abdf0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-wordexp, liblua54, libxls, libxlsxwriter, libxml2, libzip, ncurses"
TERMUX_PKG_SUGGESTS="gnuplot"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
LUA_PKGNAME=lua54
"

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -I$TERMUX_PREFIX/include/libandroid-support -DGNUPLOT"
	LDFLAGS+=" -landroid-wordexp"
	TERMUX_PKG_BUILDDIR+="/src"
}
