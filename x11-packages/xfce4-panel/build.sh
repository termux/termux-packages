TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-panel/start
TERMUX_PKG_DESCRIPTION="Panel for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-panel/${TERMUX_PKG_VERSION%.*}/xfce4-panel-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2f7ffaf216b4dfdb1ae4c8e3cf8b9c5cb44ec43a64b80bd1608fb5dc3bde2c5d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, exo, garcon, gdk-pixbuf, glib, gtk3, gtk-layer-shell, harfbuzz, libcairo, libdisplay-info, libice, libsm, libwayland, libwnck, libx11, libxext, libxrandr, libxfce4ui, libxfce4util, libxfce4windowing, pango, xfconf, zlib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-static
--enable-gtk-doc-html=no
--enable-gtk-layer-shell
--enable-introspection=yes
--enable-vala=no
--enable-wayland
--enable-x11
--disable-dbusmenu-gtk3
"

termux_step_pre_configure() {
	termux_setup_gir
	termux_setup_glib_cross_pkg_config_wrapper
}
