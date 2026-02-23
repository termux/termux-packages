TERMUX_PKG_HOMEPAGE=https://github.com/jarun/bcal
TERMUX_PKG_DESCRIPTION="Command-line utility for storage conversions and calculations"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5"
TERMUX_PKG_SRCURL="https://github.com/jarun/bcal/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=7e00d38aca2272ef93f55515841e2912ecf845914ec140f8e4c356e1493cf5cf
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true

# 64-bit archs only, check https://github.com/jarun/bcal/issues/4
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
