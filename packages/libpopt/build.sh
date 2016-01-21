TERMUX_PKG_HOMEPAGE=http://www.linuxfromscratch.org/blfs/view/svn/general/popt.html
TERMUX_PKG_DESCRIPTION="Library for parsing cmdline parameters"
TERMUX_PKG_VERSION=1.16
TERMUX_PKG_SRCURL=http://rpm5.org/files/popt/popt-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="libandroid-glob"

LDFLAGS+=" -landroid-glob"
