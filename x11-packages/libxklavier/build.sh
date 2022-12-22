TERMUX_PKG_HOMEPAGE=https://www.freedesktop.org/wiki/Software/LibXklavier/
TERMUX_PKG_DESCRIPTION="High-level API for X Keyboard Extension"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.4
TERMUX_PKG_REVISION=22
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/archived-projects/libxklavier/-/archive/libxklavier-${TERMUX_PKG_VERSION}/libxklavier-libxklavier-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=e1638599e9229e6f6267b70b02e41940b98ba29b3a37e221f6e59ff90100c3da
TERMUX_PKG_DEPENDS="glib, iso-codes, libx11, libxi, libxkbfile, libxml2, xkeyboard-config, xorg-xkbcomp"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection
--with-xkb-base=$TERMUX_PREFIX/share/X11/xkb
--with-xkb-bin-base=$TERMUX_PREFIX/bin
"

termux_step_pre_configure() {
	termux_setup_gir

	NOCONFIGURE=1 ./autogen.sh
}
