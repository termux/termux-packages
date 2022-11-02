# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 RandR extension library"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.2
TERMUX_PKG_REVISION=25
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrandr-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8aea0ebe403d62330bb741ed595b53741acf45033d3bda1792f1d4cc3daee023
TERMUX_PKG_DEPENDS="libx11, libxext, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
