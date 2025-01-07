TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-clipman-plugin/start
TERMUX_PKG_DESCRIPTION="Clipman is a clipboard manager for Xfce"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.7"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-clipman-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-clipman-plugin-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=9bae27808a50e959e0912b7202ea5d651ed7401a6fc227f811d9bdaf2e44178c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libice, libqrencode, libwayland, libx11, libxfce4ui, libxfce4util, libxtst, pango, xfce4-panel, xfconf, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-libqrencode
--enable-libxtst
--enable-wayland
--enable-x11
"
