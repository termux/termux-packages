# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Display Manager Control Protocol library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.1.3
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libXdmcp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=20523b44aaa513e17c009e873ad7bbc301507a3224c232610ce2e099011c6529
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
