TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Basic utility non-GUI functions for XFCE"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.18.2"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4util/${TERMUX_PKG_VERSION%.*}/libxfce4util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d9a329182b78f7e2520cd4aafcbb276bbbf162f6a89191676539ad2e3889c353
# Prevent updating to unstable branch
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=yes
--enable-gtk-doc-html=no
"

termux_step_pre_configure() {
	TERMUX_PKG_VERSION=. termux_setup_gir
}
