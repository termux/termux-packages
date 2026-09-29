TERMUX_PKG_HOMEPAGE=https://github.com/jarun/bcal
TERMUX_PKG_DESCRIPTION="Command-line utility for storage conversions and calculations"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.6"
TERMUX_PKG_SRCURL="https://github.com/jarun/bcal/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=bac318405221f2f88d374683549338515b070ca7491497eda2ac9c17bcbb0458
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

# 64-bit archs only, check https://github.com/jarun/bcal/issues/4
TERMUX_PKG_EXCLUDED_ARCHES="arm, i686"
