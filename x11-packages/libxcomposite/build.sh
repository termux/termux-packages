TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 Composite extension library"
TERMUX_PKG_VERSION=0.4.4
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXcomposite-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ede250cd207d8bee4a338265c3007d7a68d5aca791b6ac41af18e9a2aeb34178
TERMUX_PKG_DEPENDS="libxfixes"
TERMUX_PKG_BUILD_DEPENDS="xorgproto, xorg-util-macros"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto"
