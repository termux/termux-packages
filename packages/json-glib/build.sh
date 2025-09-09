TERMUX_PKG_HOMEPAGE=https://wiki.gnome.org/Projects/JsonGlib
TERMUX_PKG_DESCRIPTION="GLib JSON manipulation library"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.10.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/json-glib/${TERMUX_PKG_VERSION%.*}/json-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=77f4bcbf9339528f166b8073458693f0a20b77b7059dbc2db61746a1928b0293
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
