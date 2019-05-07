TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.3.31
TERMUX_PKG_REVISION=6
TERMUX_PKG_SHA256=096bbb59d6f3abd32b562fc3b34ea90d88741dc5dd888731d61d17e100394278
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_DEPENDS="littlecms, libtiff, freetype, libjasper, libjpeg-turbo, libpng, libbz2, libxml2, liblzma, zstd, zlib"
TERMUX_PKG_REPLACES="graphicsmagick++"
TERMUX_PKG_DEVPACKAGE_REPLACES="graphicsmagick++-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_ftime=no
--with-fontpath=/system/fonts
--without-webp
--without-x
"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/*-config"
