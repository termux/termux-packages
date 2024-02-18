TERMUX_PKG_HOMEPAGE=https://github.com/wmww/gtk-layer-shell
TERMUX_PKG_DESCRIPTION="Library to create panels and other desktop components for Wayland using the Layer Shell protocol"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.2"
TERMUX_PKG_SRCURL=git+https://github.com/wmww/gtk-layer-shell
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gtk3, libwayland"
TERMUX_PKG_BUILD_DEPENDS="libwayland-cross-scanner, libwayland-protocols"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Ddocs=false
-Dintrospection=false
-Dtests=false
"

termux_step_pre_configure() {
	export PATH="$TERMUX_PREFIX/opt/libwayland/cross/bin:$PATH"
}
