TERMUX_PKG_HOMEPAGE=https://github.com/vcrhonek/hwdata
TERMUX_PKG_DESCRIPTION="Database of hardware identification and configuration data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.412"
TERMUX_PKG_SRCURL=https://github.com/vcrhonek/hwdata/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f0c64cd7e31d70a5fb3a52e53ab50a61e74c0421a6381eaa45114eec3bde5fe7
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
