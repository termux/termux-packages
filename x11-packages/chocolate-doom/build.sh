TERMUX_PKG_HOMEPAGE=https://www.chocolate-doom.org
TERMUX_PKG_DESCRIPTION="Historically-accurate Doom, Heretic, Hexen, and Strife ports."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/chocolate-doom/chocolate-doom/archive/refs/tags/chocolate-doom-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f2c64843dcec312032b180c3b2f34b4cb26c4dcdaa7375a1601a3b1df11ef84d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_SED_REGEXP='s/.*-//'
TERMUX_PKG_DEPENDS="sdl2 | sdl2-compat, sdl2-mixer, sdl2-net, mpg123"
TERMUX_PKG_ANTI_BUILD_DEPENDS="sdl2-compat"

termux_step_pre_configure(){
	autoreconf -fi
	CFLAGS+=" -fcommon"
}
