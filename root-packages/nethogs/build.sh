TERMUX_PKG_HOMEPAGE=https://github.com/raboof/nethogs
TERMUX_PKG_DESCRIPTION="Net top tool grouping bandwidth per process"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Pierre Rudloff <contact@rudloff.pro>"
TERMUX_PKG_VERSION=0.8.5-git
TERMUX_PKG_SRCURL=https://github.com/raboof/nethogs/archive/master.tar.gz
TERMUX_PKG_SHA256=b52b99af92be0aa44afda86ee35001df3d592aa7901a4bd8d427ae06f2827f9c
TERMUX_PKG_FOLDERNAME=nethogs-${TERMUX_PKG_VERSION}
TERMUX_PKG_DEPENDS="ncurses, libpcap"
TERMUX_PKG_EXTRA_MAKE_ARGS="nethogs"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure () {
	export CPPFLAGS="$CPPFLAGS -Wno-c++11-narrowing"
}

