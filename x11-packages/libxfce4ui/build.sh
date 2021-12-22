TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Commonly used XFCE widgets among XFCE applications"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.2
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4ui/4.17/libxfce4ui-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c3ba2056dd4d515db5a14b1a589b7afc88e4e2662e27fe93e2054a0e9d09df24
TERMUX_PKG_DEPENDS="gtk2, gtk3, hicolor-icon-theme, libsm, libxfce4util, startup-notification, xfconf, glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-gtk3
--with-vendor-info=Termux
--enable-introspection=no
--enable-vala=no
--enable-gtk-doc-html=no
"
