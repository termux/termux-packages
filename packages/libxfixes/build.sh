# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous 'fixes' extension library"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXfixes-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b695f93cd2499421ab02d22744458e650ccc88c1d4c8130d60200213abc02d58
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
