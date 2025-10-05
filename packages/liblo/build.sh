TERMUX_PKG_HOMEPAGE=https://liblo.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A lightweight library that provides an easy to use implementation of the OSC protocol"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.33"
# https://downloads.sourceforge.net/liblo/liblo-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SRCURL=https://github.com/radarsat1/liblo/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=0b538bd429e2e47309244912184c00163b5c28154105efe3167f3632e12cfbc7
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	autoreconf -fiv
}
