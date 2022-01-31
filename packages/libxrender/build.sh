# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X Rendering Extension client library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.10
TERMUX_PKG_REVISION=14
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrender-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c06d5979f86e64cabbde57c223938db0b939dff49fdb5a793a1d3d0396650949
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
