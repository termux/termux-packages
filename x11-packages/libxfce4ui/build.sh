TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4ui/4.17/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ec5347e108cdfbce6d62a8d6db55d5d0506a7ca67779228dae30af2a4b4595fc
TERMUX_PKG_DEPENDS="gtk2, gtk3, hicolor-icon-theme, libsm, libxfce4util, startup-notification, xfconf, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk3
--with-vendor-info=Termux
--enable-introspection=no
--enable-vala=no
--enable-gtk-doc-html=no
"
