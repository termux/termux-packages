TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Window manager for XFCE environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.14.2
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/xfwm4/${TERMUX_PKG_VERSION:0:4}/xfwm4-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=b15b40342596a3b6ab5167a58371262adf5484e165cb25a31fef42f0aa8ffd92
TERMUX_PKG_DEPENDS="hicolor-icon-theme, libepoxy, libwnck, libxfce4ui, startup-notification, xfconf"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-startup-notification
--enable-randr
--enable-compositor
--enable-xsync
"
