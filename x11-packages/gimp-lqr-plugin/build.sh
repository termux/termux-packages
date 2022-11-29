TERMUX_PKG_HOMEPAGE=https://github.com/carlobaldassi/gimp-lqr-plugin
TERMUX_PKG_DESCRIPTION="LiquidRescale plug-in for seam carving in GIMP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.2
TERMUX_PKG_SRCURL=https://github.com/carlobaldassi/gimp-lqr-plugin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=a01ffdfc04e97167413b4bb11516d3bad28dadb84bbfacb5e6ed21959483ebe1
TERMUX_PKG_DEPENDS="gdk-pixbuf, gimp, glib, gtk2, liblqr"

termux_step_pre_configure() {
	CFLAGS+=" -fcommon"
}
