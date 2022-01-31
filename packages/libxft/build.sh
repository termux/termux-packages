# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="FreeType-based font drawing library for X"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.3
TERMUX_PKG_REVISION=13
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXft-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=225c68e616dd29dbb27809e45e9eadf18e4d74c50be43020ef20015274529216
TERMUX_PKG_DEPENDS="fontconfig, freetype, libbz2, liblzma, libpng, libuuid, libx11, libxau, libxcb, libxdmcp, libxml2, libxrender"
