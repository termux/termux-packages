TERMUX_PKG_HOMEPAGE=https://www.gnu.org/software/global/
TERMUX_PKG_DESCRIPTION="Source code search and browse tools"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.15"
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/global/global-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=cf0937cb3ed521b2ab1acfa7aff45103040b860bb642c4c2f094ac3a3fe86024
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_posix1_2008_realpath=yes
--with-posix-sort=$TERMUX_PREFIX/bin/sort
--with-ncurses=$TERMUX_PREFIX
"
# coreutils provides the posix sort executable:
TERMUX_PKG_DEPENDS="coreutils, ncurses, libltdl"
