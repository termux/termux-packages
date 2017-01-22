TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_VERSION=6.5.6
TERMUX_PKG_SRCURL=http://tamacom.com/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=122f9afa69a8daa0f64c12db7f02981fe573f51a163fa3829ed4f832cd281505
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="\
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
