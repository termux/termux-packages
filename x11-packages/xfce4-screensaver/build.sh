TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/apps/screensaver/start
TERMUX_PKG_DESCRIPTION="Xfce Screensaver is a screen saver and locker that aims to have simple, sane, secure defaults and be well integrated with the desktop."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="4.20.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/apps/xfce4-screensaver/${TERMUX_PKG_VERSION%.*}/xfce4-screensaver-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5032f60a31df5e50a80512e301b595be5ea6a6bd762cdd95cacc24cbd29a01d7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="dbus, dbus-glib, garcon, gdk-pixbuf, glib, gtk3, libcairo, libwnck, libx11, libxext, libxfce4ui, libxfce4util, libxklavier, libxss, opengl, pango, termux-auth, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dauthentication-scheme=none
-Dsession-manager=none
"

termux_step_pre_configure() {
	termux_setup_glib_cross_pkg_config_wrapper
}
