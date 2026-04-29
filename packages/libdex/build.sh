TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/libdex
TERMUX_PKG_DESCRIPTION="Future-based programming for GLib-based applications"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.0.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/libdex/${TERMUX_PKG_VERSION%.*}/libdex-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7b8f5c5db3796e14e12e10422e2356766ba830b92815fee70bbc867b5b207f5d
TERMUX_PKG_DEPENDS="glib, gobject-introspection, libsoup3, libucontext"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	export TERMUX_MESON_ENABLE_SOVERSION=1
}
