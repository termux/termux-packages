TERMUX_PKG_HOMEPAGE=https://github.com/raboof/nethogs
TERMUX_PKG_DESCRIPTION="Net top tool grouping bandwidth per process"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Pierre Rudloff <contact@rudloff.pro>"
TERMUX_PKG_VERSION=0.8.5-git
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/raboof/nethogs/archive/master.tar.gz
TERMUX_PKG_SHA256=846560132c7162fe5f90bd6264b877f7a7c132b4aa13bf56763292ef09150bb4
TERMUX_PKG_FOLDERNAME=nethogs-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="libc++, ncurses, libpcap"
TERMUX_PKG_EXTRA_MAKE_ARGS="nethogs"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"
}
