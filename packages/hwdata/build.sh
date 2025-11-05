TERMUX_PKG_HOMEPAGE=https://github.com/vcrhonek/hwdata
TERMUX_PKG_DESCRIPTION="Database of hardware identification and configuration data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.401"
TERMUX_PKG_SRCURL=https://github.com/vcrhonek/hwdata/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9ff93b9807cc014ed8f7f5cb5dc2c31e714058c82ddc59b7355f5c57c9b759e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--datadir=${TERMUX_PREFIX}/share
--disable-blacklist
"

termux_step_pre_configure() {
	mv Makefile{,.unused}
}

termux_step_post_configure() {
	mv Makefile{.unused,}
}
