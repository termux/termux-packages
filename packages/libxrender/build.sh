TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X Rendering Extension client library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.12"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXrender-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b832128da48b39c8d608224481743403ad1691bf4e554e4be9c174df171d1b97
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--enable-malloc0returnsnull
"
