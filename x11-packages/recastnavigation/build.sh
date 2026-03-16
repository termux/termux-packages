TERMUX_PKG_HOMEPAGE="http://recastnav.com/"
TERMUX_PKG_DESCRIPTION="Navigation-msh toolset for games"
TERMUX_PKG_LICENSE="ZLIB"
TERMUX_PKG_LICENSE_FILE="License.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.0"
TERMUX_PKG_SRCURL="https://github.com/recastnavigation/recastnavigation/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="d48ca0121962fa0639502c0f56c4e3ae72f98e55d88727225444f500775c0074"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glu, libc++, libglvnd, sdl2, sdl2-compat"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
}
