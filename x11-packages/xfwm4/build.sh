TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Window manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.1
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfwm4/${TERMUX_PKG_VERSION:0:4}/xfwm4-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8494d1c79c8254c2e222cb8247dce928e5bb7254bfd53202f6a437f3fbaecac4
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libepoxy, libwnck, libxfce4ui, startup-notification, xfconf"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-startup-notification
--enable-randr
--enable-compositor
--enable-xsync
"
