TERMUX_PKG_HOMEPAGE=https://mattjakeman.com/apps/extension-manager
TERMUX_PKG_DESCRIPTION="Native tool for browsing, installing, and managing GNOME Shell Extensions"
TERMUX_PKG_LICENSE="GPL-3.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.5"
TERMUX_PKG_SRCURL="https://github.com/mjakeman/extension-manager/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=5a43c7b9570775948a35f402b1c1d5f0f0401e339ab2144d466f75eae26ef9de
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gtk4, json-glib, libadwaita, libsoup3, libxml2"
TERMUX_PKG_BUILD_DEPENDS="blueprint-compiler, glib, glib-cross, g-ir-scanner, gobject-introspection"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dpackage=Termux
-Dbacktrace=false
"

termux_step_pre_configure() {
	termux_setup_meson
	termux_setup_glib_cross_pkg_config_wrapper
	termux_setup_bpc
	export TERMUX_MESON_ENABLE_SOVERSION=1
}
