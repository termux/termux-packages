TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/start
TERMUX_PKG_DESCRIPTION="Pulseaudio plugin for the Xfce4 panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-pulseaudio-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-pulseaudio-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=3fe69bc6f9c0dd68bd317c0a7813975cf162ba1dd64e23c2ffef372d4b4f808a
TERMUX_PKG_DEPENDS="exo, gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libnotify, libxfce4ui, libxfce4util, libxfce4windowing, pulseaudio, xfce4-panel, xfconf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
