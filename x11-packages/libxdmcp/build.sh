TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Display Manager Control Protocol library"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/archive/individual/lib/libXdmcp-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=81fe09867918fff258296e1e1e159f0dc639cb30d201c53519f25ab73af4e4e2
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
