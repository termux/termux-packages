# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Xlib-based library for XTEST & RECORD extensions"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.5"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXtst-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b50d4c25b97009a744706c1039c598f4d8e64910c9fde381994e1cae235d9242
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxext, libxi"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorg-util-macros"
