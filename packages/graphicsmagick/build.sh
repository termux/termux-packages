TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.3.32
TERMUX_PKG_REVISION=1
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=b842a5a0d6c84fd6c5f161b5cd8e02bbd210b0c0b6728dd762b7c53062ba94e1
TERMUX_PKG_DEPENDS="littlecms, libc++, libtiff, freetype, libjasper, libjpeg-turbo, libpng, libbz2, libxml2, liblzma, zstd, zlib"
TERMUX_PKG_REPLACES="graphicsmagick++"
TERMUX_PKG_DEVPACKAGE_REPLACES="graphicsmagick++-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_ftime=no
--with-fontpath=/system/fonts
--without-webp
--without-x
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/*-config"
