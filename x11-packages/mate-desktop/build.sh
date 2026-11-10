TERMUX_PKG_HOMEPAGE="https://github.com/mate-desktop/mate-desktop"
TERMUX_PKG_DESCRIPTION="mate-desktop contains the libmate-desktop library, the mate-about program as well as some desktop-wide documents."
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.29.1"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-desktop/releases/download/v$TERMUX_PKG_VERSION/mate-desktop-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=c6860f585fbd36a2f5c3f16e50b69e5af1393f2712329a60d78dd5d091467542
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, dconf, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libx11, libxrandr, pango, startup-notification, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, iso-codes"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
