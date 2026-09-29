TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.7"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fdab590c9bda2d68d55e99c51c7e60c2c8595ae4dcebab9bbbb0795f2a5c8bf7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
