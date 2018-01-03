TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_VERSION=6.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=943dc440382d82454786bfd92b86946961cb2196039eceffd7eb551ac83759e4
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
