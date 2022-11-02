TERMUX_PKG_HOMEPAGE=https://mate-panel.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-panel contains the MATE panel, the libmate-panel-applet library and several applets"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_VERSION=1.26.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-panel/releases/download/v$TERMUX_PKG_VERSION/mate-panel-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=aec4f98c89c59e76cc0656ed0482f1d82912f4decc660f21c8d004e493e05410
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libmateweather, libsm, libwnck, libx11, libxrandr, mate-desktop, mate-menus, pango"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

termux_step_pre_configure() {
	termux_setup_gir
}
