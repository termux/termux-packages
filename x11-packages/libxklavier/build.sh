TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/LibXklavier/
TERMUX_PKG_DESCRIPTION="High-level API for X Keyboard Extension"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=5.4
TERMUX_PKG_REVISION=19
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/archived-projects/libxklavier/-/archive/libxklavier-${TERMUX_PKG_VERSION}/libxklavier-libxklavier-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e1638599e9229e6f6267b70b02e41940b98ba29b3a37e221f6e59ff90100c3da
TERMUX_PKG_DEPENDS="glib, iso-codes, libxi, libxkbfile, libxml2, xkeyboard-config"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-xkb-base=$TERMUX_PREFIX/share/X11/xkb"

termux_step_pre_configure() {
	NOCONFIGURE=1 ./autogen.sh
}
