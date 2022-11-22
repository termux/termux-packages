# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="FreeType-based font drawing library for X"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.7
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXft-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=79f0b37c45007381c371a790c2754644ad955166dbf2a48e3625032e9bdd4f71
TERMUX_PKG_DEPENDS="fontconfig, freetype, libx11, libxrender"
