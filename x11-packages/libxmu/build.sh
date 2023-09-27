TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous micro-utility library"
# Licenses: MIT, HPND, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXmu-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=210de3ab9c3e9382572c25d17c2518a854ce6e2c62c5f8315deac7579e758244
TERMUX_PKG_DEPENDS="libx11, libxext, libxt"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
