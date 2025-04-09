TERMUX_PKG_HOMEPAGE=https://github.com/wmww/gtk-layer-shell
TERMUX_PKG_DESCRIPTION="Library to create panels and other desktop components for Wayland using the Layer Shell protocol"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.1"
TERMUX_PKG_SRCURL=git+https://github.com/wmww/gtk-layer-shell
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gtk3, libwayland"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dintrospection=true
-Dtests=false
-Dvapi=true
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_wayland_cross_pkg_config_wrapper
}
