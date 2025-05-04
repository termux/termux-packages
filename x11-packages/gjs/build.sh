TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/Gjs/
TERMUX_PKG_DESCRIPTION="JavaScript Bindings for GNOME"
TERMUX_PKG_LICENSE="MIT, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.84.1"
TERMUX_PKG_SRCURL="https://download.gnome.org/sources/gjs/${TERMUX_PKG_VERSION%.*}/gjs-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=44796b91318dbbe221a13909f00fd872ef92f38c68603e0e3574e46bc6bac32c
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libcairo, libffi, libx11, readline, spidermonkey"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Db_pch=false
-Dinstalled_tests=false
-Dskip_dbus_tests=true
-Dskip_gtk_tests=true
-Dskip_tests=true
"

termux_step_post_get_source() {
	# Do not use meson wrap projects
	rm -f subprojects/*.wrap
}

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
