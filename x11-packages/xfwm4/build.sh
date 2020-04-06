TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Window manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.14.0
TERMUX_PKG_REVISION=7
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfwm4/${TERMUX_PKG_VERSION:0:4}/xfwm4-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b4182bf8dc63d092f120a51fcae0eb54b9bd4aa4f8486f47e5a65a108322b615
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libepoxy, libwnck, libxfce4ui, startup-notification, xfconf"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-startup-notification
--enable-randr
--enable-compositor
--enable-xsync
"
