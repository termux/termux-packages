TERMUX_PKG_HOMEPAGE=http://simh.trailing-edge.com/
TERMUX_PKG_DESCRIPTION="A simulator for historic computer systems, as well as papers and reflections on the history of computing."
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_VERSION=3.9.0
TERMUX_PKG_SRCURL=https://github.com/simh/simh.git
TERMUX_PKG_DEPENDS="libc++, libpcap, libsdl, libsdl-ttf, libpng"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
#	sed 's/math/c++\/v1\/math/g' -i */*.c
	make GCC=$CC LDFLAGS="$LDFLAGS" #LIBRARIES="${TERMUX_PREFIX}/lib" INCLUDES="${TERMUX_PREFIX}/include:${TERMUX_PREFIX}/include/c++/v1"
}
