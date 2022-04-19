TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Basic utility non-GUI functions for XFCE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.17.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=http://archive.xfce.org/src/xfce/libxfce4util/4.17/libxfce4util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1942151f3c1f3732bc53dd9fd3b936f62067796dc47a33c60a0ad05d933d90f2
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-introspection=no --enable-vala=no --enable-gtk-doc-html=no"
