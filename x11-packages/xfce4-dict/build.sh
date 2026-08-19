TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/xfce4-dict/start
TERMUX_PKG_DESCRIPTION="Dictionary for XFCE desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.10"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-dict/${TERMUX_PKG_VERSION%.*}/xfce4-dict-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=0a0be97fd056a528a1f37c8db05f5385ffc3dc9945b424cdafa05caf5f054b67
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, harfbuzz, libcairo, libx11, libxfce4ui, libxfce4util, pango, xfce4-panel, zlib"
TERMUX_PKG_SUGGESTS="aspell"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
