TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/infozip/
TERMUX_PKG_DESCRIPTION="Tools for working with zip files"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/infozip/zip30.tar.gz
TERMUX_PKG_SHA256=f0e8bb1f9b7eb0b01285495a2699df3a4b766784c1765a8f1aeedf63c0806369
TERMUX_PKG_DEPENDS="libandroid-support, libbz2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_configure() {
	cp unix/Makefile Makefile
}

termux_step_make() {
	LD="$CC $LDFLAGS" CC="$CC $CFLAGS $CPPFLAGS $LDFLAGS" make -j $TERMUX_PKG_MAKE_PROCESSES generic
}
