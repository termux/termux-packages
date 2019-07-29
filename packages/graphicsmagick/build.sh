TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.3.33
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=130cb330a633580b5124eba5c125bbcbc484298423a97b9bed37ccd50d6dc778
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
