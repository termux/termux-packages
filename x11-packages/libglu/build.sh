TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://cgit.freedesktop.org/mesa/glu/
TERMUX_PKG_DESCRIPTION="Mesa OpenGL Utility library"
TERMUX_PKG_VERSION=9.0.0
TERMUX_PKG_SRCURL=ftp://ftp.freedesktop.org/pub/mesa/glu/glu-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=1f7ad0d379a722fcbd303aa5650c6d7d5544fde83196b42a73d1193568a4df12
TERMUX_PKG_DEPENDS="libandroid-shmem, libandroid-support, libc++, libdrm, libexpat, libmesa, libx11, libxau, libxcb, libxdamage, libxdmcp, libxext, libxfixes, libxshmfence"
