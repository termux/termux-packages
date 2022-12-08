TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 keyboard file manipulation library"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libxkbfile-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b8a3784fac420b201718047cfb6c2d5ee7e8b9481564c2667b4215f6616644b1
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
