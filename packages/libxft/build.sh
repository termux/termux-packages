# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="FreeType-based font drawing library for X"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.8
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXft-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5e8c3c4bc2d4c0a40aef6b4b38ed2fb74301640da29f6528154b5009b1c6dd49
TERMUX_PKG_DEPENDS="fontconfig, freetype, libx11, libxrender"
