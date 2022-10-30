# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous extensions library"
# Licenses: MIT, HPND, ISC
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.5
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXext-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=db14c0c895c57ea33a8559de8cb2b93dc76c42ea4a39e294d175938a133d7bca
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
