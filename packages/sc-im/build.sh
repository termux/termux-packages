TERMUX_PKG_HOMEPAGE=https://github.com/andmarti1424/sc-im
TERMUX_PKG_DESCRIPTION="An improved version of sc, a spreadsheet calculator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.5"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/andmarti1424/sc-im/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=49adb76fc55bc3e6ea8ee414f41428db4aef947e247718d9210be8d14a6524bd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-wordexp, lua54, libxls, libxlsxwriter, libxml2, libzip, ncurses"
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
