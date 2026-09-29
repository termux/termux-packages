# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 RandR extension library"
TERMUX_PKG_LICENSE="HPND"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.5"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrandr-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=72b922c2e765434e9e9f0960148070bd4504b288263e2868a4ccce1b7cf2767a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxext, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
