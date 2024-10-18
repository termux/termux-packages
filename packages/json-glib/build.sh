TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/json-glib/${TERMUX_PKG_VERSION%.*}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=1bca8d66d96106ecc147df3133b95a5bb784f1fa6f15d06dd7c1a8fb4a10af7b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_BREAKS="json-glib-dev"
TERMUX_PKG_REPLACES="json-glib-dev"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocumentation=disabled
-Dintrospection=enabled
-Dman=true
-Dtests=false
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
