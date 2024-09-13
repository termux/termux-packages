TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING-PLAIN"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=96244656576a3e0a6f58b78e514ddc919622ac6806711bc231837eee62c1de34
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, gdk-pixbuf, giflib, glib, libandroid-shmem, libbz2, libcairo, libheif, libid3tag, libjpeg-turbo, libjxl, liblzma, libpng, librsvg, libtiff, libwebp, libx11, libxcb, libxext, openjpeg, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="LIBS=-landroid-shmem"
