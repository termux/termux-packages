TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-dict/start
TERMUX_PKG_DESCRIPTION="Dictionary for XFCE desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.9"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-dict/${TERMUX_PKG_VERSION%.*}/xfce4-dict-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=f1a81baad1e60496aeffc8f8ef1be6413c732b09e250d52d062d293ade001a8c
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libx11, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_SUGGESTS="aspell"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
