TERMUX_PKG_HOMEPAGE=http://simh.trailing-edge.com/
TERMUX_PKG_DESCRIPTION="A simulator for historic computer systems, as well as papers and reflections on the history of computing."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.11-1
TERMUX_PKG_SRCURL=https://github.com/simh/simh/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c8a2fc62bfa9369f75935950512a4cac204fd813ce6a9a222b2c6a76503befdb
TERMUX_PKG_DEPENDS="libpcap, libsdl, libpng"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	sed 's/math/c++\/v1\/math/g' -i */*.c
	make GCC=$CC LDFLAGS="$LDFLAGS" LIBRARIES="${TERMUX_PREFIX}/lib" INCLUDES="${TERMUX_PREFIX}/include"
}
