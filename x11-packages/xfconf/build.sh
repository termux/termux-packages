TERMUX_PKG_HOMEPAGE=https://www.xfce.org/
TERMUX_PKG_DESCRIPTION="Flexible, easy-to-use configuration management system"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_MAJOR_VERSION=4.17
TERMUX_PKG_VERSION=${_MAJOR_VERSION}.2
TERMUX_PKG_SRCURL=https://archive.xfce.org/src/xfce/xfconf/${_MAJOR_VERSION}/xfconf-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=e4eefa03cdd3672f928e80bf86f68ba9e9ea3e1ee8208f8d964610c416ee8db0
TERMUX_PKG_DEPENDS="dbus, libxfce4util"
TERMUX_PKG_BUILD_DEPENDS="g-ir-scanner"
TERMUX_PKG_DISABLE_GIR=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--enable-introspection=yes
--enable-vala=no
"

termux_step_pre_configure() {
	termux_setup_gir
}
