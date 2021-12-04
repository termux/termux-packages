TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Window manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.16.1
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfwm4/${TERMUX_PKG_VERSION:0:4}/xfwm4-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b5b24ca04bd73c642db0a4b4df81d262381d758f01b51108257d48b391b8718c
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libepoxy, libwnck, libxfce4ui, startup-notification, xfconf"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-startup-notification
--enable-randr
--enable-compositor
--enable-xsync
"
