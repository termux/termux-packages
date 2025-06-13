TERMUX_PKG_HOMEPAGE=https://github.com/wingo/fibers
TERMUX_PKG_DESCRIPTION='Concurrent ML-like concurrency for Guile'
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.1
TERMUX_PKG_SRCURL=https://github.com/wingo/fibers/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=45697ec7d8a068eac348c700273b2d67f3f317fa5df3896b8981727ba42cf84f
TERMUX_PKG_DEPENDS="guile"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	autoreconf -vif
}
