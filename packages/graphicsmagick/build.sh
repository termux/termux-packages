TERMUX_PKG_HOMEPAGE=http://www.graphicsmagick.org/
TERMUX_PKG_DESCRIPTION="Collection of image processing tools"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.37
TERMUX_PKG_REVISION=1
# Bandwith limited on main ftp site, so it's asked to use sourceforge instead:
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/graphicsmagick/graphicsmagick/${TERMUX_PKG_VERSION}/GraphicsMagick-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=90dc22f1a7bd240e4c9065a940962bf13da43c99bcc36cb111cc3c1a0d7477d4
TERMUX_PKG_DEPENDS="libwebp, littlecms, libc++, libtiff, freetype, libjasper, libjpeg-turbo, libpng, libbz2, libxml2, liblzma, zstd, zlib"
TERMUX_PKG_BREAKS="graphicsmagick-dev"
TERMUX_PKG_REPLACES="graphicsmagick++, graphicsmagick-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_func_ftime=no
--with-fontpath=/system/fonts
--without-x
"
