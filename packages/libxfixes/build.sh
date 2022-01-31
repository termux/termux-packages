# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous 'fixes' extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.0.3
TERMUX_PKG_REVISION=25
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXfixes-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=de1cd33aff226e08cefd0e6759341c2c8e8c9faf8ce9ac6ec38d43e287b22ad6
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
