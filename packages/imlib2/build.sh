TERMUX_PKG_HOMEPAGE=https://sourceforge.net/projects/enlightenment/
TERMUX_PKG_DESCRIPTION="Library that does image file loading and saving as well as rendering, manipulation, arbitrary polygon support"
TERMUX_PKG_LICENSE="custom"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING-PLAIN"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.12.6"
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/enlightenment/imlib2-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=250f9752f69dc522e529a81aaa9395705f7fc312ff2453e5de59ac2ba1f2858f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="freetype, gdk-pixbuf, giflib, glib, libandroid-shmem, libbz2, libcairo, libheif, libid3tag, libjpeg-turbo, libjxl, liblzma, libpng, librsvg, libtiff, libwebp, libx11, libxcb, libxext, openjpeg, zlib"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-shmem -lm"
	autoreconf -fi
}
