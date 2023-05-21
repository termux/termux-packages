# Dead upstream.
TERMUX_PKG_HOMEPAGE=https://sdl2pango.sourceforge.net/
TERMUX_PKG_DESCRIPTION="SDL2 library for internationalized text rendering"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.1.2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/project/tuxpaint-sdl2/SDL2_Pango/SDL2_Pango-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=32eae8044c8ccd454dcf1948e669e63f9806fa7aa30a3de3125da23e4d37826a
TERMUX_PKG_DEPENDS="glib, pango, sdl2"

termux_step_pre_configure() {
	mkdir -p m4
	cp $TERMUX_PREFIX/share/aclocal/sdl2.m4 m4/
	autoreconf -fi -Im4

	CPPFLAGS+=" -D__FT2_BUILD_UNIX_H__"
	CFLAGS+=" $($PKG_CONFIG sdl2 --cflags)"
	LDFLAGS+=" $($PKG_CONFIG sdl2 --libs)"
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}
