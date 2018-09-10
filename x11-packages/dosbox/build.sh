TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://dosbox.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Emulator with builtin DOS for running DOS Games"
TERMUX_PKG_VERSION=0.74
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/dosbox/dosbox-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=13f74916e2d4002bad1978e55727f302ff6df3d9be2f9b0e271501bd0a938e05
TERMUX_PKG_DEPENDS="libc++, libsdl, libsdl-net"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-dynamic-x86 --disable-fpu-x86 --disable-opengl"
