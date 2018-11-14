TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=http://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b25df9347648cf3dfb784c099139ab24157b1dbd1baa9428f103b683b8a78c61
TERMUX_PKG_DEPENDS="freetype, giflib, libandroid-shmem, libbz2, libid3tag, libjpeg-turbo, libpng, libtiff, libxext"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
