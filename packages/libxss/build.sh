# X11 package
TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Screen Saver extension library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.5"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXScrnSaver-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5057365f847253e0e275871441e10ff7846c8322a5d88e1e187d326de1cd8d00
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libx11, libxau, libxcb, libxdmcp, libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--enable-malloc0returnsnull"
