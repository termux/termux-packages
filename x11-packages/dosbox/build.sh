TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/dosbox/
TERMUX_PKG_DESCRIPTION="Emulator with builtin DOS for running DOS Games"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.74.2
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/dosbox/dosbox-${TERMUX_PKG_VERSION/.2/-2}.tar.gz
TERMUX_PKG_SHA256=7077303595bedd7cd0bb94227fa9a6b5609e7c90a3e6523af11bc4afcb0a57cf
TERMUX_PKG_DEPENDS="libc++, libpng, libx11, sdl, sdl-net, zlib"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-dynamic-x86
--disable-fpu-x86
--disable-opengl
"
