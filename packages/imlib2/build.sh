TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING-PLAIN"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.9.0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=5ac9e8ca7c6700919fe72749ad7243c42de4b22823c81769a1bf8e480e14c650
TERMUX_PKG_DEPENDS="freetype, giflib, libandroid-shmem, libbz2, libid3tag, libjpeg-turbo, libpng, libtiff, libxext, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
