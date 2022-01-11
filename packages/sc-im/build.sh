TERMUX_PKG_HOMEPAGE=https://github.com/andmarti1424/sc-im
TERMUX_PKG_DESCRIPTION="An improved version of sc, a spreadsheet calculator"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/andmarti1424/sc-im/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7f00c98601e7f7709431fb4cbb83707c87016a3b015d48e5a7c2f018eff4b7f7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libandroid-wordexp, libzip, ncurses"
TERMUX_PKG_SUGGESTS="gnuplot"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -I$TERMUX_PREFIX/include/libandroid-support -DGNUPLOT"
	LDFLAGS+=" -landroid-wordexp"
	TERMUX_PKG_BUILDDIR+="/src"
}
