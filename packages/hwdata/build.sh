TERMUX_PKG_HOMEPAGE=https://github.com/vcrhonek/hwdata
TERMUX_PKG_DESCRIPTION="Database of hardware identification and configuration data"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.409"
TERMUX_PKG_SRCURL=https://github.com/vcrhonek/hwdata/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=23006accc0f931dd5187d0307a57d0744e2b8feb85e73c37bc0f5229fb31eadd
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
