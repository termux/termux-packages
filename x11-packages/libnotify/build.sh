TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/notification-spec/
TERMUX_PKG_DESCRIPTION="Library for sending desktop notifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libnotify/${TERMUX_PKG_VERSION%.*}/libnotify-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c5540aaefb60e1d63b1c587c05f2284ebe72ece7d0c0e5e4a778cfd5844b6b58
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dtests=false
-Dintrospection=enabled
-Dgtk_doc=false"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		# Pre-installed headers affect GIR generation:
		rm -rf "$TERMUX_PREFIX/include/libnotify"
	fi
}
