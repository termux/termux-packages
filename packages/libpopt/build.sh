TERMUX_PKG_HOMEPAGE=https://www.linuxfromscratch.org/blfs/view/svn/general/popt.html
TERMUX_PKG_DESCRIPTION="Library for parsing cmdline parameters"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.19
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=http://ftp.rpm.org/popt/releases/popt-1.x/popt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c25a4838fc8e4c1c8aacb8bd620edb3084a3d63bf8987fdad3ca2758c63240f9
TERMUX_PKG_DEPENDS="libandroid-glob"
TERMUX_PKG_BREAKS="libpopt-dev"
TERMUX_PKG_REPLACES="libpopt-dev"
TERMUX_PKG_RM_AFTER_INSTALL="lib/libpopt.la"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
