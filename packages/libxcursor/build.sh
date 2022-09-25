# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X cursor management library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXcursor-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=46c143731610bafd2070159a844571b287ac26192537d047a39df06155492104
TERMUX_PKG_DEPENDS="libx11, libxfixes, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
