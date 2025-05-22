TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-docklike-plugin/start
TERMUX_PKG_DESCRIPTION="A modern, docklike, minimalist taskbar for XFCE"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-docklike-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=418aa01f51f6528d95ceeb3b19d52bdc0ac554447bdb7afa9975cca5234f244b
# exo is for bin/exo-desktop-item-edit.
TERMUX_PKG_DEPENDS="exo, gdk-pixbuf, glib, gtk3, gtk-layer-shell, libc++, libcairo, libx11, libxi, libxfce4ui, libxfce4util, libxfce4windowing, xfce4-panel"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dwayland=enabled
-Dx11=enabled
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
