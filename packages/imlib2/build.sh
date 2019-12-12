TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.6.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=672a8abed2f6531ff09b69449f58dfb723a0fd6560d6f94a71e7abdb77d6f987
TERMUX_PKG_DEPENDS="freetype, giflib, libandroid-shmem, libbz2, libid3tag, libjpeg-turbo, libpng, libtiff, libxext, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
