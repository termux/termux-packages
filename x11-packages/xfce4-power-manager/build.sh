TERMUX_PKG_HOMEPAGE="https://docs.xfce.org/xfce/xfce4-power-manager/start"
TERMUX_PKG_DESCRIPTION="Power Manager for Xfce"
TERMUX_PKG_LICENSE="GPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.1"
TERMUX_PKG_SRCURL="https://archive.xfce.org/src/xfce/xfce4-power-manager/${TERMUX_PKG_VERSION%.*}/xfce4-power-manager-${TERMUX_PKG_VERSION}.tar.bz2"
TERMUX_PKG_SHA256=4fe18ef5f89c5ca9b96dde84dbd88ca7e36af1caf70ddd6429dc72128007edf7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libc++, libnotify, libxfce4ui, upower, xfce4-notifyd"
TERMUX_PKG_BUILD_DEPENDS="glib, libwayland-protocols, xfce4-dev-tools, xfce4-panel"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
