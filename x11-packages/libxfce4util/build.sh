TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/libxfce4util/start
TERMUX_PKG_DESCRIPTION="Basic utility non-GUI functions for XFCE"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/libxfce4util/${TERMUX_PKG_VERSION%.*}/libxfce4util-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=21493f9c9995a282823db93839f6b9f06ae31edb094191ba9acf04d932a2b592
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner, valac, xfce4-dev-tools"
TERMUX_PKG_VERSIONED_GIR=false
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-debug
--enable-introspection=yes
--enable-vala=yes
--enable-gtk-doc-html=no
"

termux_step_pre_configure() {
	termux_setup_gir
}
