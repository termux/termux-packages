TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/notification-spec/
TERMUX_PKG_DESCRIPTION="Library for sending desktop notifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=0.8
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libnotify/${_MAJOR_VERSION}/libnotify-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=d033e6d4d6ccbf46a436c31628a4b661b36dca1f5d4174fe0173e274f4e62557
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=enabled
-Dgtk_doc=false"

termux_step_pre_configure() {
	termux_setup_gir

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		# Pre-installed headers affect GIR generation:
		rm -rf "$TERMUX_PREFIX/include/libnotify"
	fi
}
