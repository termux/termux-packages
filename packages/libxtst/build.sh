# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Testing -- Resource extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXtst-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=84f5f30b9254b4ffee14b5b0940e2622153b0d3aed8286a3c5b7eeb340ca33c8
TERMUX_PKG_DEPENDS="libx11, libxext, libxi"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorg-util-macros"
