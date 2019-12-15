TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.0
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4ui/${TERMUX_PKG_VERSION:0:4}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=f9b6c95a871892348d317e9c0d24d3a2de6af6ca8e4f687d0a412c029c9984e1
TERMUX_PKG_DEPENDS="gtk2, gtk3, hicolor-icon-theme, libsm, libxfce4util, startup-notification, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk3
--with-vendor-info=Termux
"
