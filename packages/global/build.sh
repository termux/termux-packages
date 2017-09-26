TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_VERSION=6.5.7
TERMUX_PKG_SRCURL=http://tamacom.com/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d9c08fa524f9499b54241cb2d72f8a7df01453b6d5e012a63784ded08e3acd32
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
