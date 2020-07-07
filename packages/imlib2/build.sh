TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=668696d0a8961bb57353fe96669f44bbdf1696221a65da563408a5010c5bd735
TERMUX_PKG_DEPENDS="freetype, giflib, libandroid-shmem, libbz2, libid3tag, libjpeg-turbo, libpng, libtiff, libxext, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
