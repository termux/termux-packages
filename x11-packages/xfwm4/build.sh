TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfwm4/start
TERMUX_PKG_DESCRIPTION="Window manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfwm4/${TERMUX_PKG_VERSION%.*}/xfwm4-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a58b63e49397aa0d8d1dcf0636be93c8bb5926779aef5165e0852890190dcf06
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libepoxy, libwnck, libx11, libxcomposite, libxdamage, libxext, libxfce4ui, libxfce4util, libxfixes, libxinerama, libxpresent, libxrandr, libxrender, pango, startup-notification, xfconf"
TERMUX_PKG_BUILD_DEPENDS="xfce4-dev-tools"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--enable-startup-notification
--enable-randr
--enable-compositor
--enable-xsync
"
