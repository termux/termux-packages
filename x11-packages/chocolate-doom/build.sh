TERMUX_PKG_HOMEPAGE=https://www.chocolate-doom.org
TERMUX_PKG_DESCRIPTION="Historically-accurate Doom, Heretic, Hexen, and Strife ports."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="WMCB-Tech @marcusz"
TERMUX_PKG_VERSION=3.0.1
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://github.com/chocolate-doom/chocolate-doom/archive/refs/tags/chocolate-doom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a54383beef6a52babc5b00d58fcf53a454f012ced7b1936ba359b13f1f10ac66
TERMUX_PKG_DEPENDS="sdl2, sdl2-mixer, sdl2-net, mpg123"

termux_step_pre_configure(){
    autoreconf -fi
}
