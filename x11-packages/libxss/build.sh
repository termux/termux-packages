TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Screen Saver extension library"
TERMUX_PKG_VERSION=1.2.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXScrnSaver-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8ff1efa7341c7f34bcf9b17c89648d6325ddaae22e3904e091794e0b4426ce1d
TERMUX_PKG_DEPENDS="libx11"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
