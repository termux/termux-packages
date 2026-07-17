TERMUX_PKG_HOMEPAGE=https://gitlab.gnome.org/GNOME/jsonrpc-glib
TERMUX_PKG_DESCRIPTION="A JSON-RPC library for GLib"
TERMUX_PKG_LICENSE="LGPL-2.1-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.44.2"
TERMUX_PKG_SRCURL=https://download.gnome.org/sources/jsonrpc-glib/${TERMUX_PKG_VERSION%.*}/jsonrpc-glib-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=965496b6e1314f3468b482a5d80340dc3b0340a5402d7783cad24154aee77396
TERMUX_PKG_DEPENDS="glib, gobject-introspection, json-glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, glib-cross"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
