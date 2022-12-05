TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Composite extension library"
# Licenses: HPND, MIT
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXcomposite-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=fe40bcf0ae1a09070eba24088a5eb9810efe57453779ec1e20a55080c6dc2c87
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorgproto, xorg-util-macros"
