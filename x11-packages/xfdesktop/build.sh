TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfdesktop/start
TERMUX_PKG_DESCRIPTION="A desktop manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfdesktop/${TERMUX_PKG_VERSION%.*}/xfdesktop-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=227041ba80c7f3eb9c99dec817f1132b35d8aec7a4335703f61ba1735cd65632
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
