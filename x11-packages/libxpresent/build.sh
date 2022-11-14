TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X Present Extension library"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.1
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXpresent-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b964df9e5a066daa5e08d2dc82692c57ca27d00b8cc257e8e960c9f1cf26231b
TERMUX_PKG_DEPENDS="libx11, libxext, libxfixes, libxrandr"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
