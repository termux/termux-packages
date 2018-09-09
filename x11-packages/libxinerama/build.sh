TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Xinerama extension library"
TERMUX_PKG_VERSION=1.1.3
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXinerama-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7a45699f1773095a3f821e491cbd5e10c887c5a5fce5d8d3fced15c2ff7698e2
TERMUX_PKG_DEPENDS="libxext"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto"
