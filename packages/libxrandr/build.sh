# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 RandR extension library"
# License: HPND
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrandr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=897639014a78e1497704d669c5dd5682d721931a4452c89a7ba62676064eb428
TERMUX_PKG_DEPENDS="libx11, libxext, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
