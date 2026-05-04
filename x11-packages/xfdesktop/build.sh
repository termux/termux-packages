TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfdesktop/start
TERMUX_PKG_DESCRIPTION="A desktop manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfdesktop/${TERMUX_PKG_VERSION%.*}/xfdesktop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1d9bd76015fb6e9aca05e73cd998c7c66ed4fc8c10b626e08fc2eb7c39df3f7b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exo, garcon, gdk-pixbuf, glib, gtk3, gtk-layer-shell, libcairo, libnotify, libwnck, libx11, libxfce4ui, libxfce4util, libxfce4windowing, libyaml, pango, thunar, xfconf"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--disable-tests
--enable-file-icons
--enable-notifications
--enable-thunarx
--enable-wayland
--enable-x11
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
