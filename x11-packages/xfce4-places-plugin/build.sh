TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/panel-plugins/xfce4-places-plugin/start
TERMUX_PKG_DESCRIPTION="This plugin brings much of the functionality of GNOME Places menu to Xfce"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION="1.9.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/panel-plugins/xfce4-places-plugin/${TERMUX_PKG_VERSION%.*}/xfce4-places-plugin-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=76d95687e0bea267465e832eea6266563a18d2219192f9e8af6f88e899262e43
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="exo, gdk-pixbuf, glib, gtk3, libcairo, libnotify, libxfce4ui, libxfce4util, xfce4-panel, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dlibnotify=enabled
"
