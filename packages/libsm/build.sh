# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Session Management library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=17
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libSM-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2d264499dcb05f56438dee12a1b4b71d76736ce7ba7aa6efbf15ebb113769cbb
TERMUX_PKG_DEPENDS="libice, libuuid"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros, xtrans"
