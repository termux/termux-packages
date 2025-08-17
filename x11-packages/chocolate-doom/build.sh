TERMUX_PKG_HOMEPAGE=https://www.chocolate-doom.org
TERMUX_PKG_DESCRIPTION="Historically-accurate Doom, Heretic, Hexen, and Strife ports."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.1"
TERMUX_PKG_SRCURL=https://github.com/chocolate-doom/chocolate-doom/archive/refs/tags/chocolate-doom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1edcc41254bdc194beb0d33e267fae306556c4d24110a1d3d3f865717f25da23
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="sdl2 | sdl2-compat, sdl2-mixer, sdl2-net"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"

termux_step_pre_configure(){
	autoreconf -fi
	CFLAGS+=" -fcommon"
}
