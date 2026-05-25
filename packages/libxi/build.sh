# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Input extension library"
TERMUX_PKG_LICENSE="MIT, HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.3"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXi-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=7ad60056f01af4f786cfe93b3a7707447711626fc8da2637bec71a90409babe5
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="libxfixes, xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
