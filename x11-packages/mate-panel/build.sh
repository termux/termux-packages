TERMUX_PKG_HOMEPAGE=https://mate-panel.mate-desktop.dev/
TERMUX_PKG_DESCRIPTION="mate-panel contains the MATE panel, the libmate-panel-applet library and several applets"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=1.24.2
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/mate-desktop/mate-panel/releases/download/v$TERMUX_PKG_VERSION/mate-panel-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=30c5ba0392ec76b110220ee6d10bbdba76af36586592a6b3d604db70602848ea
TERMUX_PKG_DEPENDS="libsm, gtk3, libice, mate-desktop, mate-menus, libwnck, libmateweather, librsvg"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
"
TERMUX_PKG_RM_AFTER_INSTALL="share/glib-2.0/schemas/gschemas.compiled"

termux_step_pre_configure() {
	termux_setup_gir
}
