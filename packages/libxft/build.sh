# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="FreeType-based font drawing library for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXft-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=60a6e7319fc938bbb8d098c9bcc86031cc2327b5d086d3335fc5c76323c03022
TERMUX_PKG_DEPENDS="fontconfig, freetype, libbz2, liblzma, libpng, libuuid, libx11, libxau, libxcb, libxdmcp, libxml2, libxrender"
