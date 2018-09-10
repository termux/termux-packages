TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://xorg.freedesktop.org/
TERMUX_PKG_DESCRIPTION="X11 damaged region extension library"
TERMUX_PKG_VERSION=1.1.4
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://xorg.freedesktop.org/releases/individual/lib/libXdamage-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=7c3fe7c657e83547f4822bfde30a90d84524efb56365448768409b77f05355ad
TERMUX_PKG_DEPENDS="libxfixes"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_DEVPACKAGE_DEPENDS="xorgproto"
