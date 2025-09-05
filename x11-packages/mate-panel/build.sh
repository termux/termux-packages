TERMUX_PKG_HOMEPAGE=https://mate-panel.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-panel contains the MATE panel, the libmate-panel-applet library and several applets"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_VERSION="1.28.6"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-panel/releases/download/v$TERMUX_PKG_VERSION/mate-panel-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=1e37820cc4a95c7375500324f62a146e807a80be27e6e18de7772432951d5d45
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libmateweather, libsm, libwnck, libx11, libxrandr, mate-desktop, mate-menus, pango, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"

termux_step_pre_configure() {
	termux_setup_gir
}
