TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 XFree86 video mode extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1.7"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXxf86vm-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ae50c0f669e0af5a67cc4cd0f54f21d64a64d2660af883e80e95d3fe51b945d8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--enable-malloc0returnsnull
"
