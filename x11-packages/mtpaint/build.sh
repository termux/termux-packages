TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://mtpaint.sourceforge.net/
TERMUX_PKG_DESCRIPTION="Simple paint program for creating icons and pixel based artwork"
TERMUX_PKG_VERSION=3.40
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/mtpaint/mtpaint-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=ef321d2b404839c7b909bdf5283eb22a37fbdd35b4cc9e380ddc400573d7c890
TERMUX_PKG_DEPENDS="giflib, gtk2, libandroid-glob, littlecms"
TERMUX_PKG_RECOMMENDS="gifsicle"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=${TERMUX_PREFIX}/share/man man GIF jpeg tiff cflags lcms2"

termux_step_pre_configure() {
    export LDFLAGS="${LDFLAGS} -landroid-glob -landroid-shmem"
}
