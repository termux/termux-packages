# X11 package
TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.15
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libxcb-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=cc38744f817cf6814c847e2df37fcb8997357d72fa4bcbc228ae0fe47219a059
TERMUX_PKG_DEPENDS="libxau, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xcb-proto, xorg-util-macros"
TERMUX_PKG_RECOMMENDS="xorg-xauth"
TERMUX_PKG_RM_AFTER_INSTALL="lib/python*"
