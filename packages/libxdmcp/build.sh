# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Display Manager Control Protocol library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libXdmcp-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=2dce5cc317f8f0b484ec347d87d81d552cdbebb178bd13c5d8193b6b7cd6ad00
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
