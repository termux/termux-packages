TERMUX_PKG_HOMEPAGE="http://www.gnu.org/software/global/global.html"
TERMUX_PKG_DESCRIPTION="GNU global source code tag system that works the same way across diverse environments"
TERMUX_PKG_VERSION=6.4
TERMUX_PKG_SRCURL=http://tamacom.com/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-posix-sort=$TERMUX_PREFIX/bin/sort"
# coreutils provides the posix sort executable:
# libtool provides the libltdl.so shared library (but should be split to separate package):
TERMUX_PKG_DEPENDS="coreutils, libtool, ncurses"
