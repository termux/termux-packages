TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/notification-spec/
TERMUX_PKG_DESCRIPTION="Library for sending desktop notifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.3"
TERMUX_PKG_SRCURL=https://ftp.gnome.org/pub/GNOME/sources/libnotify/${TERMUX_PKG_VERSION%.*}/libnotify-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ee8f3ef946156ad3406fdf45feedbdcd932dbd211ab4f16f75eba4f36fb2f6c0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=enabled
-Dgtk_doc=false"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		# Pre-installed headers affect GIR generation:
		rm -rf "$TERMUX_PREFIX/include/libnotify"
	fi
}
