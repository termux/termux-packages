TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=4.15.3
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4ui/${TERMUX_PKG_VERSION:0:4}/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ce89419720da0fa84a3bb46bc447564c5800057c026c272ae0b016918c0a9307
TERMUX_PKG_DEPENDS="gtk2, gtk3, hicolor-icon-theme, libsm, libxfce4util, startup-notification, xfconf"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk3
--with-vendor-info=Termux
"
