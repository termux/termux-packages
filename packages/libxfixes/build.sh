# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous 'fixes' extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=6.0.0
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXfixes-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=a7c1a24da53e0b46cac5aea79094b4b2257321c621b258729bc3139149245b4c
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
