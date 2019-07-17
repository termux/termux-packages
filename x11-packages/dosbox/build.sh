TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dosbox/
TERMUX_PKG_DESCRIPTION="Emulator with builtin DOS for running DOS Games"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.74.3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/dosbox/dosbox-${TERMUX_PKG_VERSION/.2/-2}.tar.gz
TERMUX_PKG_SHA256=8cf5ce27d21490c24eedf91e0ac2bc4a748ba8f4eb20cb7c1fc9442d2d580008
TERMUX_PKG_DEPENDS="libc++, libpng, libx11, sdl, sdl-net, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dynamic-x86
--disable-fpu-x86
--disable-opengl
"
