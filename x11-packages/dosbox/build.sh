TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dosbox/
TERMUX_PKG_DESCRIPTION="Emulator with builtin DOS for running DOS Games"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.74.3
TERMUX_PKG_REVISION=21
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/dosbox/dosbox-${TERMUX_PKG_VERSION/.3/-3}.tar.gz
TERMUX_PKG_SHA256=c0d13dd7ed2ed363b68de615475781e891cd582e8162b5c3669137502222260a
TERMUX_PKG_DEPENDS="libc++, libpng, libx11, sdl, sdl-net, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dynamic-x86
--disable-fpu-x86
--disable-opengl
"
