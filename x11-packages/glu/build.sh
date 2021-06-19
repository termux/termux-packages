TERMUX_PKG_HOMEPAGE=https://cgit.freedesktop.org/mesa/glu/
TERMUX_PKG_DESCRIPTION="Mesa OpenGL Utility library"
TERMUX_PKG_LICENSE="LGPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=9.0.1
TERMUX_PKG_REVISION=18
TERMUX_PKG_SRCURL=https://mesa.freedesktop.org/archive/glu/glu-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f6f484cfcd51e489afe88031afdea1e173aa652697e4c19ddbcb8260579a10f7

TERMUX_PKG_DEPENDS="libandroid-shmem, libc++, libdrm, libexpat, libx11, libxau, libxcb, libxdamage, libxdmcp, libxext, libxfixes, libxshmfence, mesa, zlib"
TERMUX_PKG_CONFLICTS="libglu"
TERMUX_PKG_REPLACES="libglu"
