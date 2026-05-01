TERMUX_PKG_HOMEPAGE=https://liblo.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A lightweight library that provides an easy to use implementation of the OSC protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.35"
# https://downloads.sourceforge.net/liblo/liblo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/radarsat1/liblo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d3d807faa89fc42a5f2468246d212decfa7d2775da879d6aaaa97768aaf8e183
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-doc
"

termux_step_pre_configure() {
	autoreconf -fiv
}
