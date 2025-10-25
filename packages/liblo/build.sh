TERMUX_PKG_HOMEPAGE=https://liblo.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A lightweight library that provides an easy to use implementation of the OSC protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.34"
# https://downloads.sourceforge.net/liblo/liblo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/radarsat1/liblo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e9a294c7613e1bec2abcf26f2010604643d605ed6852e16b51837400729fcbee
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-doc
"

termux_step_pre_configure() {
	autoreconf -fiv
}
