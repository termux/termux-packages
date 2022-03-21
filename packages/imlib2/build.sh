TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.7.2
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c15eb370225e3e3c64a6421c3f153a4117958e0a3b395e06926568b4090aa425
TERMUX_PKG_DEPENDS="freetype, giflib, libandroid-shmem, libbz2, libid3tag, libjpeg-turbo, libpng, libtiff, libxext, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
