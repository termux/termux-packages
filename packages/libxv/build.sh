# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="Library for the X Video (Xv) extension to the X Window System"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.0.12
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXv-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=aaf7fa09f689f7a2000fe493c0d64d1487a1210db154053e9e2336b860c63848
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
TERMUX_PKG_DEPENDS="libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
