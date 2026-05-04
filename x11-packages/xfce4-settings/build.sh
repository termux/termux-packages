TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-settings/start
TERMUX_PKG_DESCRIPTION="Settings manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-settings/${TERMUX_PKG_VERSION%.*}/xfce4-settings-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ad5c3c5bfb36f5eb091c05897d60f468d0d5cc4364c8d1d38ca53d8bb04387da
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, exo, fontconfig, garcon, gdk-pixbuf, glib, gtk3, gtk-layer-shell, harfbuzz, libcairo, libnotify, libwayland, libx11, libxcursor, libxfce4ui, libxfce4util, libxi, libxklavier, libxrandr, pango, xfconf, zlib"
TERMUX_PKG_RECOMMENDS="gsettings-desktop-schemas, libcanberra, lxde-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--enable-wayland
--enable-x11
--enable-xrandr
--enable-xcursor
--enable-gtk-layer-shell
--enable-libnotify
--enable-libxklavier
--enable-pluggable-dialogs
--enable-sound-settings
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
