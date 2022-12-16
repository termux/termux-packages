TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Basic utility non-GUI functions for XFCE"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.18
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.0
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4util/${_MAJOR_VERSION}/libxfce4util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1157ca717fd3dd1da7724a6432a4fb24af9cd922f738e971fd1fd36dfaeac3c9
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=no
--enable-gtk-doc-html=no
"

termux_step_pre_configure() {
	termux_setup_gir
}
