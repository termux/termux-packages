# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Testing -- Resource extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.3
TERMUX_PKG_REVISION=26
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXtst-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=4655498a1b8e844e3d6f21f3b2c4e2b571effb5fd83199d428a6ba7ea4bf5204
TERMUX_PKG_DEPENDS="libx11, libxext, libxi"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorg-util-macros"
