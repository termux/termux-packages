TERMUX_PKG_HOMEPAGE=https://github.com/linuxmint/cinnamon-menus/
TERMUX_PKG_DESCRIPTION="The cinnamon-menu library "
TERMUX_PKG_LICENSE="MIT, LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.4.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/linuxmint/cinnamon-menus/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9cad5ac61900492f66c91810fd13bed9dc37b49ec0b9bbc0bbe9ebf48ee45452
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib, gobject-introspection"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Denable_debug=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_meson

	export TERMUX_MESON_ENABLE_SOVERSION=1
}
