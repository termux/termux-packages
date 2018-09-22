TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X cursor management library"
TERMUX_PKG_VERSION=1.1.15
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXcursor-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=294e670dd37cd23995e69aae626629d4a2dfe5708851bbc13d032401b7a3df6b
TERMUX_PKG_DEPENDS="libxcb, libxfixes, libxrender"
TERMUX_PKG_BUILD_DEPENDS="xorg-util-macros"
