TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xcb.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 client-side library"
TERMUX_PKG_VERSION=1.13
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xcb.freedesktop.org/dist/libxcb-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=188c8752193c50ff2dbe89db4554c63df2e26a2e47b0fa415a70918b5b851daa
TERMUX_PKG_DEPENDS="libxau, libxdmcp"
TERMUX_PKG_BUILD_DEPENDS="xcbproto, xorg-util-macros"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xcbproto"
