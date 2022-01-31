# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous extensions library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_REVISION=11
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXext-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=59ad6fcce98deaecc14d39a672cf218ca37aba617c9a0f691cac3bcd28edf82b
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
TERMUX_PKG_DEPENDS="libx11, libxau, libxcb, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
