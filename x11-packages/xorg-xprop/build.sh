TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Utility to print properties of X11 windows"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="Rafael Kitover <rkitover@gmail.com>"
TERMUX_PKG_VERSION=1.2.6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/app/xprop-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=580b8525b12ecc0144aa16c88b0aafa76d2e799b44c8c6c50f9ce92788b5586e
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
