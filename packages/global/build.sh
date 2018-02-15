TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_VERSION=6.6.2
TERMUX_PKG_SHA256=43c64711301c2caf40dc56d7b91dd03d2b882a31fa31812bf20de0c8fb2e717f
TERMUX_PKG_SRCURL=http://mirrors.kernel.org/gnu/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
