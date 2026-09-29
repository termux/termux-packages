# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous 'fixes' extension library"
TERMUX_PKG_LICENSE="HPND, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXfixes-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=39f115d72d9c5f8111e4684164d3d68cc1fd21f9b27ff2401b08fddfc0f409ba
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_AUTO_UPDATE=true
