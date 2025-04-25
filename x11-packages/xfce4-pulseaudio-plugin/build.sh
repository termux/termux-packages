TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-pulseaudio-plugin/start
TERMUX_PKG_DESCRIPTION="Pulseaudio plugin for the Xfce4 panel"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.5.1"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-pulseaudio-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-pulseaudio-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8e1f3a505f37aa3bc2816a58bec5f9555366f1c476f10eab59fd0e6581d08c47
TERMUX_PKG_DEPENDS="exo, gdk-pixbuf, glib, gtk3, libcairo, libcanberra, libnotify, libxfce4ui, libxfce4util, libxfce4windowing, pavucontrol, pulseaudio, xfce4-panel, xfconf"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
