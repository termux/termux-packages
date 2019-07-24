TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=6.6.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=cbee98ef6c1b064bc5b062d14a6d94dca67289e8374860817057db7688bc651c
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
