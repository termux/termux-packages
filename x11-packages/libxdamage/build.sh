TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 damaged region extension library"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXdamage-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=52733c1f5262fca35f64e7d5060c6fcd81a880ba8e1e65c9621cf0727afb5d11
TERMUX_PKG_DEPENDS="libx11, libxfixes"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
