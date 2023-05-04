# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Input extension library"
# Licenses: MIT, HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.8.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXi-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=89bfc0e814f288f784202e6e5f9b362b788ccecdeb078670145eacd8749656a7
TERMUX_PKG_DEPENDS="libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
