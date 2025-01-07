# X11 package
TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.17.0"
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libxcb-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=599ebf9996710fea71622e6e184f3a8ad5b43d0e5fa8c4e407123c88a59a6d55
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libxau, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xcb-proto, xorg-util-macros"
TERMUX_PKG_RECOMMENDS="xorg-xauth"
TERMUX_PKG_RM_AFTER_INSTALL="lib/python*"
