TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.6.8
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6f93d9732a07175817907d26640a90dc1009918e02be761bba09d1fa068357cd
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
