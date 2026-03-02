TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfce4-session/start
TERMUX_PKG_DESCRIPTION="A session manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.4"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfce4-session/${TERMUX_PKG_VERSION%.*}/xfce4-session-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=805c373378d080754d69dd2f20db95cdc066c89a4f024a41435ca0d66571c402
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="atk, gdk-pixbuf, glib, gtk3, gtk-layer-shell, libcairo, libice, libsm, libwnck, libx11, libxfce4ui, libxfce4util, libxfce4windowing, pango, xfconf, xorg-iceauth, xorg-xrdb"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="gnupg, hicolor-icon-theme, xfce4-settings, xfdesktop, xfwm4"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_ICEAUTH=${TERMUX_PREFIX}/bin/iceauth
--disable-debug
--enable-gtk-layer-shell
--enable-wayland
--enable-x11
--with-wayland-session-prefix=${TERMUX_PREFIX}
--with-xsession-prefix=${TERMUX_PREFIX}
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
