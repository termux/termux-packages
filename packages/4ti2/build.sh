TERMUX_PKG_HOMEPAGE="https://github.com/4ti2/4ti2"
TERMUX_PKG_DESCRIPTION="A software package for algebraic, geometric and \
combinatorial problems on linear spaces."
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.9"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_SRCURL="https://github.com/4ti2/4ti2/archive/refs/tags/Release_${TERMUX_PKG_VERSION//./_}.tar.gz"
TERMUX_PKG_SHA256=7b1015718102d8cd4dc2de64f69094fdba0bc69a1878ada5960979b171ff89e4
TERMUX_PKG_DEPENDS="glpk, libgmp"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-shared
--disable-static
"

termux_step_pre_configure() {
	autoreconf -fi
}
