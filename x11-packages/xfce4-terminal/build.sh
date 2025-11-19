TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/terminal/start
TERMUX_PKG_DESCRIPTION="Terminal Emulator for the XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.5"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-terminal/${TERMUX_PKG_VERSION%.*}/xfce4-terminal-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3c5b1d3a01a9a113852ac0f77d1c85bf3a356b43de33ec805b21ceca7d6f0a63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtk-layer-shell, libcairo, libvte, libx11, libxfce4ui, libxfce4util, pango, pcre2, xfconf"
TERMUX_PKG_RECOMMENDS="desktop-file-utils, hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dgtk-layer-shell=enabled
-Dwayland=enabled
-Dx11=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
