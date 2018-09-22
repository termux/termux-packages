TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 miscellaneous micro-utility library"
TERMUX_PKG_VERSION=1.1.2
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXmu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=756edc7c383254eef8b4e1b733c3bf1dc061b523c9f9833ac7058378b8349d0b
TERMUX_PKG_DEPENDS="libxext, libxt"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
