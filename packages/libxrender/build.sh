# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X Rendering Extension client library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.11
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrender-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=bc53759a3a83d1ff702fb59641b3d2f7c56e05051fa0cfa93501166fa782dc24
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
