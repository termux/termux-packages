TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/template-glib
TERMUX_PKG_DESCRIPTION="A templating library for GLib"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.39.0"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/template-glib/${TERMUX_PKG_VERSION%.*}/template-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f388234d65ec3de89e3431d840eb078477ca5407cff26400cce454eb27ef1939
TERMUX_PKG_DEPENDS="glib, gobject-introspection"
TERMUX_PKG_BUILD_DEPENDS="bison, flex, g-ir-scanner, gettext, glib-cross, sed"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
