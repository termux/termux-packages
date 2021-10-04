TERMUX_PKG_HOMEPAGE=https://github.com/Aanok/jftui
TERMUX_PKG_DESCRIPTION="jftui is a minimalistic, lightweight C99 command line client for the open source Jellyfin media server."
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="Maxr1998 <max.rumpf1998@gmail.com>"
TERMUX_PKG_VERSION=0.5.1
TERMUX_PKG_SRCURL=https://github.com/Aanok/jftui/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=406727e4f021cd0c6cf9c1a6199d81fbc4e523a881f62c323fe363e8505dc25d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libcurl, yajl, mpv"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	sed -i 's| -march=native||' Makefile
	sed -i 's|^CFLAGS=|override CFLAGS+=|' Makefile
	sed -i 's|^LFLAGS=|override LFLAGS+=|' Makefile
}

termux_step_make() {
	make CFLAGS="$CPPFLAGS" LFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	install -Dm700 $TERMUX_PKG_SRCDIR/build/jftui "$TERMUX_PREFIX/bin/jftui"
}
