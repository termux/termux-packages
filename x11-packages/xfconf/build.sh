TERMUX_PKG_HOMEPAGE=https://docs.xfce.org/xfce/xfconf/start
TERMUX_PKG_DESCRIPTION="Flexible, easy-to-use configuration management system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.20.0"
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfconf/${TERMUX_PKG_VERSION%.*}/xfconf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8bc43c60f1716b13cf35fc899e2a36ea9c6cdc3478a8f051220eef0f53567efd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, libxfce4util"
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
	termux_setup_glib_cross_pkg_config_wrapper
}
