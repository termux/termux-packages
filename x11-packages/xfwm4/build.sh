TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Window manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.1
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfwm4/${_MAJOR_VERSION}/xfwm4-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e1ace7ef000687dd93b393f493bc61771215da5b2752813b8a3b3a18d2725909
TERMUX_PKG_DEPENDS="gdk-pixbuf, glib, gtk3, libcairo, libepoxy, libwnck, libx11, libxcomposite, libxdamage, libxext, libxfce4ui, libxfce4util, libxfixes, libxinerama, libxrandr, libxrender, pango, startup-notification, xfconf"
TERMUX_PKG_RECOMMENDS="hicolor-icon-theme"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-startup-notification
--enable-randr
--enable-compositor
--enable-xsync
"
