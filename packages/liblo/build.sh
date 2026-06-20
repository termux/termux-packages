TERMUX_PKG_HOMEPAGE=https://liblo.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A lightweight library that provides an easy to use implementation of the OSC protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.36"
# https://downloads.sourceforge.net/liblo/liblo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/radarsat1/liblo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=31b48e5fc61e9fc953c906f5abce97200cde86fba630f755c9fd9d1d7724a6d2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-doc
"

termux_step_pre_configure() {
	autoreconf -fiv
}
