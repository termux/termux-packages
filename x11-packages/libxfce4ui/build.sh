TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.16.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4ui/${TERMUX_PKG_VERSION:0:4}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8b06c9e94f4be88a9d87c47592411b6cbc32073e7af9cbd64c7b2924ec90ceaa
TERMUX_PKG_DEPENDS="gtk2, gtk3, hicolor-icon-theme, libsm, libxfce4util, startup-notification, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk3
--with-vendor-info=Termux
"
