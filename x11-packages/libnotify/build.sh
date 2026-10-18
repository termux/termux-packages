TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/notification-spec/
TERMUX_PKG_DESCRIPTION="Library for sending desktop notifications"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.9"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libnotify/${TERMUX_PKG_VERSION%.*}/libnotify-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=c906bb084027ea512f94a60fbfc0cc8d4f17e4b4d525bed370d07a6d8714c923
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
