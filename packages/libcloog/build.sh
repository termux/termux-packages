TERMUX_PKG_HOMEPAGE="http://www.bastoul.net/cloog/index.php"
TERMUX_PKG_DESCRIPTION="Library that generates loops for scanning polyhedra"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20.0"
TERMUX_PKG_SRCURL="https://github.com/periscop/cloog/archive/refs/tags/cloog-$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e6bdbe02a409f216ec724e26317d122baa17467e05fe5ad3cc8591f2f0a5df47
TERMUX_PKG_DEPENDS="libisl, libosl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-isl=system
--with-osl=system
"

termux_step_pre_configure() {
	autoreconf -fi
}
