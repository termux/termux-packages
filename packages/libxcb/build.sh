# X11 package
TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libxcb-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=a55ed6db98d43469801262d81dc2572ed124edc3db31059d4e9916eb9f844c34
TERMUX_PKG_DEPENDS="libxau, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xcb-proto, xorg-util-macros"
TERMUX_PKG_RECOMMENDS="xorg-xauth"
