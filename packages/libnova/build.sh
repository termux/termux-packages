TERMUX_PKG_HOMEPAGE="http://libnova.sourceforge.net"
TERMUX_PKG_DESCRIPTION="A general purpose, double precision, Celestial Mechanics, Astrometry and Astrodynamics library"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.15.0"
TERMUX_PKG_SRCURL="https://downloads.sourceforge.net/sourceforge/libnova/libnova-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=7c5aa33e45a3e7118d77df05af7341e61784284f1e8d0d965307f1663f415bb1
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -fi
}
