TERMUX_PKG_HOMEPAGE="https://github.com/mate-desktop/mate-desktop"
TERMUX_PKG_DESCRIPTION="mate-desktop contains the libmate-desktop library, the mate-about program as well as some desktop-wide documents."
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.3"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-desktop/releases/download/v$TERMUX_PKG_VERSION/mate-desktop-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d9262551365bf4ad24d8f28271f729a1fcc889f7688be34f658707da2c098992
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dconf, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libwayland, libx11, libxrandr, pango, startup-notification, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, iso-codes, libwayland-cross-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_wayland_cross_pkg_config_wrapper
}
